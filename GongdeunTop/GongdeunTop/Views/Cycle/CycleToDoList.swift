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
    
    private func convertSecToMin(_ input: Int) -> (minute: Int, second: Int) {
        return (minute: Int(input / 60), second: Int(input % 60))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(Array(manager.todos.enumerated()), id: \.offset) { (index, todo) in
                    let (minute, second) = convertSecToMin(todo.timeSpent)
                    HStack {
                        if mode == .memoir {
                            Button {
                                manager.todos[index].isCompleted.toggle()
                            } label: {
                                Image(systemName: todo.isCompleted ? "largecircle.fill.circle" : "circle")
                            }
                            .padding(.trailing, 10)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(todo.title)
                                .font(.headline)
                            Text(todo.content)
                                .font(.caption)
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(todo.tags, id: \.self) { tag in
                                        Text(tag)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(3)
                                            .padding(.horizontal, 5)
                                            .background {
                                                Capsule().fill(themeManager.colorInPriority(in: .accent))
                                            }
                                    }
                                }
                            }
                        }
                        
                        Text("\(minute) minute") + Text(" ") + Text("\(second) second")
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
