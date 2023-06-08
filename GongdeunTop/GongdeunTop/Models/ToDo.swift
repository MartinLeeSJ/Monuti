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
    var createdAt: Date
}
