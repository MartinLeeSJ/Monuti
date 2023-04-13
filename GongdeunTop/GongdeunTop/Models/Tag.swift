//
//  Tag.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/30.
//

import Foundation

struct Tag: Codable, Hashable, Identifiable {
    var id: String { self.title }
    var title: String
    var count: Int
}
