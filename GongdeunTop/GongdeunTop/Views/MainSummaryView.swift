//
//  MainSummaryView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/06/05.
//

import SwiftUI

struct MainSummaryView: View {
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
    @StateObject var todoStore = ToDoStore()
    @StateObject var timerManager = TimerManager()
    
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
                                .environmentObject(todoStore)
                                .environmentObject(timerManager)
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
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    themeManager.getAppLogoImage()
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36)
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
                    Button {
                        withAnimation {
                            todoStore.isEditing.toggle()
                        }
                    } label: {
                        Text(todoStore.isEditing ? "Done" : "Edit")
                    }
                    .tint(Color("basicFontColor"))
                }
            }
            .onAppear {
                todoStore.subscribeTodos()
            }
            .onDisappear {
                todoStore.unsubscribeTodos()
            }
        }
    }
}

extension MainSummaryView {
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
                Text("0")
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
            RecordView()
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

struct MainSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        MainSummaryView()
            .environmentObject(ThemeManager())
    }
}
