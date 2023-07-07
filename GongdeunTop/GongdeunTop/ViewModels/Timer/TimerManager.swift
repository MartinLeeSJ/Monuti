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
    var numOfSessions: Int {
        sessions.count
    }
    var willGetLongRefresh: Bool = true
    var isCustomized: Bool = false
}

struct Session: Identifiable {
    var id: String = UUID().uuidString
    var concentrationTime: Int
    var restTime: Int
    
    var concentrationSeconds: Int {
        concentrationTime * 60
    }
    
    var restSeconds: Int {
        restTime * 60
    }
    
    var sessionTime: Int {
        concentrationTime + restTime
    }
}

extension Session {
    static let basicSetting = Session(concentrationTime: 25, restTime: 5)
    static let lastSessionPlaceholder = Session(concentrationTime: 25, restTime: 30)
    static let basicSessions = Array(repeating: Self.basicSetting, count: 3) + [Self.lastSessionPlaceholder]
}

@MainActor
final class TimerManager: ObservableObject {
    @Published var timeSetting = TimeSetting()
    @Published var currentTime: Int = 0
    @Published var remainSeconds: Int = 0
    @Published var isRunning: Bool = false
    @Published var timer: Timer?
    
    
    
    init() {
        $currentTime
            .combineLatest($timeSetting)
            .map { (current, timeSetting) in
                let sessionIndex = Int(current / 2)
                let timeIndex = current % 2
                let currentSession: Session = timeSetting.sessions[sessionIndex]
                return timeIndex == 0 ? currentSession.concentrationSeconds : currentSession.restSeconds
            }
            .assign(to: &$remainSeconds)
    }
    
    
    // MARK: - Reset Methods
    func resetToOrigin() {
        pauseTime()
        currentTime = 0
        timer = nil
    }
    
    func resetTimes() {
        pauseTime()
        currentTime = currentTime
    }
    
    
// MARK: - Move and Stop Time
    func moveToNextTimes() {
        withAnimation {
            pauseTime()
            if knowIsInSession() {
                currentTime += 1
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
        self.currentTime % 2 == 1
    }
    
    func knowIsInSession() -> Bool {
        let numOfTimes = timeSetting.numOfSessions * 2
        return self.currentTime < numOfTimes
    }
    
    func knowIsLastTime() -> Bool {
        let numOfTimes = timeSetting.numOfSessions * 2
        return self.currentTime == numOfTimes - 1
    }
    
    
// MARK: - Get CurrentTime Digit Strings
    func getMinuteString() -> String {
        let seconds: Int = self.remainSeconds <= 0 ? 0 : self.remainSeconds
        let result: Int = Int(seconds / 60)
        
        if result < 10 {
            return "0" + String(result)
        }
        return String(result)
    }
    
    func getSecondString() -> String {
        let seconds: Int = self.remainSeconds <= 0 ? 0 : self.remainSeconds
        let result: Int = seconds % 60
        
        if result < 10 {
            return "0" + String(result)
        } else {
            return String(result)
        }
    }
    
    func getTotalMinute() -> Int {
        timeSetting.sessions.reduce(0) {$0 + $1.sessionTime}
    }
    
// MARK: - Get End Degree
    func getEndDegree() -> Double {
        let sessionIndex = Int(currentTime / 2)
        guard sessionIndex < timeSetting.numOfSessions else { return 360.0 }
        let currentSession = timeSetting.sessions[sessionIndex]
        let currentSeconds = knowIsInRestTime() ? currentSession.restSeconds : currentSession.concentrationSeconds
        
        return Double(self.remainSeconds) / Double(currentSeconds)  * 360.0
    }

    func subtractTimeElapsed(from last: Double) {
        let now: Double = Double(Date.now.timeIntervalSince1970)
        let diff: Int = Int((now - last).rounded())
        
        let sessionIndex = Int(currentTime / 2)
        let currentSession = timeSetting.sessions[sessionIndex]
        
        remainSeconds = knowIsInRestTime() ? currentSession.restTime - diff : currentSession.concentrationSeconds - diff
     
    }
}

