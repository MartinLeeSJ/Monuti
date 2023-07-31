//
//  Target.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/13.
//

import Foundation
import Darwin
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Target: Codable, Hashable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var subtitle: String
    var createdAt: Date
    var startDate: Date
    var dueDate: Date
    var todos: [String]
    var achievement: Int?
    var memoirs: String // 회고
    
    var achievementRate: Double {
        guard todos.count != 0 else { return 0 }
        let rate: Double = Double(achievement ?? 0) / Double(todos.count)
        return rate
    }
}

// MARK: - Day and Date
extension Target {
    
    var startDateString: String {
        return DateFormatter.shortDateFormat.string(from:  startDate)
    }
    
    var dueDateString: String {
        return DateFormatter.shortDateFormat.string(from:  dueDate)
    }
    
    private func getDay(from start: Date, to end: Date) -> Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: start)
        let due = calendar.startOfDay(for: end)
        let numberOfDays = calendar.dateComponents([.day], from: start, to: due)
        let day = numberOfDays.day ?? 0
        return day
    }
    
    var daysFromStartToDueDate: Int {
        let day = getDay(from: startDate, to: dueDate)
        return day < 0 ? 0 : (day + 1)
    }
    
    var dayLeftUntilStartDate: Int {
        let day = getDay(from: startDate, to: Date.now)
        return abs(day)
    }
    
    var dayLeftUntilDueDate: Int {
        let day = getDay(from: Date.now, to: dueDate)
        return abs(day)
    }
}

// MARK: - Terms
extension Target {
    var termIndex: Int {
        Terms.getTermIndex(of: daysFromStartToDueDate)
    }
    
    var dateTerms: String {
        let termString = Terms.getTermsString(of: daysFromStartToDueDate)
        return String(localized: String.LocalizationValue(termString))
    }
    
    var termColorPriority: ColorPriority {
        Terms.getTermColorPriority(of: daysFromStartToDueDate)
    }
    
    private enum Terms: String {
        case short = "ShortTerm"
        case mid = "MidTerm"
        case long = "LongTerm"
        case verylong = "VeryLongTerm"
        
        static func getTermsString(of days: Int) -> String {
            switch days {
            case 0...3: return self.short.rawValue
            case 4...15: return self.mid.rawValue
            case 16...30: return self.long.rawValue
            case 31...: return self.verylong.rawValue
            default: return String("")
            }
        }
        
        static func getTermColorPriority(of days: Int) -> ColorPriority {
            switch days {
            case 0...3: return .weak
            case 4...15: return .medium
            case 16...30: return .solid
            case 31...: return .accent
            default: return .weak
            }
        }
        
        static func getTermIndex(of days: Int) -> Int {
            switch days {
            case 0...3: return 1
            case 4...15: return 2
            case 16...30: return 3
            case 31...: return 4
            default: return 0
            }
        }
    }
}

