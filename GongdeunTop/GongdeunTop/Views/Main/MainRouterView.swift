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
    @EnvironmentObject var timerSettingManager: TimerSettingManager
    
    
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
                themeManager.colorInPriority(in: .background)
                    .ignoresSafeArea()
                
                VStack(spacing: 4) {
                    viewSwitches
                    Divider()
                    switch currentDisplayingView {
                    case .todo: ToDoList()
                                .transition(.move(edge: edge).animation(.linear(duration: 0.3)))
                    case .calendar: ProgressView()
                    case .target: TargetList()
                            .transition(.move(edge: edge).animation(.linear(duration: 0.3)))
                                    
                    }
                }
            }
            .safeAreaInset(edge: .bottom)  {
                MainConsole(displayingView: $currentDisplayingView)
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
                                      numOfSessions: timerSettingManager.timeSetting.sessions.count,
                                      minute: timerSettingManager.getMinute(of: timerSettingManager.getTotalSeconds()),
                                      seconds: timerSettingManager.getSeconds(of: timerSettingManager.getTotalSeconds()))
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
                    .tint(themeManager.colorInPriority(in: .accent))
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
    var viewSwitches: some View {
        HStack(spacing: 8) {
            todoListViewButton
            targetListViewButton
            calendarViewButton
        }
        .font(.headline.weight(.semibold))
        .tint(Color("basicFontColor"))
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    func viewSwitchLabel(title: LocalizedStringKey, imageName: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
                Text(title)
            HStack {
                Image(systemName: imageName)
                    .foregroundStyle(themeManager.colorInPriority(in: .accent), .gray)
                    .symbolRenderingMode(.hierarchical)
                Spacer()
                Text(content)
            }
        }
    }
    
    @ViewBuilder
    var todoListViewButton: some View {
        Button {
            withAnimation {
                self.currentDisplayingView = .todo
            }
        } label: {
            viewSwitchLabel(title: "viewSwitch_todo",
                            imageName: "checklist",
                            content: "\(todoManager.todos.count)")
        }
        .padding(8)
        .background(themeManager.componentColor(), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            if self.currentDisplayingView == .todo {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(themeManager.colorInPriority(in: .accent), lineWidth: 3)
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
            viewSwitchLabel(title: "viewSwitch_target",
                            imageName: "target",
                            content: "\(targetManager.targets.count)")
        }
        .padding(8)
        .background(themeManager.componentColor(), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            if self.currentDisplayingView == .target {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(themeManager.colorInPriority(in: .accent), lineWidth: 3)
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
            viewSwitchLabel(title: "viewSwitch_calendar",
                            imageName: "calendar",
                            content: formattedToday)
        }
        .padding(8)
        .background(themeManager.componentColor(), in: RoundedRectangle(cornerRadius: 8))
    }
    
}


