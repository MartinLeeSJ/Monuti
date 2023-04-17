//
//  Cycle.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/03.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Cycle: Codable, Hashable, Identifiable {
    @DocumentID var id: String?
    var createdAt: Timestamp
    var todos: [String]
    var evaluation: Int // 0: No data, 1: low, 2: medium, 3: high
    var memoirs: String // 회고
}
