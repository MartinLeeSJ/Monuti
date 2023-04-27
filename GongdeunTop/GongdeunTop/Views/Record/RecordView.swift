//
//  RecordView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI

enum WeekDays: String, Identifiable, CaseIterable {
    case Sun = "Sun"
    case Mon, Tue, Wed, Thu, Fri, Sat
    
    var id: Self { self }
    
}

struct RecordView: View {
    @ObservedObject var authViewModel: AuthManager
    @StateObject var calendarManager = CalendarManager()
    @StateObject var cycleStore = CycleStore()
    
    @State private var showingSetMonth: Bool = false

    var firstWeekdayDigit: Int {
        if let startDate = calendarManager.currentMonthData.first {
            
            return Int(startDate.formatted(Date.FormatStyle().weekday(.oneDigit))) ?? 1
        } else {
            return 1
        }
    }
    
    var currentMonth: String {
        calendarManager.startingPointDate.formatted(Date.FormatStyle().month(.abbreviated))
    }
    
    var isCalendarInCurrentMonth: Bool {
        calendarManager.startingPointDate.formatted(Date.FormatStyle().year().month())
        == Date().formatted(Date.FormatStyle().year().month())
    }
    
    var currentYear: String {
        calendarManager.startingPointDate.formatted(Date.FormatStyle().year(.defaultDigits))
    }
    
    private func handleNextMonth() {
        calendarManager.handleNextButton(.month)
        cycleStore.resetAndSubscribe(calendarManager.startingPointDate)
    }
    
    private func handlePreviousMonth() {
        calendarManager.handlePreviousButton(.month)
        cycleStore.resetAndSubscribe(calendarManager.startingPointDate)
    }
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 0), count: 7), spacing: 0) {
                    ForEach(WeekDays.allCases) { weekday in
                        HStack(alignment: .center) {
                            Text(String(localized: LocalizedStringResource(stringLiteral: weekday.rawValue))
                            )
                            .font(.headline)
                            .padding(5)
                        }
                    }
                    
                    ForEach(1..<firstWeekdayDigit, id: \.self) { _ in
                        VStack {
                            Spacer()
                        }
                    }
                    
                    ForEach(calendarManager.currentMonthData, id: \.self) { date in
                        DateCell(manager: calendarManager, date: date)
                    }
                    .gesture(DragGesture(minimumDistance: 2.0, coordinateSpace: .local)
                        .onEnded { value in
                            switch(value.translation.width, value.translation.height) {
                            case (...0, -50...50):
                                handleNextMonth()
                            case (0..., -50...50):
                                handlePreviousMonth()
                            default:  print("no clue")
                            }
                        })
                }
                
                
                Divider()
                
                List(cycleStore.cyclesOrderedByDate[calendarManager.selectedDate] ?? []) { cycle in
                    CycleListCell(cycleManager: CycleManager(cycle: cycle))
                }
                .listStyle(.plain)
                
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSetMonth.toggle()
                    } label: {
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text(currentMonth)
                                .font(.title.bold())
                            
                            Text(currentYear)
                                .font(.callout)
                                .foregroundColor(.secondary)
                                
                            Image(systemName: "chevron.down.circle")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                }
                
                if !isCalendarInCurrentMonth {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            calendarManager.handleTodayButton()
                        } label: {
                            Text("오늘")
                        }
                    }
                }
            }
            .blur(radius: showingSetMonth ? 10 : 0)
        }
        .overlay {
            if showingSetMonth {
                SetMonthView(manager: calendarManager, isShowing: $showingSetMonth)
            }
        }
        .onAppear {
            cycleStore.subscribeCycles(Date())
        }
        .onDisappear {
            cycleStore.unsubscribeCycles()
        }
    }
}








struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecordView(authViewModel: AuthManager())
                .environment(\.locale, .init(identifier: "ko"))
            RecordView(authViewModel: AuthManager())
                .environment(\.locale, .init(identifier: "en"))
        }
    }
}
