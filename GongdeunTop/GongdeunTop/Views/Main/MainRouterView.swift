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
        NavigationStack {
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
            .navigationBarTitleDisplayMode(.inline)
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
            VStack(alignment: .leading, spacing: 8) {
                    Text("viewSwitch_todo")
                    .font(.headline)
                
                HStack {
                    Image(systemName: "checklist")
                        .foregroundStyle(themeManager.getColorInPriority(of: .accent), .gray)
                        .font(.headline)
                        .symbolRenderingMode(.hierarchical)
                    Spacer()
                    Text("\(todoStore.todos.count)")
                        .font(.title3)
                }
            }
        }
        .fontWeight(.bold)
        .padding(8)
        .background(themeManager.getComponentColor(), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            if self.currentDisplayingView == .todo {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(themeManager.getColorInPriority(of: .accent), lineWidth: 3)
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
            VStack(alignment: .leading, spacing: 8) {
                Text("viewSwitch_target")
                    .font(.headline)
                HStack {
                    Image(systemName: "target")
                        .foregroundStyle(themeManager.getColorInPriority(of: .accent), .gray)
                        .font(.headline)
                    Spacer()
                    Text("\(targetStore.targets.count)")
                        .font(.title3)
                }
            }
        }
        .fontWeight(.bold)
        .padding(8)
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
            VStack(alignment: .leading, spacing: 8) {
                Text("viewSwitch_calendar")
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(themeManager.getColorInPriority(of: .accent))
                    Spacer()
                    Text(DateFormatter.veryShortDateformat.string(from: Date.now))
                }
            }
        }
        .font(.headline)
        .fontWeight(.bold)
        .padding(8)
        .background(themeManager.getComponentColor(), in: RoundedRectangle(cornerRadius: 8))
    }
    
}

struct MainRouterView_Previews: PreviewProvider {
    static var previews: some View {
        MainRouterView()
            .environmentObject(ThemeManager())
    }
}
