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
    @EnvironmentObject var todoManager: ToDoManager
    @EnvironmentObject var targetManager: TargetManager
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
                themeManager.colorInPriority(of: .background)
                    .ignoresSafeArea()
                
                VStack(spacing: 4) {
                    viewSwitch
                    Divider()
                    switch currentDisplayingView {
                    case .todo: ToDoList()
                                .transition(.move(edge: edge).animation(.linear(duration: 0.3)))
                    case .calendar: ProgressView()
                    case .target: TargetList()
                            .transition(.move(edge: edge).animation(.linear(duration: 0.3)))
                                    
                    }
                    
                    Spacer()
                    
                    MainConsole(displayingView: $currentDisplayingView)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    themeManager.appLogoImage()
                        .resizable()
                        .frame(width: 36, height: 36)
                }
                
                ToolbarItem(placement: .principal) {
                    MainSettingBanner(todoCount: todoManager.todos.count,
                                      numOfSessions: timerManager.timeSetting.sessions.count,
                                      minute: timerManager.getMinute(of: timerManager.getTotalSeconds()),
                                      seconds: timerManager.getSeconds(of: timerManager.getTotalSeconds()))
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
                    .tint(themeManager.colorInPriority(of: .accent))
                }
            }
            .onAppear {
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
                    if granted {
                        print("Notifications authorization granted.")
                    } else {
                        print("Notifications authorization denied.")
                    }
                }
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
                        .foregroundStyle(themeManager.colorInPriority(of: .accent), .gray)
                        .font(.headline)
                        .symbolRenderingMode(.hierarchical)
                    Spacer()
                    Text("\(todoManager.todos.count)")
                        .font(.title3)
                }
            }
        }
        .fontWeight(.bold)
        .padding(8)
        .background(themeManager.componentColor(), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            if self.currentDisplayingView == .todo {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(themeManager.colorInPriority(of: .accent), lineWidth: 3)
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
                        .foregroundStyle(themeManager.colorInPriority(of: .accent), .gray)
                        .font(.headline)
                    Spacer()
                    Text("\(targetManager.targets.count)")
                        .font(.title3)
                }
            }
        }
        .fontWeight(.bold)
        .padding(8)
        .background(themeManager.componentColor(), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            if self.currentDisplayingView == .target {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(themeManager.colorInPriority(of: .accent), lineWidth: 3)
            }
        }
    }
    
    var formattedToday: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        dateFormatter.locale = .current
        return dateFormatter.string(from: Date.now)
    }
    
    var calendarViewButton: some View {
        NavigationLink {
            CalendarView()
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Text("viewSwitch_calendar")
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(themeManager.colorInPriority(of: .accent))
                    Spacer()
                    Text(formattedToday)
                }
            }
        }
        .font(.headline)
        .fontWeight(.bold)
        .padding(8)
        .background(themeManager.componentColor(), in: RoundedRectangle(cornerRadius: 8))
    }
    
}

struct MainRouterView_Previews: PreviewProvider {
    static var previews: some View {
        MainRouterView()
            .environmentObject(ThemeManager())
    }
}
