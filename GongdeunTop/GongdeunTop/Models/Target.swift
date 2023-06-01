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
}


