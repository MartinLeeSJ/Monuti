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
    @State private var isNotificationTriggered: Bool = false
    
    private func isTodoStartingTimeTomorrow(_ todo: ToDo) -> Bool {
        if let date = todo.startingTime, Calendar.current.isDateInTomorrow(date) { return true }
        return false
    }
    
    var body: some View {
        ZStack {
            themeManager.colorInPriority(of: .background)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                topEditingConsole
                
                if !todoManager.todos.isEmpty {
                    List(todoManager.todos, id: \.self.id, selection: $todoManager.multiSelection) { todo in
                        Section("toDoList_Today") {
                            if !isTodoStartingTimeTomorrow(todo) {
                                ToDoListRow(todo: todo, targets: targetManager.targets)
                                    .todoListRowStyle()
                            }
                        }
                        Section("toDoList_Tomorrow") {
                            if isTodoStartingTimeTomorrow(todo) {
                                ToDoListRow(todo: todo, targets: targetManager.targets)
                                    .todoListRowStyle()
                            }
                        }
                    }
                    .listStyle(.plain)
                    .environment(\.editMode, .constant(todoManager.isEditing ? EditMode.active : EditMode.inactive))
                }
                Spacer()
                
                Divider()
                
                if todoManager.isEditing {
                    multipleEditingConsole
                }
            }
        }
        .popNotification(hasTriggered: $isNotificationTriggered, text: "extendTodos_Pop", lasts: .long)
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
    
    var isTodaysTodoLeft: Bool {
        !todoManager.todos.filter { Calendar.current.isDateInToday($0.startingTime ?? Date.now) }.isEmpty
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
    
    private func triggerPopNotification() {
        isNotificationTriggered.toggle()
    }
    
    @ViewBuilder
    private var endOfTheDayNotice: some View {
        Spacer()
        if isTimeNearEndOfTheDay && isTodaysTodoLeft {
            Button {
                isExtendingTodosLifeAlertOn = true
            } label: {
                Label("extendTodos_button_label", systemImage: "questionmark.circle")
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .buttonStyle(.bordered)
            .alert("extendTodos_alert_title", isPresented: $isExtendingTodosLifeAlertOn) {
                Button(role: .destructive) {
                    isExtendingTodosLifeAlertOn = false
                } label: {
                    Text("Cancel")
                }

                Button {
                    todoManager.updateToDosExpiration(todoManager.todos)
                    isExtendingTodosLifeAlertOn = false
                    triggerPopNotification()
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


// MARK: - Multiple Editing Console
extension ToDoList {
    var multiSelectionCount: Int {
        todoManager.multiSelection.count
    }
    
    @ViewBuilder
    var multipleEditingConsole: some View {
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



