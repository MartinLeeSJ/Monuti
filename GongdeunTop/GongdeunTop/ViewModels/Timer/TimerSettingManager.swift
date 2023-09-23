//
//  TimerSettingManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/08/18.
//

import Foundation
import SwiftUI
import Combine

extension Session {
    static func getBasicSession() -> Self {
        Session(concentrationSeconds: TimerSettingContraint.basicConcentrationSecond,
                restSeconds: TimerSettingContraint.basicRestSecond)
    }
    static func getBasicLongRestSession() -> Self {
        Session(concentrationSeconds: TimerSettingContraint.basicConcentrationSecond,
                restSeconds: TimerSettingContraint.basicLongRestSecond)
    }
    static func getBasicSessions() -> [Self] {
        var result = Array<Self>()
        
        (0..<TimerSettingContraint.basicSessions).forEach { index in
            result.append(index == TimerSettingContraint.basicSessions - 1  ? getBasicLongRestSession() : getBasicSession())
        }

        return result
    }
    
    static func getRandomLooseSessions() -> [Self] {
        var result = Array<Self>()
        TimerSettingContraint.looseSessionsBound.forEach { _ in
            result.append(
                Session(
                    concentrationSeconds: Int.random(in: TimerSettingContraint.looseConcentrationSecondBound),
                    restSeconds: Int.random(in: TimerSettingContraint.looseRestSecondBound)
                )
            )
        }
        return result
    }
}

final class TimerSettingManager: ObservableObject {
    @Published var timeSetting = TimeSetting()
    @Published var isDefaultSessionsSetting: Bool = true
    @Published var mode: TimeSetMode = .batch
    
    init() {
        $timeSetting
            .map { [weak self] timeSetting in
                self?.knowIsBasicSetting(timeSetting.sessions) ?? true
            }
            .assign(to: &$isDefaultSessionsSetting)
    }
    
    // MARK: - Set Time Info
    func knowIsBasicSetting(_ sessions: [Session]) -> Bool {
        guard sessions.count == TimerSettingContraint.basicSessions else { return false }
        let basicSessions = Session.getBasicSessions()
        return sessions.enumerated().reduce(true) { _, element in
            let (index,session) = element
            let basicSession = basicSessions[index]
            return (basicSession.concentrationSeconds == session.concentrationSeconds) &&
            (basicSession.restSeconds == session.restSeconds)
        }
    }
    
    func getMinute(of seconds: Int) -> Int {
        Int((seconds <= 0 ? 0 : seconds) / 60)
    }
    
    func getSeconds(of seconds: Int) -> Int {
        (seconds <= 0 ? 0 : seconds) % 60
    }
    
    func getTotalSeconds() -> Int {
        timeSetting.sessions.reduce(0) {$0 + $1.sessionSeconds}
    }
    
    //MARK: - Set Time
        func mapAllSessions() {
            timeSetting.sessions = timeSetting.sessions.enumerated().map { (index, _) in
                let isLastIndex: Bool = index == timeSetting.sessions.endIndex - 1
                if isLastIndex {
                    return Session(concentrationSeconds: timeSetting.session.concentrationSeconds,
                                   restSeconds: timeSetting.willGetLongRefresh ? TimeSetting.longRefreshSeconds : 0)
                } else {
                    return Session(concentrationSeconds: timeSetting.session.concentrationSeconds,
                                   restSeconds: timeSetting.session.restSeconds)
                }
            }
        }
        
        func toggleLastLongRefresh(isOn: Bool) {
            timeSetting.sessions = timeSetting.sessions.enumerated().map { (index, session) in
                let isLastIndex: Bool = index == timeSetting.sessions.endIndex - 1
                if isLastIndex {
                    return Session(concentrationSeconds: timeSetting.session.concentrationSeconds,
                                   restSeconds: isOn ? TimeSetting.longRefreshSeconds : 0)
                }
                return session
            }
        }
        
        func addNewSession() {
            guard mode == .individual else { return }
            guard timeSetting.numOfSessions < TimerSettingContraint.looseSessionsBound.upperBound else { return }
            timeSetting.sessions.append(Session.getBasicSession())
        }
        
        func removeSession(at index: Int) {
            guard index < timeSetting.sessions.count else { return }
            timeSetting.sessions.remove(at: index)
        }
        
        func resetToBasicSessions() {
            timeSetting.sessions = Session.getBasicSessions()
        }

}

extension TimerSettingManager {
    enum TimeSetMode: String, CaseIterable, Identifiable {
        case batch
        case individual
//        case preset
        
        var localizedStringKey: LocalizedStringKey {
            switch self {
            case .individual: return "timeSetMode_individual"
            case .batch: return "timeSetMode_batch"
//            case .preset: return "timeSetMode_preset"
            }
        }
        
        var id: Self { self }
    }
}
