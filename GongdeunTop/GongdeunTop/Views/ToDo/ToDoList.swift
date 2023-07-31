//
//  ToDoList.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI


struct ToDoList: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var todoManager: ToDoManager
    @EnvironmentObject var targetManager: TargetManager
    @EnvironmentObject var timerManager: TimerManager
    
    @State private var isDeleteAlertOn: Bool = false
    @State private var isExtendingTodosLifeAlertOn: Bool = false
    
    var body: some View {
        ZStack {
            themeManager.colorInPriority(of: .background)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                topEditingConsole
                
                if !todoManager.todos.isEmpty {
                    List(todoManager.todos, id: \.self.id, selection: $todoManager.multiSelection) { todo in
                        ToDoListRow(todo: todo, targets: targetManager.targets)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init(top: 8, leading: 16, bottom: 0, trailing: 16))
                    }
                    .listStyle(.plain)
                    .environment(\.editMode, .constant(todoManager.isEditing ? EditMode.active : EditMode.inactive))
                }
                
                Spacer()
                
                Divider()
                
                if todoManager.isEditing {
                    bottomEditingConsole
                }
            }
        }
    }
}

// MARK: - Top Editing Console
extension ToDoList {
    var isTimeNearEndOfTheDay: Bool {
        let calendar = Calendar.current
        let endOfThisHour: Date = calendar.dateInterval(of: .hour, for: Date.now)?.end ?? Date()
        let endOfThisDay: Date = calendar.dateInterval(of: .day, for: Date.now)?.end ?? Date()
        return endOfThisHour == endOfThisDay
    }
    
    @ViewBuilder
    var topEditingConsole: some View {
        HStack {
            sortingMenu
            endOfTheDayNotice
            multipleEditingButton
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .tint(themeManager.colorInPriority(of: .accent))
    }
    
    @ViewBuilder
    private var sortingMenu: some View {
        Menu {
            ForEach(ToDoManager.SortMode.allCases) { mode in
                Button {
                    todoManager.setSortMode(mode)
                } label: {
                    HStack {
                        Text(mode.localizedString)
                        Spacer()
                        if todoManager.sortMode == mode {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down.square\(todoManager.sortMode == .basic ? "" : ".fill")")
                .font(.title2)
            
        }
    }
    
    @ViewBuilder
    private var endOfTheDayNotice: some View {
        Spacer()
        if isTimeNearEndOfTheDay {
            Button {
                isExtendingTodosLifeAlertOn = true
            } label: {
                Label("extendTodos_button_label", systemImage: "questionmark.circle")
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .buttonStyle(.bordered)
            .alert("extendTodos_alert_title", isPresented: $isExtendingTodosLifeAlertOn) {
                Button {
                   isExtendingTodosLifeAlertOn = false
                } label: {
                    Text("Cancel")
                }
                Button {
                    todoManager.updateToDosExpiration(todoManager.todos)
                    isExtendingTodosLifeAlertOn = false
                } label: {
                    Text("Extend")
                }
            } message: {
                Text(String(localized: "will_extend?\(todoManager.todos.count)"))
            }

            
        }
        Spacer()
    }
    
    @ViewBuilder
    private var multipleEditingButton: some View {
        Button {
            withAnimation {
                todoManager.isEditing.toggle()
            }
        } label: {
            Text(todoManager.isEditing ? "Done" : "Edit")
        }
        .transition(.opacity)
    }
}


// MARK: - Bottom Editing Console
extension ToDoList {
    var multiSelectionCount: Int {
        todoManager.multiSelection.count
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
                Button(role: .destructive) {
                    todoManager.removeToDos(todoManager.todos)
                    isDeleteAlertOn.toggle()
                } label: {
                    Text("Delete")
                }
            } message: {
                Text("really_delete? \(multiSelectionCount)")
            }
            
            Spacer()
            
            Button {
                todoManager.updateToDosCompletion(todoManager.todos)
            } label: {
                Text("Complete Todo")
            }
            
        }
        .tint(themeManager.colorInPriority(of: .accent))
        .disabled(todoManager.multiSelection.isEmpty)
        .padding(.horizontal, 24)
        .padding(.vertical, 6)
    }
}



