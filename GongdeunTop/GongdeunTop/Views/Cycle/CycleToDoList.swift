//
//  CycleToDoList.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/08.
//

import SwiftUI

struct CycleToDoList: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject private var manager: CycleManager
    
    private var mode: CycleToDoList.Mode = .memoir
    
    enum Mode {
        case memoir
        case cycleListCellDetail
    }
    
    init(manager: CycleManager, mode: CycleToDoList.Mode = .memoir) {
        self.manager = manager
        self.mode = mode
    }
    
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(Array(manager.todos.enumerated()), id: \.offset) { (index, todo) in
                    HStack {
                        if mode == .memoir {
                            Button {
                                manager.toggleToDoCompletion(of: index)
                            } label: {
                                Image(systemName: todo.isCompleted ? "largecircle.fill.circle" : "circle")
                            }
                            .padding(.trailing, 10)
                            .tint(themeManager.colorInPriority(in: .accent))
                        }
                        
                        ToDoInfoCell(todo: todo)
                        
                        Text(TimeInterval(todo.timeSpent).todoSpentTimeString)
                    }
                    .overlay(alignment: .bottom) {
                        Divider()
                            .offset(y: 10)
                    }
                    .padding(.bottom, 10)
                }
            }
        }
        
    }
}

struct CycleToDoList_Previews: PreviewProvider {
    static var previews: some View {
        CycleToDoList(manager: CycleManager())
    }
}
