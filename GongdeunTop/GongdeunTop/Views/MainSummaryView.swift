//
//  MainSummaryView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/06/05.
//

import SwiftUI

struct MainSummaryView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject var todoStore = ToDoStore()
    @StateObject var timerManager = TimerManager()
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.getColorInPriority(of: .background)
                    .ignoresSafeArea()
                ScrollView {
                    grid
                }
                .padding()
            }
            .toolbar {
                
            }
        }
    }
}

extension MainSummaryView {
    @ViewBuilder
    var grid: some View {
        LazyVGrid(columns: .init(repeating: .init(.flexible(), spacing: 10), count: 2), spacing: 10) {
            todoListViewButton
            targetListViewButton
            calendarViewButton
        }
        .font(.title3.weight(.semibold))
        .tint(Color("basicFontColor"))
    }
    
    @ViewBuilder
    var todoListViewButton: some View {
        NavigationLink {
            ToDoList()
                .environmentObject(todoStore)
                .environmentObject(timerManager)
        } label: {
            VStack(alignment: .trailing) {
                HAlignment(alignment: .leading) {
                    Text("오늘 할 일")
                    Image(systemName: "checklist")
                        .foregroundStyle(themeManager.getColorInPriority(of: .accent), .gray)
                }
                Spacer()
                Text("0")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding()
            .background(themeManager.getComponentColor(), in: RoundedRectangle(cornerRadius: 8))
        }
    }
    
    @ViewBuilder
    var targetListViewButton: some View {
        NavigationLink {
            TargetList()
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
        .background(themeManager.getComponentColor(), in: RoundedRectangle(cornerRadius: 8))
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
        .background(themeManager.getComponentColor(), in: RoundedRectangle(cornerRadius: 8))
    }
}

struct MainSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        MainSummaryView()
            .environmentObject(ThemeManager())
    }
}
