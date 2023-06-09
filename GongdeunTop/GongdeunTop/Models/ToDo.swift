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
    
    private var todoDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }
    
    var startingTimeString: String? {
        guard let time = startingTime else { return nil }
        var timeStringArray =  self.todoDateFormatter.string(from:  time)
            .split(separator: " ")
            .map { String($0) }
        
        timeStringArray.insert("\n", at: 1)
        
        return timeStringArray.reduce("", + )
    }
}
