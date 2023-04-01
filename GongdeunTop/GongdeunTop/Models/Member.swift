//
//  Member.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/01.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Member: Hashable, Codable, Identifiable {
    @DocumentID var id: String?
    var email: String
    var fullName: String
    var createdAt: Timestamp
}
