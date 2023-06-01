//
//  Target.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/13.
//

import Foundation
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
    var achievement: Int
    var memoirs: String // 회고
    
    private var targetDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
    
    var startDateString: String {
        return self.targetDateFormatter.string(from:  startDate)
    }
    
    var dueDateString: String {
        return self.targetDateFormatter.string(from:  dueDate)
    }
    
    var daysFromStartToDueDate: Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: startDate)
        let due = calendar.startOfDay(for: dueDate)
        let numberOfDays = calendar.dateComponents([.day], from: start, to: due)
        let day = numberOfDays.day ?? 0
        return day < 0 ? 0 : (day + 1)
    }
}

// MARK: - Terms
extension Target {
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
    }
}

