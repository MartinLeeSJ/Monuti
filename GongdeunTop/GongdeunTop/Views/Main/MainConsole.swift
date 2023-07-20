//
//  MainConsole.swift
//  GongdeunTop
//
//  Created by Martin on 2023/06/05.
//

import SwiftUI

struct MainConsole: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var todoStore: ToDoStore
    @EnvironmentObject var timerManager: TimerManager
    
    @State private var isSetTimeViewOn: Bool = false
    @State private var isAddTargetSheetOn: Bool = false
    @State private var isAddToDoSheetOn: Bool = false
    @Binding var displayingView: MainRouterView.DisplayingViews
    

    
    var body: some View {
        VStack {
            HStack {
                addButton
                    .tint(themeManager.getColorInPriority(of: .accent))
                
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
                .buttonStyle(.bordered)
                .tint(themeManager.getColorInPriority(of: .accent))
                
                NavigationLink {
                    SessionsTimer(todos: todoStore.todos,
                                  currentTodo: todoStore.todos.first)
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
                .buttonStyle(.borderedProminent)
                .tint(themeManager.getColorInPriority(of: .accent))
            }
            .padding(.vertical, 6)
            .padding(.horizontal)
        }
        .animation(.easeIn, value: todoStore.isEditing)
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
            SetToDoForm()
                .presentationDetents([.medium, .large])
        }
    }
    
    private var addTargetButton: some View {
        Button {
            isAddTargetSheetOn.toggle()
        } label: {
            addButtonLabel
        }
        .sheet(isPresented: $isAddTargetSheetOn) {
            SetTargetForm()
                .presentationDetents([.medium, .large])
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

