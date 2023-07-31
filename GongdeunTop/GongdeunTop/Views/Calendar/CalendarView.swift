//
//  CalendarView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI


enum RecordSheetType: Identifiable {
    case setting
    case cycle
    var id: Self { self }
}

struct CalendarView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject var calendarManager = CalendarManager()
    @StateObject var cycleStore = CycleStore()
    

    @State private var showSetMonth: Bool = false

    private func handleNextMonth() {
        calendarManager.handleNextButton(.month)
        cycleStore.setBaseDate(calendarManager.startingPointDate)
    }
    
    private func handlePreviousMonth() {
        calendarManager.handlePreviousButton(.month)
        cycleStore.setBaseDate(calendarManager.startingPointDate)
    }
    
    
    var body: some View {
        ZStack {
            themeManager.colorInPriority(of: .background)
                .ignoresSafeArea(.all)
            
            VStack(alignment:.leading, spacing: 16) {
                getTopConsole()
                
                getCalendar()
                
                Divider()
                
                getCycleList()
            }
            .padding(.horizontal)
            .blur(radius: showSetMonth ? 10 : 0)
        }
        .navigationBarBackButtonHidden()
        .navigationTitle(Text(Date.now, style: .date))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            backButton()
            if !calendarManager.isCalendarInCurrentMonth {
                backToToday()
            }
        }
        .overlay {
            if showSetMonth {
                SetMonthView(manager: calendarManager, cycleStore: cycleStore, isShowing: $showSetMonth)
            }
        }
        
        
    }
}

extension CalendarView {
    @ViewBuilder
    func getTopConsole() -> some View {
        HStack {
            setMonthButton()
            Spacer()
            previousMonthButton()
            nextMonthButton()
        }
    }
    
    @ViewBuilder
    func setMonthButton() -> some View {
            Button {
                showSetMonth.toggle()
            } label: {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(calendarManager.currentMonth)
                        .font(.largeTitle.bold())
                    
                    Text(calendarManager.currentYear)
                        .font(.callout)
                        .foregroundColor(.secondary)
                    
                    Image(systemName: "chevron.down.circle.fill")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }
            .tint(Color("basicFontColor"))
    }
    
    func previousMonthButton() -> some View {
        Button {
            handlePreviousMonth()
        } label: {
            Image(systemName: "chevron.left")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .buttonStyle(.bordered)
    }
    
    func nextMonthButton() -> some View {
        Button {
            handleNextMonth()
        } label: {
            Image(systemName: "chevron.right")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .buttonStyle(.bordered)
    }
}

// MARK: - 캘린더
extension CalendarView {
    @ViewBuilder
    func getCalendar() -> some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 0), count: 7), spacing: 8) {
            weekdays
            
            blanks
            
            dates
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
    
    private func getWeekdays() -> [String] {
        guard var weekdays = DateFormatter().shortStandaloneWeekdaySymbols else { return [] }
        var firstWeekdayIndex = Calendar.current.firstWeekday - 1
        
        while firstWeekdayIndex > 0 {
            let first = weekdays.removeFirst()
            weekdays.append(first)
            firstWeekdayIndex -= 1
        }
        
        return weekdays
    }
    
    
    @ViewBuilder
    var weekdays: some View {
            ForEach(getWeekdays(), id: \.self) { weekday in
                HStack(alignment: .center) {
                    Text(weekday)
                        .font(.subheadline.bold())
                        .padding(5)
                }
            }
    }
    
    var blanks: some View {
        ForEach(1..<calendarManager.firstWeekdayDigit, id: \.self) { _ in
            VStack {
                Spacer()
            }
        }
    }
    
    var dates: some View {
        ForEach(calendarManager.currentMonthData, id: \.self) { date in
            DateCell(manager: calendarManager, date: date, evaluation: cycleStore.dateEvaluations[date])
                .id(date)
        }
    }
}

// MARK: - Toolbar
extension CalendarView {
    @ToolbarContentBuilder
    func backButton() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.backward.circle.fill")
            }
            .tint(themeManager.colorInPriority(of: .accent))
        }
    }
    
    @ToolbarContentBuilder
    func backToToday() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                calendarManager.handleTodayButton()
                cycleStore.setBaseDate(calendarManager.startingPointDate)
            } label: {
                Text("Today")
            }
        }
    }
}

// MARK: - Cycle List
extension CalendarView {
    @ViewBuilder
    func getCycleList() -> some View {
        ScrollView {
            VStack {
                ForEach(cycleStore.cyclesDictionary[calendarManager.selectedDate] ?? [], id: \.self) {
                    cycle in
                    CycleListCell(cycleManager: CycleManager(cycle: cycle))
                        .tint(Color("basicFontColor"))
                }
            }
        }
    }
}





struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CalendarView(calendarManager: CalendarManager(), cycleStore: CycleStore())
                .environment(\.locale, .init(identifier: "ko"))
                .environmentObject(ThemeManager())
        }
    }
}
