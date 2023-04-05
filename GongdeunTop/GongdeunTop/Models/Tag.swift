//
//  Tag.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/30.
//

import Foundation
import FirebaseFirestoreSwift

struct Tag: Codable, Hashable, Identifiable {
    @DocumentID var id: String?
    var title: String = ""
    var count: Int = 0
}
