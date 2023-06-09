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
            topEditingConsole
            
            List(todoStore.todos, selection: $todoStore.multiSelection) { todo in
                ToDoListCell(todo: todo)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 8, leading: 16, bottom: 0, trailing: 16))
            }
            .listStyle(.plain)
            .environment(\.editMode, .constant(todoStore.isEditing ? EditMode.active : EditMode.inactive))
            
            Spacer()
            
            Divider()
            
            if todoStore.isEditing {
                bottomEditingConsole
            }
        }
    }
}

// MARK: - Top Editing Console
extension ToDoList {
    @ViewBuilder
    var topEditingConsole: some View {
        HStack {
            Menu {
                ForEach(ToDoStore.SortMode.allCases) { mode in
                    Button {
                        todoStore.sortTodos(as: mode)
                    } label: {
                        HStack {
                            Text(mode.localizedString)
                            Spacer()
                            if todoStore.sortMode == mode {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                if todoStore.sortMode == .basic {
                    Image(systemName: "arrow.up.arrow.down.square")
                        .font(.title2)
                } else {
                    HStack(alignment: .bottom ,spacing: 4) {
                        Image(systemName: "arrow.up.arrow.down.square.fill")
                            .font(.title2)
                        Text(todoStore.sortMode.localizedString)
                            .font(.caption)
                    }
                }
            }
            
            Spacer()

            Button {
                withAnimation {
                    todoStore.isEditing.toggle()
                }
            } label: {
                Text(todoStore.isEditing ? "Done" : "Edit")
            }
            .transition(.opacity)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .tint(themeManager.getColorInPriority(of: .accent))
    }
}


// MARK: - Bottom Editing Console
extension ToDoList {
    var multiSelectionCount: Int {
        todoStore.multiSelection.count
    }
    
    @ViewBuilder
    var bottomEditingConsole: some View {
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



