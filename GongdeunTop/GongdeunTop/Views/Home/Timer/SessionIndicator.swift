//
//  SessionIndicator.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/30.
//

import SwiftUI

struct SessionIndicator: View {
    @ObservedObject var manager: TimerManager
    
    var sessions: Int { manager.numOfSessions }
    // 1, 2, 3, 4
    var cycle: Int { 2 * manager.numOfSessions }
    // 1, 2, 3, 4, 5, 6, 7, 8
    var currentTime: Int { manager.currentTime }
    
    var body: some View {
        
        HStack(spacing: 5) {
            Spacer()
            ForEach(1...sessions, id: \.self) { session in
                
                HStack {
                    ForEach((session * 2 - 1)...(session * 2), id: \.self) { time in
                        if time == currentTime {
                            Capsule().frame(width: 30, height: 10)
                        } else {
                            Circle().frame(width: 10 , height: 10)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(5)
                .background {
                    if currentTime <= session * 2 && session * 2 - 1 <= currentTime {
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

struct SessionIndicator_Previews: PreviewProvider {
    static var previews: some View {
        SessionIndicator(manager: TimerManager())
    }
}
