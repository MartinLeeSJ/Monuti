//
//  CalendarManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/26.
//

import Foundation
import Combine

final class CalendarManager: ObservableObject {
    @Published var currentMonthData: [Date] = []
    @Published var currentYearData: [Date] = []
    @Published var startingPointDate: Date = Date()
    @Published var selectedDate: Date = Date()
    
    
    public var firstWeekdayDigit: Int {
        if let startDate = currentMonthData.first {
            let dateFormatted
            = Date.FormatStyle(locale: .init(identifier: "ko-KR"), calendar: Calendar.current).weekday(.oneDigit)
            
            return Int(startDate.formatted(dateFormatted)) ?? 1
        } else {
            return 1
        }
    }
    
    public var currentMonth: String {
        startingPointDate.formatted(Date.FormatStyle().month(.abbreviated))
    }
    
    public var isCalendarInCurrentMonth: Bool {
        startingPointDate.formatted(Date.FormatStyle().year().month())
        == Date().formatted(Date.FormatStyle().year().month())
    }
    
    public var currentYear: String {
        startingPointDate.formatted(Date.FormatStyle().year(.defaultDigits))
    }
    
    private let calendarCache = NSCache<NSDate, NSArray>()
    
    init() {
        $startingPointDate
            .map { [weak self] date in
                self?.getCurrentMonthData(from: date) ?? []
            }
            .assign(to: &$currentMonthData)
        
        
        $startingPointDate
            .subscribe(on: DispatchQueue.main)
            .map { [weak self] date in
                self?.getCurrentYearDate(from: date) ?? []
            }
            .assign(to: &$currentYearData)
    }
    
    private func getCurrentMonthData(from base: Date) -> [Date] {
        let calendar = Calendar.current
        let dateInterval = calendar.dateInterval(of: .month, for: base)!
        let startDate = dateInterval.start
        let endDate = dateInterval.end
        
        let cacheKey = calendar.startOfDay(for: startDate) as NSDate
        
        if let cachedMonthData = calendarCache.object(forKey: cacheKey) as? [Date] {
            return cachedMonthData
        }
        
        var currentDate = startDate
        var monthData: [Date] = []
        
        while currentDate < endDate {
            monthData.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        calendarCache.setObject(monthData as NSArray, forKey: cacheKey)
        
        return monthData
    }
    
    private func getCurrentYearDate(from base: Date) -> [Date] {
        let dateInterval = Calendar.current.dateInterval(of: .year, for: base)!
        let startDate = dateInterval.start
        let endDate = dateInterval.end
        var currentDate = startDate
        var yearData: [Date] = []
        
        while currentDate < endDate {
            yearData.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
        }
        
        return yearData
    }
    
    
    
    public func selectDate(_ date: Date) {
        selectedDate = date
    }
    
    public func selectStartingPointDate(_ date: Date) {
        startingPointDate = date
    }
    
    public func handleNextButton(_ components: Calendar.Component) {
        startingPointDate = Calendar.current.date(byAdding: components, value: 1, to: startingPointDate)!
    }
    
    public func handleBackToTodayButton() {
        let now = Date.now
        startingPointDate = now
        selectedDate = now
    }
    
    public func handlePreviousButton(_ components: Calendar.Component) {
        startingPointDate = Calendar.current.date(byAdding: components, value: -1, to: startingPointDate)!
    }
}
