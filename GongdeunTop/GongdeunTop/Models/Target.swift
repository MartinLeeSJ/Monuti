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
    
    var dateTerms: String {
        switch daysFromStartToDueDate {
        case 0...3: return String(localized: "ShortTerm")
        case 4...15: return String(localized: "MidTerm")
        case 16...30: return String(localized: "LongTerm")
        case 31...: return String(localized: "VeryLongTerm")
        default: return String("")
        }
    }
}


