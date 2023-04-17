//
//  SessionIndicator.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/30.
//

import SwiftUI

struct SessionIndicator: View {
    @ObservedObject var viewModel: TimerManager
    
    var numOfSession: Int { 2 * viewModel.numOfSessions }
    var currentSession: Int { viewModel.currentSession }
    
    var body: some View {

        HStack(spacing: 5) {
            Spacer()
                ForEach(0..<numOfSession, id: \.self) { session in
                    if session + 1 == currentSession {
                        Capsule().frame(width: 30, height: 10)
                    } else {
                        Circle().frame(width: 10 , height: 10)
                            .foregroundColor(.secondary)
                    }

                }
           
            Spacer()
            }
        
    }
}

struct SessionIndicator_Previews: PreviewProvider {
    static var previews: some View {
        SessionIndicator(viewModel: TimerManager())
    }
}
