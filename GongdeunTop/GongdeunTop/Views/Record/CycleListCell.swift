//
//  CycleListCell.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/27.
//

import SwiftUI

struct CycleListCell: View {
    @ObservedObject var cycleManager = CycleManager()
    
    var cycle: Cycle {
        cycleManager.cycle
    }
    
    var body: some View {
        VStack {
            let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: cycle.createdAt.dateValue())
            
            DisclosureGroup {
                ForEach(cycleManager.todos, id: \.self) { todo in
                    Text(todo.title)
                }
            } label: {
                Text("\(dateComponent.hour ?? 0)시 \(dateComponent.minute ?? 0)분")
            }
        }
        .task {
            cycleManager.fetchToDos()
        }
    }
}


