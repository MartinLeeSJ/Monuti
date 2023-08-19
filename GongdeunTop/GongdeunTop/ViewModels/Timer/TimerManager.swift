//
//  TimerManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/19.
//

import Foundation
import SwiftUI
import Combine


@MainActor
final class TimerManager: ObservableObject {
    @Published var timeSetting = TimeSetting()
    @Published var currentTimeIndex: Int = 0
    @Published var remainSeconds: TimeInterval = 0
    @Published var isRunning: Bool = false
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
  
    var currentSession: Session {
        let sessionIndex = Int(currentTimeIndex / 2)
        guard sessionIndex < timeSetting.sessions.count else { return timeSetting.sessions.first ?? Session.getBasicSession()}
        return timeSetting.sessions[sessionIndex]
    }
    
    
    init(timeSetting: TimeSetting) {
        self.timeSetting = timeSetting
        
        $currentTimeIndex
            .combineLatest($timeSetting)
            .map { (current, timeSetting) in
                let sessionIndex = Int(current / 2)
                let isConcentrateTime: Bool = current % 2 == 0
                let currentSession: Session = timeSetting.sessions[safe: sessionIndex] ?? Session.getBasicSession()
                return isConcentrateTime ?
                TimeInterval(currentSession.concentrationSeconds) :
                TimeInterval(currentSession.restSeconds)
            }
            .assign(to: &$remainSeconds)
    
    }
    
    
    // MARK: - Reset Methods
    func resetToOrigin() {
        pauseTime()
        currentTimeIndex = 0
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
    
    func startTime() {
        isRunning = true
    }
    
    func pauseTime() {
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
    
    func knowIsStartingPointOfThisTime() -> Bool {
        let sessionIndex = Int(currentTimeIndex / 2)
        let isConcentrateTime: Bool = currentTimeIndex % 2 == 0
        let currentSession: Session = timeSetting.sessions[safe: sessionIndex] ?? Session.getBasicSession()
        return isConcentrateTime ?
        remainSeconds == TimeInterval(currentSession.concentrationSeconds) :
        remainSeconds == TimeInterval(currentSession.restSeconds)
    }
    
// MARK: - Get End Degree
    func getEndDegree() -> Double {
        let currentSeconds = knowIsInRestTime() ? currentSession.restSeconds : currentSession.concentrationSeconds
        
        return remainSeconds / Double(currentSeconds)  * 360.0
    }
    
    
    /// 백그라운드 모드에서 다시 돌아올 경우 남아있는 시간에서 백그라운드 모드에서 지낸 시간을 빼주고 그 차를 리턴해주는 메소드
    /// - Parameter last: 마지막으로 관찰된 시간
    /// - Returns: 시간 차
    func subtractTimeElapsed(from last: TimeInterval) -> TimeInterval {
        let diff: TimeInterval = Date.now.timeIntervalSince(Date(timeIntervalSince1970: last))
        let oldRemainSeconds: TimeInterval = remainSeconds
        let newRemainSeconds: TimeInterval = floor(oldRemainSeconds - diff)
        
        if newRemainSeconds > 0 {
            remainSeconds = newRemainSeconds
            print("\(diff) 만큼의 시간이 지났습니다")
            return diff
        }
        
        print("\(oldRemainSeconds) 만큼의 시간이 지났습니다")
        moveToNextTimes()
        return oldRemainSeconds
    }

}
