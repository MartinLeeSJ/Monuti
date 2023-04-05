//
//  Day.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/03.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Day: Codable, Hashable, Identifiable {
    @DocumentID var id: String?
    var createdAt: Timestamp
    var todos: [String]
}
