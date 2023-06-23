//
//  ToDosViewModel.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/02.
//

import Foundation
import Combine


import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

final class ToDoStore: ObservableObject {    
    private var listenerRegistration: ListenerRegistration?
    private let database = Firestore.firestore()
    
    @Published var todos: [ToDo] = []
    @Published var isEditing: Bool = false
    @Published var multiSelection = Set<String?>()
    @Published var sortMode: SortMode = .basic
    
    func unsubscribeTodos() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    func subscribeTodos() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        if listenerRegistration == nil {
            
            let calendar = Calendar.current
            let dateInterval = calendar.dateInterval(of: .day, for: Date())
            let startTime = dateInterval?.start ?? Date()
            let endTime = calendar.date(byAdding: .day, value: 1, to: dateInterval?.end ?? Date())!
            
            let query = database.collection("Members")
                .document(uid)
                .collection("ToDo")
                .whereField("createdAt", isGreaterThanOrEqualTo: Timestamp(date: startTime))
                .whereField("createdAt", isLessThan: Timestamp(date: endTime))
                .whereField("isCompleted", isEqualTo: false)
            
            
            listenerRegistration = query.addSnapshotListener { [weak self] (snapshot, error) in
                guard let self = self, let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "unknown")")
                    return
                }
                
                self.todos = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: ToDo.self)
                }
                
                print(todos)
                
                sortTodos(as: self.sortMode)
            }
        }
    }
}


// MARK: - Sorting
extension ToDoStore {
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
    
    func sortTodos(as mode: ToDoStore.SortMode) {
        self.sortMode = mode
        
        switch mode {
        case .ascend: sortToDosByStartingTimeAscend()
        case .basic: sortToDosByStartingTimeDescend()
        case .descend: sortToDosByCreatedAt()
        }
    }
    
    private func sortToDosByStartingTimeAscend() {
        self.todos.sort {
            guard let firstDate = $0.startingTime, let secondDate = $1.startingTime else {
                return $0.createdAt < $1.createdAt
            }
            return firstDate < secondDate
        }
    }
    
    private func sortToDosByStartingTimeDescend() {
        self.todos.sort {
            guard let firstDate = $0.startingTime, let secondDate = $1.startingTime else {
                return $0.createdAt > $1.createdAt
            }
            return firstDate > secondDate
        }
    }
    
    private func sortToDosByCreatedAt() {
        self.todos.sort { $0.createdAt < $1.createdAt }
    }
    
}

// MARK: - Multiple Deletion and Completion
extension ToDoStore {
    
    func deleteTodos() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard !multiSelection.isEmpty else { return }
        
        let batch = database.batch()
        
        let filteredTodo: [ToDo] = self.todos.filter {
            multiSelection.contains($0.id)
        }
        
        for todo in filteredTodo {
            for tag in todo.tags {
                batch.updateData(["count": FieldValue.increment(Int64(-1))], forDocument: database
                    .collection("Members")
                    .document(uid)
                    .collection("Tag")
                    .document(tag)
                )
            }
        }
        
        for id in multiSelection {
            if let id {
                batch.deleteDocument(
                    database
                        .collection("Members")
                        .document(uid)
                        .collection("ToDo")
                        .document(id)
                )
            }
        }
        
        batch.commit() { err in
            if let err {
                print(err.localizedDescription)
            }
        }
    }
    
    func completeTodos() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard !multiSelection.isEmpty else { return }
        
        let membersRef = database
            .collection("Members")
            .document(uid)
        let batch = database.batch()
       
        for id in multiSelection {
            guard let id else { continue }
            guard let todo = todos.filter({ $0.id == id }).first else { continue }
            
            batch.updateData(["isCompleted": true],
                             forDocument:  membersRef
                .collection("ToDo")
                .document(id))
            
            guard let targetId = todo.relatedTarget else { continue }
            
            batch.updateData(["achievement": FieldValue.increment(Int64(1))],
                             forDocument: membersRef
                .collection("Target")
                .document(targetId)
            )
        }
        
        batch.commit() { err in
            if let err {
                print(err.localizedDescription)
            }
        }
    }
    
    func extendLifeOfTodos() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let batch = database.batch()
        let calendar = Calendar.current
        
        for todo in todos {
            guard calendar.isDateInToday(todo.createdAt) else { continue }
            guard let updatedCreatedAt = calendar.date(byAdding: .day, value: 1, to: todo.createdAt) else { continue }
            if let id = todo.id {
                batch.updateData(["createdAt": updatedCreatedAt],
                                 forDocument:  database
                    .collection("Members")
                    .document(uid)
                    .collection("ToDo")
                    .document(id))
            }
        }
        
        batch.commit() { err in
            if let err {
                print(err.localizedDescription)
            }
        }
    }
}
