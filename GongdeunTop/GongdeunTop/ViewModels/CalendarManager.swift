//
//  CalendarManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/26.
//

import Foundation


final class CalendarManager: ObservableObject {
    @Published var currentMonthData: [Date] = []
    @Published var currentYearData: [Date] = []
    @Published var startingPointDate: Date = Date() {
        didSet {
            getCurrentMonthData()
            getCurrentYearDate()
        }
    }
    @Published var selectedDate: Date = Date()
    
    var firstWeekdayDigit: Int {
        if let startDate = currentMonthData.first {
            
            return Int(startDate.formatted(Date.FormatStyle().weekday(.oneDigit))) ?? 1
        } else {
            return 1
        }
    }
    
    var currentMonth: String {
        startingPointDate.formatted(Date.FormatStyle().month(.abbreviated))
    }
    
    var isCalendarInCurrentMonth: Bool {
        startingPointDate.formatted(Date.FormatStyle().year().month())
        == Date().formatted(Date.FormatStyle().year().month())
    }
    
    var currentYear: String {
        startingPointDate.formatted(Date.FormatStyle().year(.defaultDigits))
    }
    
    init() {
      getCurrentMonthData()
      getCurrentYearDate()
    }
    
    
    private func getCurrentMonthData() {
        let dateInterval = Calendar.current.dateInterval(of: .month, for: startingPointDate)!
        let startDate = dateInterval.start
        let endDate = dateInterval.end
        var currentDate = startDate
        var monthData: [Date] = []
        
        while currentDate < endDate {
            monthData.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }

        currentMonthData = monthData
    }
    
    private func getCurrentYearDate() {
        let dateInterval = Calendar.current.dateInterval(of: .year, for: startingPointDate)!
        let startDate = dateInterval.start
        let endDate = dateInterval.end
        var currentDate = startDate
        var yearData: [Date] = []
        
        while currentDate < endDate {
            yearData.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
        }
        
        currentYearData = yearData
    }
    
    
    
    
   func selectStartingPointDate(_ date: Date) {
        startingPointDate = date
    }
    
    func handleNextButton(_ components: Calendar.Component) {
        startingPointDate = Calendar.current.date(byAdding: components, value: 1, to: startingPointDate)!
    }
    
    func handleTodayButton() {
        startingPointDate = Date()
    }
    
    func handlePreviousButton(_ components: Calendar.Component) {
        startingPointDate = Calendar.current.date(byAdding: components, value: -1, to: startingPointDate)!
    }
}
