//
//  TimerManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/19.
//

import Foundation
import SwiftUI
import Combine

struct TimeSetting {
    var session: Session = Session.basicSetting
    var sessions: [Session] = Session.basicSessions
    var willGetLongRefresh: Bool = true
    var numOfSessions: Int {
        get { sessions.count }
        set(newValue) {
            guard abs(newValue - numOfSessions) == 1 else {
                return
            }
            if newValue < numOfSessions {
                sessions.removeFirst()
            } else {
                sessions.insert(self.session, at: sessions.startIndex)
            }
        }
    }
    
    
    static let longRefreshSeconds: Int = 30 * 60
}



struct Session: Identifiable {
    var id: String = UUID().uuidString
    var concentrationSeconds: Int
    var restSeconds: Int
    
    var sessionSeconds: Int {
        concentrationSeconds + restSeconds
    }
}

extension Session {
    static let basicSetting = Session(concentrationSeconds: 25 * 60, restSeconds: 5 * 60)
    static let lastSessionPlaceholder = Session(concentrationSeconds: 25 * 60, restSeconds: 30 * 60)
    static var basicSessions = Array(repeating: Self.basicSetting, count: 3) + [Self.lastSessionPlaceholder]
}

@MainActor
final class TimerManager: ObservableObject {
    @Published var timeSetting = TimeSetting()
    @Published var currentTimeIndex: Int = 0
    @Published var remainSeconds: Int = 0
    @Published var isRunning: Bool = false
    @Published var timer: Timer?
    @Published var mode: TimeSetMode = .batch
    
  
    var currentSession: Session {
        let sessionIndex = Int(currentTimeIndex / 2)
        guard sessionIndex < timeSetting.sessions.count else { return timeSetting.sessions.first ?? Session.basicSetting}
        return timeSetting.sessions[sessionIndex]
    }
    
    
    init() {
        $currentTimeIndex
            .combineLatest($timeSetting)
            .map { (current, timeSetting) in
                let sessionIndex = Int(current / 2)
                let isConcentrateTime: Bool = current % 2 == 0
                let currentSession: Session = timeSetting.sessions[safe: sessionIndex] ?? Session.basicSetting
                return isConcentrateTime ? currentSession.concentrationSeconds : currentSession.restSeconds
            }
            .assign(to: &$remainSeconds)
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
        let numOfTimes = timeSetting.numOfSessions * 2
        return (0..<numOfTimes).contains(self.currentTimeIndex)
    }
    
    func knowIsLastTime() -> Bool {
        let numOfTimes = timeSetting.numOfSessions * 2
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
        let result: Int = (seconds <= 0 ? 0 : seconds) % 60
        
        if result < 10 && isTwoLetters {
            return "0" + String(result)
        } else {
            return String(result)
        }
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

}

//MARK: - TimeSetMode
extension TimerManager {
    enum TimeSetMode: LocalizedStringKey, CaseIterable, Identifiable {
        case batch = "timeSetMode_batch"
        case individual  = "timeSetMode_individual"
        case preset = "timeSetMode_preset"
        
        var id: Self { self }
    }
}

