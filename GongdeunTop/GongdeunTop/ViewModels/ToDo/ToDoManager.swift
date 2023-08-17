//
//  ToDoManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/20.
//

import Foundation
import Combine

import Factory

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

final class ToDoManager: ObservableObject {
    @Injected(\.todoRepository) var todoRepository
    
    @Published var todos = [ToDo]()
    @Published var todayTodos = [ToDo]()
    @Published var tomorrowTodos = [ToDo]()
    
    @Published var isEditing: Bool = false
    @Published var multiSelection = Set<String?>()
    @Published var sortMode: SortMode = .basic

    private var cancellables = Set<AnyCancellable>()
    
    @MainActor
    init() {
       todoRepository
            .$todos
            .combineLatest($sortMode)
            .map { [weak self] (todos, sortMode) in
                guard let self = self else { return todos }
                switch sortMode {
                case .basic: return self.sortToDosByCreatedAt(todos)
                case .ascend: return self.sortToDosByStartingTimeAscend(todos)
                case .descend: return self.sortToDosByStartingTimeDescend(todos)
                }
            }
            .assign(to: &$todos)
    }
    
    @MainActor
    func addToDo(_ todo: ToDo) {
        Task {
            do {
                try await todoRepository.add(todo)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateToDo(_ todo: ToDo) {
        Task {
            do {
                try await todoRepository.update(todo)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateToDosCompletion(_ todos: [ToDo]) {
        guard !multiSelection.isEmpty else { return }
        let filteredToDo: [ToDo] = todos.filter {
            multiSelection.contains($0.id)
        }
        Task {
            do {
                try await todoRepository.updateCompletion(todos: filteredToDo)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateToDosExpiration(_ todos: [ToDo]) {
        Task {
            do {
                try await todoRepository.updateExpiringDate(todos: todos)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func removeToDo(_ todo: ToDo) {
        Task {
            do {
                try await todoRepository.remove(todo)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func removeToDos(_ todos: [ToDo]) {
        guard !multiSelection.isEmpty else { return }
        let filteredToDo: [ToDo] = todos.filter {
            multiSelection.contains($0.id)
        }
        Task {
            do {
                try await todoRepository.removeToDos(filteredToDo)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

// MARK: - Sorting
extension ToDoManager {
    enum SortMode: String, Identifiable, CaseIterable {
        case basic
        case ascend
        case descend
        
        var id: Self {
            self
        }
        
        var localizedString: String {
            switch self {
            case .ascend: return String(localized: "toDoList_sort_ascend")
            case .descend: return String(localized: "toDoList_sort_descend")
            case .basic: return String(localized: "toDoList_sort_basic")
            }
        }
    }
    
    func setSortMode(_ sortMode: ToDoManager.SortMode) {
        self.sortMode = sortMode
    }
    
    private func sortToDosByStartingTimeAscend(_ todos: [ToDo]) -> [ToDo] {
        todos.sorted {
            guard let firstDate = $0.startingTime, let secondDate = $1.startingTime else {
                return $0.createdAt < $1.createdAt
            }
            return firstDate < secondDate
        }
    }
    
    private func sortToDosByStartingTimeDescend(_ todos: [ToDo]) -> [ToDo] {
        todos.sorted {
            guard let firstDate = $0.startingTime, let secondDate = $1.startingTime else {
                return $0.createdAt > $1.createdAt
            }
            return firstDate > secondDate
        }
    }
    
    private func sortToDosByCreatedAt(_ todos: [ToDo]) -> [ToDo] {
       todos.sorted { $0.createdAt < $1.createdAt }
    }
    
}
