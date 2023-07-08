//
//  SessionIndicator.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/30.
//

import SwiftUI

struct SessionIndicator: View {
    @ObservedObject var manager: TimerManager
    
    // 4
    var sessions: Int { manager.timeSetting.numOfSessions }
    
    // 0, 1, 2, 3, 4, 5, 6, 7
    var currentTime: Int { manager.currentTimeIndex }
    
    var currentSessionNumber: Int {
        Int(manager.currentTimeIndex / 2) + 1
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Session \(currentSessionNumber)")
                .foregroundColor(.secondary)
            
            Text(String(localized: manager.knowIsInRestTime() ? "Rest" : "Concentrate"))
                .font(.headline)
                .padding(.bottom, 8)
            
            HStack(spacing: 5) {
                Spacer()
                ForEach(1...sessions, id: \.self) { index in
                    let concentrationTime: Int = index * 2 - 2
                    let restTime: Int = concentrationTime + 1
                    HStack(spacing: 4) {
                        ForEach(concentrationTime...restTime, id: \.self) { time in
                            if time == currentTime {
                                Capsule().frame(width: 16, height: 8)
                            } else {
                                Circle().frame(width: 8 , height: 8)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding((concentrationTime...restTime).contains(currentTime) ? 7 : 2)
                    .background {
                        if (concentrationTime...restTime).contains(currentTime) {
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
