//
//  Tag.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/30.
//

import Foundation

struct Tag: Hashable, Identifiable {
    var id: String = UUID().uuidString
    var title: String = ""
    var count: Int = 0
}
