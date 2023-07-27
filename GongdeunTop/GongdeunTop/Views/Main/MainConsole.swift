//
//  MainConsole.swift
//  GongdeunTop
//
//  Created by Martin on 2023/06/05.
//

import SwiftUI

struct MainConsole: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var todoManager: ToDoManager
    @EnvironmentObject var timerManager: TimerManager
    @EnvironmentObject var targetManager: TargetManager
    
    @State private var isSetTimeViewOn: Bool = false
    @State private var isAddTargetSheetOn: Bool = false
    @State private var isAddToDoSheetOn: Bool = false
    @Binding var displayingView: MainRouterView.DisplayingViews
    

    
    var body: some View {
        VStack {
            HStack {
                addButton
                    .tint(themeManager.colorInPriority(of: .accent))
                
                Button {
                    isSetTimeViewOn.toggle()
                } label: {
                    HStack(spacing: 4) {
                        Text("Set Time")
                        Image(systemName: "clock")
                    }
                    .font(.headline)
                    .foregroundColor(Color("basicFontColor"))
                    .frame(width: .getScreenWidthDivided(with: 4), height: 36)
                }
                .sheet(isPresented: $isSetTimeViewOn) {
                    SetTimeForm(manager: timerManager)
                        .presentationDetents([.fraction(0.65)])
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(themeManager.colorInPriority(of: .accent).opacity(0.3),
                            in: RoundedRectangle(cornerRadius: 10))
                
                NavigationLink {
                    SessionsTimer(todos: todoManager.todos,
                                  currentTodo: todoManager.todos.first)
                    .environmentObject(timerManager)
                } label: {
                    HStack(spacing: 4) {
                        Text("Start")
                        Image(systemName: "play.fill")
                    }
                    .foregroundColor(Color("basicFontColor"))
                    .font(.headline)
                    .frame(width: .getScreenWidthDivided(with: 3), height: 36)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(themeManager.componentColor(),
                            in: RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(themeManager.colorInPriority(of: .accent), lineWidth: 2)
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal)
        }
        .animation(.easeIn, value: todoManager.isEditing)
        .background(.clear)
    }
    
}

// MARK: - Add Target Or ToDo
extension MainConsole{
    private var addButtonLabel: some View {
        HAlignment(alignment: .center) {
            Label("Add", systemImage: "plus.circle.fill")
                .labelStyle(.iconOnly)
                .font(.title)
        }
    }
    
    private var addTodoButton: some View {
        Button {
           isAddToDoSheetOn.toggle()
        } label: {
            addButtonLabel
        }
        .sheet(isPresented: $isAddToDoSheetOn) {
            SetToDoForm(targets: targetManager.targets) { todo in
                todoManager.addToDo(todo)
            }.presentationDetents([.large])
        }
    }
    
    private var addTargetButton: some View {
        Button {
            isAddTargetSheetOn.toggle()
        } label: {
            addButtonLabel
        }
        .sheet(isPresented: $isAddTargetSheetOn) {
            SetTargetForm { target in
                targetManager.addTarget(target)
            }
            .presentationDetents([.large])
        }
    }
    
    @ViewBuilder
    private var addButton: some View {
        switch displayingView {
        case .todo: addTodoButton
        case .target: addTargetButton
        default: addTodoButton
        }
    }
}

