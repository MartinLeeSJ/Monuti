//
//  CalendarManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/26.
//

import Foundation


final class CalendarManager: ObservableObject {
    @Published var currentMonthData: [Date] = []
    @Published var selectedDate: Date = Date() {
        didSet {
            updateCurrentMonthData()
        }
    }
    
    
    init() {
      updateCurrentMonthData()
    }
    
    
    private func updateCurrentMonthData() {
        let dateInterval = Calendar.current.dateInterval(of: .month, for: selectedDate)!
        let startDate = dateInterval.start
        let endDate = dateInterval.end
        var currentDate = startDate
        var monthData: [Date] = []
        
        print("startDate : \(startDate)")
        print("endDate : \(endDate)")
        
        while currentDate < endDate {
            monthData.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }

        currentMonthData = monthData
    }
    
    private func selectDate(_ date: Date) {
        selectedDate = date
    }
    
    func handleNextButton() {
        selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate)!
    }
    
    func handleTodayButton() {
        selectedDate = Date()
    }
    
    func handlePreviousButton() {
        selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate)!
    }
}
