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
               createdAt: Date.now,
               startDate: Date.now,
               dueDate: Date.now,
               todos: [],
               achievement: 0,
               memoirs: "")
    }
    
}

