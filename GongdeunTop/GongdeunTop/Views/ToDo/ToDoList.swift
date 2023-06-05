//
//  ToDoList.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI


struct ToDoList: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var todoStore: ToDoStore
    @EnvironmentObject var timerManager: TimerManager
    
    @State private var isDeleteAlertOn: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            List(todoStore.todos, selection: $todoStore.multiSelection) { todo in
                ToDoListCell(todo: todo)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .environment(\.editMode, .constant(todoStore.isEditing ? EditMode.active : EditMode.inactive))
            
            Spacer()
            
            Divider()
            
            if todoStore.isEditing {
                editToDosButtons()
            }
        }
        .toolbar {
            
        }
    }
}


//MARK: - EditToDosButtons
extension ToDoList {
    var multiSelectionCount: Int {
        todoStore.multiSelection.count
    }
    
    @ViewBuilder
    func editToDosButtons() -> some View {
        HStack {
            Button {
                isDeleteAlertOn.toggle()
            } label: {
                Text("Delete")
            }
            .alert("Delete", isPresented: $isDeleteAlertOn) {
                Button {
                    isDeleteAlertOn.toggle()
                } label: {
                    Text("Cancel")
                }
                
                Button {
                    todoStore.deleteTodos()
                    isDeleteAlertOn.toggle()
                } label: {
                    Text("Delete")
                }
            } message: {
                Text("really_delete? \(multiSelectionCount)")
            }
            
            Spacer()
            
            Button {
                todoStore.completeTodos()
            } label: {
                Text("Complete Todo")
            }
            
        }
        .tint(themeManager.getColorInPriority(of: .accent))
        .disabled(todoStore.multiSelection.isEmpty)
        .padding(.horizontal, 24)
        .padding(.vertical, 6)
    }
}



