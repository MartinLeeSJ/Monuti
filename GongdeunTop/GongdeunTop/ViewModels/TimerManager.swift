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
    @Published var numOfSessions: Int
    @Published var concentrationTime: Int 
    @Published var refreshTime: Int
    
    @Published var currentTime: Int {
        willSet(newValue) {
            setRemainSeconds(currentTime: newValue)
        }
    }
    
    @Published var remainSeconds: Int
    
    @Published var isRunning: Bool = false
    @Published var timer: Timer?
    
    @Published var currentTodo: ToDo? = nil
    
    
    init(sessions: Int = 4, concentrationTime: Int = 25, refreshTime: Int = 5, currentTime: Int = 1) {
        self.numOfSessions = sessions
        self.concentrationTime = concentrationTime
        self.refreshTime = refreshTime
        self.currentTime = currentTime
        self.remainSeconds = concentrationTime * 60
    }
    
    func reset() {
        currentTime = 1
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    
    func setRemainSeconds(currentTime: Int = 1) {
        if currentTime % 2 == 0 && currentTime < numOfSessions * 2 {
            remainSeconds = refreshTime * 60
        } else if currentTime == numOfSessions * 2 {
            remainSeconds = 30 * 60
        } else {
            remainSeconds = concentrationTime * 60
        }
    }
    
    func knowIsRefreshTime() -> Bool {
        self.currentTime % 2 == 0
    }
    
    func knowIsInSession() -> Bool {
        self.currentTime < self.numOfSessions * 2
    }
    
    func getMinute() -> String {
        let seconds: Int = self.remainSeconds <= 0 ? 0 : self.remainSeconds
        let result: Int = Int(seconds / 60)
        
        if result < 10 {
            return "0" + String(result)
        } else {
            return String(result)
        }
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
    
    func getTotalTime() -> Int {
        (concentrationTime + refreshTime) * numOfSessions
    }
    
    func getEndDegree() -> Double {
        if currentTime % 2 == 0 && currentTime < numOfSessions * 2 {
            return Double(self.remainSeconds) / Double(self.refreshTime * 60)  * 360.0
        } else if currentTime == numOfSessions * 2 {
            return Double(self.remainSeconds) / Double(30 * 60)  * 360.0
        } else {
            return Double(self.remainSeconds) / Double(self.concentrationTime * 60)  * 360.0
        }
        
    }
    
 
   
}

