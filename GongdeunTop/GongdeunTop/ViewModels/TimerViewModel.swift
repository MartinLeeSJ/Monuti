//
//  TimerViewModel.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/19.
//

import Foundation
import SwiftUI

@MainActor
final class TimerViewModel: ObservableObject {
    @Published var numOfSessions: Int
    @Published var concentrationTime: Int
    @Published var refreshTime: Int
    
    @Published var currentSession: Int {
        willSet(newValue) {
            if newValue % 2 == 0 && newValue < numOfSessions * 2 {
                remainSeconds = refreshTime * 60
            } else if newValue == numOfSessions * 2 {
                remainSeconds = 30 * 60
            } else {
                remainSeconds = concentrationTime * 60
            }
        }
    }
    
    @Published var remainSeconds: Int
    
    @Published var isRunning: Bool = false
    @Published var timer: Timer?
    
    
    init(sessions: Int = 4, concentrationTime: Int = 25, refreshTime: Int = 5, currentSession: Int = 1) {
        self.numOfSessions = sessions
        self.concentrationTime = concentrationTime
        self.refreshTime = refreshTime
        self.currentSession = currentSession
        self.remainSeconds = concentrationTime * 60
    }
    
    
    func knowIsRefreshTime() -> Bool {
        self.currentSession % 2 == 0
    }
    
    func knowIsInSession() -> Bool {
        self.currentSession < self.numOfSessions * 2
    }
    
    func getMinute() -> String {
        let result: Int = Int(self.remainSeconds / 60)
        
        if result < 10 {
            return "0" + String(result)
        } else {
            return String(result)
        }
    }
    
    func getSecond() -> String {
        let result: Int = self.remainSeconds % 60
        
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
        if currentSession % 2 == 0 && currentSession < numOfSessions * 2 {
            return Double(self.remainSeconds) / Double(self.refreshTime * 60)  * 360.0
        } else if currentSession == numOfSessions * 2 {
            return Double(self.remainSeconds) / Double(30 * 60)  * 360.0
        } else {
            return Double(self.remainSeconds) / Double(self.concentrationTime * 60)  * 360.0
        }
        
    }
    
 
   
}

