//
//  ToDo.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/20.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ToDo: Codable, Hashable, Identifiable {
    @DocumentID var id: String?
    var title: String = ""
    var content: String = ""
    var tags: [String] = []
    var timeSpent: Int = 0
    var isCompleted: Bool = false
    var startingTime: Date? = Date.now
    var relatedTarget: String? = nil
    var createdAt: Date
    
    
    var startingTimeString: String? {
        guard let time = startingTime else { return nil }

        return "\(dayString(from: time))\n\(timeString(from: time))"
    }
    
    private func timeString(from time: Date) -> String {
        DateFormatter.localizedString(from: time, dateStyle: .none, timeStyle: .short)
    }
    
    private func dayString(from time: Date) -> String {
        let current = Calendar.current
        var result: String = ""
        
        if current.isDateInToday(time) { result = String(localized: "Today") }
        else if current.isDateInTomorrow(time) { result = String(localized: "Tomorrow") }
        
        return result
    }
    
}
