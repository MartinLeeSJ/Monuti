//
//  TimerManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/19.
//

import Foundation
import SwiftUI
import Combine





extension Session {
    static func getBasicSession() -> Self {
        Session(concentrationSeconds: SetTimeContraint.basicConcentrationSecond,
                restSeconds: SetTimeContraint.basicRestSecond)
    }
    static func getBasicLongRestSession() -> Self {
        Session(concentrationSeconds: SetTimeContraint.basicConcentrationSecond,
                restSeconds: SetTimeContraint.basicLongRestSecond)
    }
    static func getBasicSessions() -> [Self] {
        var result = Array<Self>()
        
        (0..<SetTimeContraint.basicSessions).forEach { index in
            result.append(index == SetTimeContraint.basicSessions - 1  ? getBasicLongRestSession() : getBasicSession())
        }

        return result
    }
    
    static func getRandomLooseSessions() -> [Self] {
        var result = Array<Self>()
        SetTimeContraint.looseSessionsBound.forEach { _ in
            result.append(
                Session(
                    concentrationSeconds: Int.random(in: SetTimeContraint.looseConcentrationSecondBound),
                    restSeconds: Int.random(in: SetTimeContraint.looseRestSecondBound)
                )
            )
        }
        return result
    }
}

@MainActor
final class TimerManager: ObservableObject {
    @Published var timeSetting = TimeSetting()
    @Published var currentTimeIndex: Int = 0
    @Published var remainSeconds: Int = 0
    @Published var isRunning: Bool = false
    @Published var isDefaultSessionsSetting: Bool = true
    @Published var timer: Timer?
    @Published var mode: TimeSetMode = .batch
    
  
    var currentSession: Session {
        let sessionIndex = Int(currentTimeIndex / 2)
        guard sessionIndex < timeSetting.sessions.count else { return timeSetting.sessions.first ?? Session.getBasicSession()}
        return timeSetting.sessions[sessionIndex]
    }
    
    
    init() {
        $currentTimeIndex
            .combineLatest($timeSetting)
            .map { (current, timeSetting) in
                let sessionIndex = Int(current / 2)
                let isConcentrateTime: Bool = current % 2 == 0
                let currentSession: Session = timeSetting.sessions[safe: sessionIndex] ?? Session.getBasicSession()
                return isConcentrateTime ? currentSession.concentrationSeconds : currentSession.restSeconds
            }
            .assign(to: &$remainSeconds)
        
        $timeSetting
            .map { timeSetting in
                self.knowIsBasicSetting(timeSetting.sessions)
            }
            .assign(to: &$isDefaultSessionsSetting)
    }
    
    
    // MARK: - Reset Methods
    func resetToOrigin() {
        pauseTime()
        currentTimeIndex = 0
        timer = nil
    }
    
    func resetTimes() {
        pauseTime()
        currentTimeIndex = currentTimeIndex
    }
    
    
// MARK: - Move and Stop Time
    func moveToNextTimes() {
        withAnimation {
            pauseTime()
            if knowIsInSession() && !knowIsLastTime() {
                currentTimeIndex += 1
            }
        }
    }
    
    func pauseTime() {
        timer?.invalidate()
        isRunning = false
    }
    
    func elapsesTime() {
        remainSeconds -= 1
    }
    
    
    
// MARK: - Get CurrentTime Info
    func knowIsInRestTime() -> Bool {
        self.currentTimeIndex % 2 == 1
    }
    
    func knowIsInSession() -> Bool {
        let numOfTimes = timeSetting.sessions.count * 2
        return (0..<numOfTimes).contains(self.currentTimeIndex)
    }
    
    func knowIsLastTime() -> Bool {
        let numOfTimes = timeSetting.sessions.count * 2
        return self.currentTimeIndex == numOfTimes - 1
    }
    
    
// MARK: - Get CurrentTime Digit Strings
    func getMinuteString(of seconds: Int, isTwoLetters: Bool = true) -> String {
        let result: Int = getMinute(of: seconds)
        
        if result < 10 && isTwoLetters {
            return "0" + String(result)
        }
        return String(result)
    }
    
    func getMinute(of seconds: Int) -> Int {
        Int((seconds <= 0 ? 0 : seconds) / 60)
    }
    
    func getSecondString(of seconds: Int, isTwoLetters: Bool = true) -> String {
        let result: Int = getSeconds(of: seconds)
        
        if result < 10 && isTwoLetters {
            return "0" + String(result)
        } else {
            return String(result)
        }
    }
    
    func getSeconds(of seconds: Int) -> Int {
        (seconds <= 0 ? 0 : seconds) % 60
    }
    
    func getTotalSeconds() -> Int {
        timeSetting.sessions.reduce(0) {$0 + $1.sessionSeconds}
    }
    
// MARK: - Get End Degree
    func getEndDegree() -> Double {
        let currentSeconds = knowIsInRestTime() ? currentSession.restSeconds : currentSession.concentrationSeconds
        
        return Double(self.remainSeconds) / Double(currentSeconds)  * 360.0
    }

    func subtractTimeElapsed(from last: Double) {
        let now: Double = Double(Date.now.timeIntervalSince1970)
        let diff: Int = Int((now - last).rounded())
        
        remainSeconds = knowIsInRestTime() ? currentSession.restSeconds - diff : currentSession.concentrationSeconds - diff
     
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
        guard timeSetting.numOfSessions < SetTimeContraint.looseSessionsBound.upperBound else { return }
        timeSetting.sessions.append(Session.getBasicSession())
    }
    
    func removeSession(at index: Int) {
        guard index < timeSetting.sessions.count else { return }
        timeSetting.sessions.remove(at: index)
    }
    
    func resetToBasicSessions() {
        timeSetting.sessions = Session.getBasicSessions()
    }
    
    // MARK: - Set Time Info
    func knowIsBasicSetting(_ sessions: [Session]) -> Bool {
        guard sessions.count == SetTimeContraint.basicSessions else { return false }
        let basicSessions = Session.getBasicSessions()
        return sessions.enumerated().reduce(true) { _, element in
            let (index,session) = element
            let basicSession = basicSessions[index]
            return (basicSession.concentrationSeconds == session.concentrationSeconds) &&
            (basicSession.restSeconds == session.restSeconds)
        }
    }

}

//MARK: - TimeSetMode
extension TimerManager {
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

