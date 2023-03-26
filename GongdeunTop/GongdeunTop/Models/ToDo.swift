//
//  ToDo.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/20.
//

import Foundation

struct ToDo: Hashable, Identifiable {
    var id: UUID = UUID()
    var title: String = ""
    var content: String = ""
    var tags: [String] = []
    var timeSpent: Int = 0
}
