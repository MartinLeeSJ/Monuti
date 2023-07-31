//
//  TargetDetailManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/06/13.
//

import Foundation

import Combine
import Factory

import FirebaseAuth
import FirebaseFirestore

class TargetDetailManager: ObservableObject {
    var todoOfTargetRepository: ToDoOfTargetRepository
    @Published var todos: [ToDo] = []
    
    var completedTodo: [ToDo] {
        todos.filter { $0.isCompleted }
    }
    
    var unCompletedTodo: [ToDo] {
        todos.filter { $0.isCompleted }
    }
    
    private var listenerRegistration: ListenerRegistration?
    
    init(target: Target = Target(title: "",
                                 subtitle: "",
                                 createdAt: .now,
                                 startDate: .now,
                                 dueDate: .now,
                                 todos: [],
                                 memoirs: "")) {
        self.todoOfTargetRepository = Container.shared.todoOfTargetRepository(target)
        
        todoOfTargetRepository
            .$todos
            .assign(to: &$todos)
    }
}
