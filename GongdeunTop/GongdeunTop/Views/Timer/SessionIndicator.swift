//
//  SessionIndicator.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/30.
//

import SwiftUI

struct SessionIndicator: View {
    @ObservedObject var manager: TimerManager
    
    var sessions: Int { manager.timeSetting.numOfSessions }
    // 1, 2, 3, 4
    var cycle: Int { 2 * sessions }
    
    // 1, 2, 3, 4, 5, 6, 7, 8
    var currentTime: Int { manager.currentTime }
    
    var currentSession: Int { Int(ceil(Double(currentTime) / 2)) }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Session \(currentSession)")
                .foregroundColor(.secondary)
            
            Text(String(localized: manager.knowIsRefreshTime() ? "Refresh" : "Concentrate"))
                .font(.headline)
                .padding(.bottom, 8)
            
            HStack(spacing: 5) {
                Spacer()
                ForEach(1...sessions, id: \.self) { session in
                    let firstTime: Int = session * 2 - 1
                    let lastTime: Int = firstTime + 1
                    HStack(spacing: 4) {
                        ForEach(firstTime...lastTime, id: \.self) { time in
                            if time == currentTime {
                                Capsule().frame(width: 16, height: 8)
                            } else {
                                Circle().frame(width: 8 , height: 8)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(currentTime <= lastTime && firstTime <= currentTime ? 7 : 2)
                    .background {
                        if currentTime <= lastTime && firstTime <= currentTime {
                            Capsule()
                                .fill(Color.gray)
                                .opacity(0.3)
                        }
                    }
                    
                }
                Spacer()
            }
        }
        
    }
}

struct SessionIndicator_Previews: PreviewProvider {
    static var previews: some View {
        SessionIndicator(manager: TimerManager())
    }
}
