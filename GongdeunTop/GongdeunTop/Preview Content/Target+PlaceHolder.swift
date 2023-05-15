//
//  Target+PlaceHolder.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/15.
//

import Foundation
import FirebaseFirestore

extension Target {
    static var placeholder: Target {
        Target(title: "",
               subtitle: "",
               createdAt: Timestamp(date: Date.now)
               , startDate: Timestamp(date: Date.now),
               dueDate: Timestamp(date: Date.now),
               todos: [],
               achievement: 0,
               memoirs: "")
    }
}
