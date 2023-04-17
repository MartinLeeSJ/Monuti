//
//  CycleMemoir.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/17.
//

import SwiftUI

struct CycleMemoir: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var manager = CycleManager()
    
    var todos: [ToDo] { manager.todos }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    manager.cycle.evaluation = 1
                } label: {
                    Text("Bad")
                        .font(.title)
                        .foregroundColor(manager.cycle.evaluation == 1 ? .red : .secondary)
                }
                
                Button {
                    manager.cycle.evaluation = 2
                } label: {
                    Text("SoSo")
                        .font(.title)
                        .foregroundColor(manager.cycle.evaluation == 2 ? .green : .secondary)
                }
                
                Button {
                    manager.cycle.evaluation = 3
                } label: {
                    Text("Good")
                        .font(.title)
                        .foregroundColor(manager.cycle.evaluation == 3 ? .blue : .secondary)
                }
            }
            
            ForEach(todos, id: \.self) { todo in
                HStack {
                    Button {
                        if var checkedTodo = todos.first(where: { $0.id == todo.id }) {
                            checkedTodo.isCompleted.toggle()
                        }
                    } label: {
                        Image(systemName: todo.isCompleted ? "largecircle.fill.circle" : "circle")
                    }
                    
                    VStack(alignment: .leading) {
                        Text(todo.title)
                            .font(.headline)
                        Text(todo.content)
                            .font(.caption)
                        ScrollView(.horizontal) {
                            ForEach(todo.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .padding(.horizontal, 5)
                                    .background {
                                        Capsule().fill(Color.GTDenimNavy)
                                    }
                            }
                        }
                    }
                    
                    Text("\(todo.timeSpent)분")
                }
                .overlay(alignment: .bottom) {
                    Divider()
                }
            }
            
            TextEditor(text: $manager.cycle.memoirs)
        }
        .toolbar {
            ToolbarItem {
                Button {
                    manager.handleAddButton()
                    dismiss()
                } label: {
                    Text("저장")
                }
                .disabled(!manager.modified)
            }
        }
        .interactiveDismissDisabled()
    }
}

struct CycleMemoir_Previews: PreviewProvider {
    static var previews: some View {
        CycleMemoir()
    }
}
