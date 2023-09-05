//
//  Cycle+Preview.swift
//  GongdeunTop
//
//  Created by Martin on 2023/08/23.
//

import Foundation
import FirebaseFirestore

extension Cycle {
    static let previews: [Self] = [
        Cycle(createdAt: Timestamp(date: Date(timeIntervalSinceNow: 1600)),
              todos: [],
              evaluation: 1,
              memoirs: "잘했어5959!"),
        Cycle(createdAt: Timestamp(date: Date(timeIntervalSinceNow: 1200)),
              todos: [],
              evaluation: 2,
              memoirs: "잘했어59!"),
        Cycle(createdAt: Timestamp(date: Date(timeIntervalSinceNow: 1800)),
              todos: [],
              evaluation: 2,
              memoirs: "잘했어5!"),
        Cycle(createdAt: Timestamp(date: Date(timeIntervalSinceNow: 600)),
              todos: [],
              evaluation: 3,
              memoirs: "잘했어3!"),
        Cycle(createdAt: Timestamp(date: Date(timeIntervalSinceNow: 2400)),
              todos: [],
              evaluation: 2,
              memoirs: "잘했어22!"),
    ]

}
