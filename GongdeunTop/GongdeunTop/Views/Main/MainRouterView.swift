//
//  MainRouterView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/06/05.
//

import SwiftUI

struct MainRouterView: View {
    enum DisplayingViews: Int, Equatable {
        case todo = 0
        case target
        case calendar
        
        static func <(lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        static func >(lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue > rhs.rawValue
        }
        
        static func ==(lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue == rhs.rawValue
        }
    }
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var todoStore: ToDoStore
    @EnvironmentObject var targetStore: TargetStore
    @EnvironmentObject var timerManager: TimerManager
    
    @State private var isSettingViewOn: Bool = false
    @State private var currentDisplayingView: DisplayingViews = .todo {
        willSet(newValue) {
            if currentDisplayingView < newValue {
                self.edge = .trailing
            } else {
                self.edge = .leading
            }
        }
    }
    @State private var edge: Edge = .leading
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.getColorInPriority(of: .background)
                    .ignoresSafeArea()
                
                VStack(spacing: 4) {
                    viewSwitch
                        
                    Divider()
                    
                    switch currentDisplayingView {
                    case .todo: ToDoList()
                                .transition(.move(edge: edge).animation(.linear(duration: 0.3)))
                                
                    case .calendar: Text("Test")
                    case .target: TargetList()
                            .transition(.move(edge: edge).animation(.linear(duration: 0.3)))
                                    
                    }
                    
                    Spacer()
                    
                    MainConsole(displayingView: $currentDisplayingView)
                        .environmentObject(todoStore)
                        .environmentObject(timerManager)
                }
                .overlay(alignment: .bottom) {
                    MainSettingBanner(todoCount: todoStore.todos.count,
                                      numOfSessions: timerManager.timeSetting.numOfSessions,
                                      totalTime: timerManager.getTotalMinute())
                    .offset(y: -90)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    AppLogoView(radius: 16)
                        .offset(x: 16)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isSettingViewOn = true
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .font(.title3)
                    }
                    .sheet(isPresented: $isSettingViewOn) {
                        SettingView()
                    }
                    .tint(themeManager.getColorInPriority(of: .accent))
                }
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if currentDisplayingView == .todo {
                        Button {
                            withAnimation {
                                todoStore.isEditing.toggle()
                            }
                        } label: {
                            Text(todoStore.isEditing ? "Done" : "Edit")
                        }
                        .tint(Color("basicFontColor"))
                        .transition(.opacity)
                    }
                }
            }
            .onAppear {
                todoStore.subscribeTodos()
                targetStore.subscribeTargets()
            }
            .onDisappear {
                todoStore.unsubscribeTodos()
                targetStore.unsubscribeTargets()
            }
        }
    }
}

extension MainRouterView {
    @ViewBuilder
    var viewSwitch: some View {
        HStack(spacing: 8) {
            todoListViewButton
            targetListViewButton
            calendarViewButton
        }
        .font(.title3.weight(.semibold))
        .tint(Color("basicFontColor"))
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    @ViewBuilder
    var todoListViewButton: some View {
        Button {
            withAnimation {
                self.currentDisplayingView = .todo
            }
        } label: {
            VStack(alignment: .trailing) {
                HStack(spacing: 2) {
                    Text("할 일")
                    Image(systemName: "checklist")
                        .foregroundStyle(themeManager.getColorInPriority(of: .accent), .gray)
                    Spacer()
                }
                Spacer()
                Text("\(todoStore.todos.count)")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding()
            .frame(height: 90)
            .background(themeManager.getComponentColor(), in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                if self.currentDisplayingView == .todo {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(themeManager.getColorInPriority(of: .accent), lineWidth: 3)
                }
            }
        }
    }
    
    @ViewBuilder
    var targetListViewButton: some View {
        Button {
            withAnimation {
                self.currentDisplayingView = .target
            }
        } label: {
            VStack(alignment: .trailing) {
                HAlignment(alignment: .leading) {
                    Text("목표")
                    Image(systemName: "target")
                        .foregroundStyle(themeManager.getColorInPriority(of: .accent), .gray)
                }
                Spacer()
                Text("\(targetStore.targets.count)")
                    .font(.title)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .frame(height: 90)
        .background(themeManager.getComponentColor(), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            if self.currentDisplayingView == .target {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(themeManager.getColorInPriority(of: .accent), lineWidth: 3)
            }
        }
    }
    
    var calendarViewButton: some View {
        NavigationLink {
            CalendarView()
        } label: {
            VStack(alignment: .trailing) {
                HAlignment(alignment: .leading) {
                    Text("달력")
                    Image(systemName: "calendar")
                        .foregroundStyle(themeManager.getColorInPriority(of: .accent))
                }
                Spacer()
                Text("0")
                    .font(.title)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .frame(height: 90)
        .background(themeManager.getComponentColor(), in: RoundedRectangle(cornerRadius: 8))
    }
}

struct MainRouterView_Previews: PreviewProvider {
    static var previews: some View {
        MainRouterView()
            .environmentObject(ThemeManager())
    }
}
