//
//  TimerManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/19.
//

import Foundation
import SwiftUI

struct TimerBasicPreset {
    static let sessionsBound: ClosedRange<Int> = 1...5
    static let sessionStep: Int.Stride = 1
    
    static let concentrationTimeBound: ClosedRange<Int> = 15...50
    static let concentrationTimeStep: Int.Stride = 5
    
    static let restTimeBound: ClosedRange<Int> = 5...10
    static let restTimeStep: Int.Stride = 1
}

@MainActor
final class TimerManager: ObservableObject {
    @Published var timeSetting: TimeSetting
    @Published var currentTime: Int {
        didSet {
            setTimerRemainSeconds()
        }
    }
    
    @Published var remainSeconds: Int
    @Published var isRunning: Bool = false
    @Published var timer: Timer?
    
    struct TimeSetting {
        var numOfSessions: Int
        var concentrationTime: Int
        var restTime: Int
        var willGetLongRefresh: Bool
        
        var concentrationSeconds: Int {
            concentrationTime * 60
        }
        
        var restSeconds: Int {
            restTime * 60
        }
        
        var longRefreshMinute: Int {
            willGetLongRefresh ? 30 : 0
        }
        
        var longRefreshSeconds: Int {
            longRefreshMinute * 60
        }
    }
    
    init(timeSetting: TimeSetting = .init(numOfSessions: 4, concentrationTime: 25, restTime: 5, willGetLongRefresh: true) , currentTime: Int = 1) {
        self.timeSetting = timeSetting
        self.currentTime = currentTime
        self.remainSeconds = timeSetting.concentrationTime * 60
    }
    
    
    // MARK: - Reset Methods
    func resetToOrigin() {
        pauseTime()
        currentTime = 1
        timer = nil
    }
    
    func resetTimes() {
        pauseTime()
        
        if knowIsInRestTime() {
            resetRefreshTime()
        } else {
            resetConcentrationTime()
        }
    }
    
    private func resetRefreshTime() {
        guard knowIsInRestTime() else { return }
        
        if knowIsLastTime() {
            remainSeconds = timeSetting.longRefreshSeconds
        } else {
            remainSeconds = timeSetting.restSeconds
        }
    }
    
    private func resetConcentrationTime() {
        guard !knowIsInRestTime() else { return }
        remainSeconds = timeSetting.concentrationSeconds
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
    
// MARK: - Set Remain Seconds
    func setTimerRemainSeconds() {
        if knowIsInRestTime()  {
            setRefreshSeconds()
            return
        }
        
        setConcentrationSeconds()
    }
    
    private func setConcentrationSeconds() {
        guard !knowIsInRestTime() else { return }
        
        remainSeconds = timeSetting.concentrationSeconds
    }
    
    private func setRefreshSeconds() {
        guard knowIsInRestTime() else { return }
        
        if knowIsLastTime() {
            remainSeconds = timeSetting.longRefreshSeconds
            return
        }
        
        remainSeconds = timeSetting.restSeconds
    }
    
    
    
// MARK: - Get CurrentTime Info
    func knowIsInRestTime() -> Bool {
        self.currentTime % 2 == 0
    }
    
    func knowIsInSession() -> Bool {
        let numOfTimes = timeSetting.numOfSessions * 2
        return self.currentTime < numOfTimes
    }
    
    func knowIsLastTime() -> Bool {
        let numOfTimes = timeSetting.numOfSessions * 2
        return self.currentTime == numOfTimes
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
        var result: Int = 0
        
        for session in 1...timeSetting.numOfSessions {
            let restTime = session == timeSetting.numOfSessions ? timeSetting.longRefreshMinute : timeSetting.restTime
            result += (timeSetting.concentrationTime + restTime)
        }
        
        return result
    }
    
// MARK: - Get End Degree
    func getEndDegree() -> Double {
        if knowIsInRestTime()  {
            return getRestTimeEndDegree()
        }
        
        return getConcentrationTimeEndDegree()
        
    }
    
    private func getRestTimeEndDegree() -> Double {
        if knowIsLastTime() {
            guard timeSetting.longRefreshSeconds != 0 else { return 360.0}
            return Double(self.remainSeconds) / Double(timeSetting.longRefreshSeconds) * 360.0
        }
        
        return Double(self.remainSeconds) / Double(timeSetting.restSeconds)  * 360.0
    }
    
    private func getConcentrationTimeEndDegree() -> Double {
        return Double(self.remainSeconds) / Double(timeSetting.concentrationSeconds)  * 360.0
    }
    
 
    
    func subtractTimeElapsed(from last: Double) {
        let now: Double = Double(Date.now.timeIntervalSince1970)
        let diff: Int = Int((now - last).rounded())
        
        if knowIsInRestTime() {
            subtractRefreshElapsed(time: diff)
            return
        }
        
        subtractConcentrationElapsed(time: diff)
     
    }
    
    private func subtractRefreshElapsed(time: Int) {
        guard knowIsInRestTime() else { return }

        
        if knowIsLastTime() {
            remainSeconds = timeSetting.longRefreshSeconds - time
            return
        }
        
        remainSeconds = timeSetting.restSeconds - time
    }
    
    private func subtractConcentrationElapsed(time: Int) {
        guard !knowIsInRestTime() else { return }
        
        remainSeconds = timeSetting.concentrationSeconds - time
    }
   
}

