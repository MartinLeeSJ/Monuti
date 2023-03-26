//
//  ToDoViewModel.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/20.
//

import Foundation

final class ToDoViewModel: ObservableObject {
    @Published var todo: ToDo
    @Published var todos: [ToDo] {
        willSet(newValue) {
            if !newValue.isEmpty {
                currentTodo = newValue.first!
            }
        }
    }
    
    @Published var currentTodo: ToDo? = nil
    
    init(todo: ToDo = .init(title: "", content: "", tags: [], timeSpent: 0), todos: [ToDo] = []) {
        self.todo = todo
        self.todos = todos
    }
}
