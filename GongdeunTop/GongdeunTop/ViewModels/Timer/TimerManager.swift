//
//  TimerManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/19.
//

import Foundation
import SwiftUI

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
        var refreshTime: Int
        
        var concentrationSeconds: Int {
            concentrationTime * 60
        }
        
        var refreshSeconds: Int {
            refreshTime * 60
        }
        
        static let longRefreshSeconds = 30 * 60
    }
    
    init(timeSetting: TimeSetting = .init(numOfSessions: 4, concentrationTime: 25, refreshTime: 5) , currentTime: Int = 1) {
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
        
        if knowIsRefreshTime() {
            resetRefreshTime()
            return
        }
        
        resetConcentrationTime()
    }
    
    private func resetRefreshTime() {
        guard knowIsRefreshTime() else { return }
        
        
        if knowIsLastTime() {
            remainSeconds = TimeSetting.longRefreshSeconds
            return
        }
        
        remainSeconds = timeSetting.refreshSeconds
    }
    
    private func resetConcentrationTime() {
        guard !knowIsRefreshTime() else { return }
        
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
        if knowIsRefreshTime()  {
            setRefreshSeconds()
            return
        }
        
        setConcentrationSeconds()
    }
    
    private func setConcentrationSeconds() {
        guard !knowIsRefreshTime() else { return }
        
        remainSeconds = timeSetting.concentrationSeconds
    }
    
    private func setRefreshSeconds() {
        guard knowIsRefreshTime() else { return }
        
        if knowIsLastTime() {
            remainSeconds = TimeSetting.longRefreshSeconds
            return
        }
        
        remainSeconds = timeSetting.refreshSeconds
    }
    
    
    
// MARK: - Get CurrentTime Info
    func knowIsRefreshTime() -> Bool {
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
    func getMinute() -> String {
        let seconds: Int = self.remainSeconds <= 0 ? 0 : self.remainSeconds
        let result: Int = Int(seconds / 60)
        
        if result < 10 {
            return "0" + String(result)
        }
        return String(result)
        
    }
    
    func getSecond() -> String {
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
        let longRefreshMinute = 30
        
        for _ in 1..<timeSetting.numOfSessions {
            result += (timeSetting.concentrationTime + timeSetting.refreshTime)
        }
        
        result += (timeSetting.concentrationTime + longRefreshMinute)
        
        return result
    }
    
// MARK: - Get End Degree
    func getEndDegree() -> Double {
        if knowIsRefreshTime()  {
            return getRefreshTimeEndDegree()
        }
        
        return getConcentrationTimeEndDegree()
        
    }
    
    private func getRefreshTimeEndDegree() -> Double {
        if knowIsLastTime() {
            return Double(self.remainSeconds) / Double(TimeSetting.longRefreshSeconds) * 360.0
        }
        
        return Double(self.remainSeconds) / Double(timeSetting.refreshSeconds)  * 360.0
    }
    
    private func getConcentrationTimeEndDegree() -> Double {
        
        return Double(self.remainSeconds) / Double(timeSetting.concentrationSeconds)  * 360.0
    }
    
 
    
    func subtractTimeElapsed(from last: Double) {
        let now: Double = Double(Date.now.timeIntervalSince1970)
        let diff: Int = Int((now - last).rounded())
        
        if knowIsRefreshTime() {
            subtractRefreshElapsed(time: diff)
            return
        }
        
        subtractConcentrationElapsed(time: diff)
     
    }
    
    private func subtractRefreshElapsed(time: Int) {
        guard knowIsRefreshTime() else { return }

        
        if knowIsLastTime() {
            remainSeconds = TimeSetting.longRefreshSeconds - time
            return
        }
        
        remainSeconds = timeSetting.refreshSeconds - time
    }
    
    private func subtractConcentrationElapsed(time: Int) {
        guard !knowIsRefreshTime() else { return }
        
        remainSeconds = timeSetting.concentrationSeconds - time
    }
   
}

