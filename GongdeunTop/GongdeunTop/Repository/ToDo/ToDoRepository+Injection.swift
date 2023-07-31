//
//  ToDoRepository+Injection.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/26.
//

import Foundation
import Factory

extension Container {
    public var todoRepository: Factory<ToDoRepository> {
        self {
            ToDoRepository()
        }.singleton
    }
    
    var todoOfTargetRepository: ParameterFactory<Target, ToDoOfTargetRepository> {
        self { ToDoOfTargetRepository(target: $0) }.singleton
    }
}
