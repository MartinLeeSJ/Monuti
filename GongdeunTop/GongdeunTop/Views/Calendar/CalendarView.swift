//
//  CalendarView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI


struct CalendarView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    
    @StateObject private var calendarManager = CalendarManager()
    @StateObject private var cycleStore = CycleStore()
    @StateObject private var todoHistoryManager = ToDoHistoryManager()
    
    @State private var showSetMonth: Bool = false
    
    @GestureState private var dragOffset = CGSize.zero

    private func handleNextMonth() {
        calendarManager.handleNextButton(.month)
        cycleStore.setBaseDate(calendarManager.startingPointDate)
    }
    
    private func handlePreviousMonth() {
        calendarManager.handlePreviousButton(.month)
        cycleStore.setBaseDate(calendarManager.startingPointDate)
    }
    
    private func handleSelectedDate(_ date: Date) {
        calendarManager.selectDate(date)
        todoHistoryManager.setDate(date)
        cycleStore.setBaseDate(date)
    }
    
    
    var body: some View {
        ZStack {
            themeManager.colorInPriority(in: .background)
                .ignoresSafeArea(.all)
            
            VStack(alignment:.leading, spacing: .spacing(of: .normal)) {
                calendarControls()
                
                calendar()
                
                Divider()
                
                if let selectedDate = calendarManager.selectedDate {
                    DayRecordView(
                        cycles: cycleStore.cyclesOfDate[selectedDate] ?? [],
                        completedTodos: todoHistoryManager.completedTodos,
                        notCompletedTodos: todoHistoryManager.notCompletedTodos
                    )
                }
                Spacer()
            }
            .padding(.horizontal)
            .blur(radius: showSetMonth ? 10 : 0)
        }
        .navigationBarBackButtonHidden()
        .navigationTitle(Text(Date.now, style: .date))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            backButton()
            backToToday()
        }
        .overlay {
            if showSetMonth {
                SetMonthView(manager: calendarManager, cycleStore: cycleStore, isShowing: $showSetMonth)
            }
        }
        .gesture(dismissGesture)
    }
    
   
}
//MARK: - Gesture
extension CalendarView {
    private var dismissGestureAreaWidth: CGFloat { 20 }
    private var dismissGestureMinimumTranslation: CGFloat { 100 }
    
    private var dismissGesture: GestureStateGesture<DragGesture, CGSize> {
        let gesture = DragGesture()
        
        return gesture.updating($dragOffset) { value, state, transaction in
            guard value.startLocation.x < dismissGestureAreaWidth else { return }
            guard value.translation.width > dismissGestureMinimumTranslation  else { return }
                
            dismiss()
        }
    }
}


//MARK: - Top Control Units
extension CalendarView {
    private func calendarControls() -> some View {
        HStack {
            monthButton()
            Spacer()
            previousMonthButton()
            nextMonthButton()
        }
    }
    
    private func monthButton() -> some View {
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
    
    private func previousMonthButton() -> some View {
        Button {
            handlePreviousMonth()
        } label: {
            Image(systemName: "chevron.left")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .buttonStyle(.bordered)
    }
    
    private func nextMonthButton() -> some View {
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
    private func calendar() -> some View {
        LazyVGrid(
            columns: Array(repeating: .init(.flexible(), spacing: .zero), count: 7),
            spacing: .spacing(of: .normal)
        ) {
            weekdays
            blanks
            dateCells
        }
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
    
    var dateCells: some View {
        ForEach(calendarManager.currentMonthData, id: \.self) { date in
            DateCell(
                selectedDate: $calendarManager.selectedDate,
                date: date,
                evaluation: cycleStore.dateEvaluations[date]
            ) {
                handleSelectedDate(date)
            }
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
            .tint(themeManager.colorInPriority(in: .accent))
        }
    }
    
    @ToolbarContentBuilder
    func backToToday() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                calendarManager.handleBackToTodayButton()
                todoHistoryManager.setDate(Date.now)
                cycleStore.setBaseDate(Date.now)
            } label: {
                Text("Today")
            }
            .tint(themeManager.colorInPriority(in: .accent))
            .opacity(isSelectedDateInSameDayAsToday ? 0 : 1)
        }
    }
    
    private var isSelectedDateInSameDayAsToday: Bool {
        guard let selectedDate = calendarManager.selectedDate else { return false }
        let calendar = Calendar.current
        return calendar.isDate(selectedDate, inSameDayAs: Date.now)
    }
}
