//
//  CycleListCellDetail.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/08.
//

import SwiftUI

struct CycleListCellDetail: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var cycleManager: CycleManager
    
    var hasAnyTodos: Bool {
        !cycleManager.cycle.todos.isEmpty
    }
    
    var body: some View {
        VStack {
            if let sessions = cycleManager.cycle.sessions,
               let concentrationTime = cycleManager.cycle.concentrationTime,
               let refreshTime = cycleManager.cycle.refreshTime,
               let totalTime = cycleManager.cycle.minutes {
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Text("\(sessions)개 세션")
                        .font(.title2.bold())
                    HStack(spacing: 5) {
                        Text("집중 \(concentrationTime)분")
                        Text("휴식 \(refreshTime)분")
                        Text("총 \(totalTime)분")
                    }
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    
                    Spacer()
                    
                }
                .padding(.top, 10)
                
                Divider()
                    .padding(.top, 5)
            }
           
            
            
            HAlignment(alignment: .leading) {
                Text("집중도")
                    .font(.title2.bold())
                RoundedHexagon(radius: 15, cornerAngle: 5)
                    .fill(themeManager.getColorInPriority(of: cycleManager.cycle.colorPriority))
                    .frame(width: 32, height: 32)
            }
            .padding(.top, 10)
            
            Divider()
                .padding(.top, 5)
            
            HAlignment(alignment: .leading) {
                Text("\(cycleManager.todos.count)개의 한 일")
                    .font(.title2.bold())
            }
            .padding(.top, 10)
            
           
            CycleToDoList(manager: cycleManager, mode: .cycleListCellDetail)
                
           
        }
        .padding()
        .task {
          cycleManager.fetchToDos()
        }
        .redacted(reason: hasAnyTodos && cycleManager.todos.isEmpty ? .placeholder : [])
        
    }
}

struct CycleListCellDetail_Previews: PreviewProvider {
    static var previews: some View {
        CycleListCellDetail(cycleManager: CycleManager())
    }
}
