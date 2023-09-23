//
//  ToDoHistoryManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/09/20.
//

import Foundation
import Combine

import Factory

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

final class ToDoHistoryManager: ObservableObject {
    @Injected(\.todoHistoryRepository) var todoHistoryRepository
    @Published var date: Date = Date.now
    @Published var todos: [ToDo] = []
    @Published var completedTodos: [ToDo] = []
    @Published var notCompletedTodos: [ToDo] = []
    
    private var cancelables = Set<AnyCancellable>()
    
    init() {
        todoHistoryRepository
            .$todos
            .assign(to: &$todos)
        
        $todos
            .sink { [weak self] todos in
                let initialResult = ([ToDo](), [ToDo]())
                let seperatedTodos = todos.reduce(into: initialResult) { result, todo in
                    if todo.isCompleted {
                        result.0.append(todo)
                    } else {
                        result.1.append(todo)
                    }
                }
                self?.completedTodos = seperatedTodos.0
                self?.notCompletedTodos = seperatedTodos.1
            }
            .store(in: &cancelables)
    }
    
    func setDate(_ date: Date) {
        self.date = date
        todoHistoryRepository.setDate(date)
    }
}



