//
//  ToDoRepository.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/26.
//

import Foundation
import Combine

import Factory

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift



public class ToDoRepository: ObservableObject, FirebaseListener {
    @Injected(\.authService) var authService
    @Injected(\.firestore) var database
    @Published var todos = [ToDo]()
    @Published var user: User? = nil
    
    private var cancelables = Set<AnyCancellable>()
    private var listenerRegistration: ListenerRegistration?
    
    init() {
        authService
            .$user
            .assign(to: &$user)
        
        $user.sink { [weak self] user in
            self?.unsubscribe()
            self?.subscribe(user: user)
        }
        .store(in: &cancelables)
    }
    
    deinit {
        unsubscribe()
    }
    
    func unsubscribe() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    func subscribe(user: User?) {
        guard let uid = user?.uid else { return }
        guard listenerRegistration == nil else { return }
        
        let calendar = Calendar.current
        let dateInterval = calendar.dateInterval(of: .day, for: Date())
        let startTime = dateInterval?.start ?? Date()
        let endTime = calendar.date(byAdding: .day, value: 1, to: dateInterval?.end ?? Date()) ?? Date()

        let query = database.collection("Members")
            .document(uid)
            .collection("ToDo")
            .whereField("startingTime", isGreaterThanOrEqualTo: Timestamp(date: startTime))
            .whereField("startingTime", isLessThan: Timestamp(date: endTime))
            .whereField("isCompleted", isEqualTo: false)
        
        listenerRegistration = query.addSnapshotListener { [weak self] (snapshot, error) in
            guard let self = self, let documents = snapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "unknown")")
                return
            }
            
            self.todos = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: ToDo.self)
            }
        }
    }
}


//MARK: - CRUD
extension ToDoRepository {
    func add(_ todo: ToDo) async throws {
        guard let uid = user?.uid else { return }
        guard todo.id == nil else { return }
        
        let documentRef = try database.collection("Members")
            .document(uid)
            .collection("ToDo")
            .addDocument(from: todo)
        
        let documentId = documentRef.documentID
        var mutableTodo = todo
        mutableTodo.id = documentId
        
        try await addTarget(in: mutableTodo)
    }
    
    func update(_ todo: ToDo) async throws {
        guard let uid = user?.uid else { return }
        guard let id = todo.id else { return }
        
        try database
            .collection("Members")
            .document(uid)
            .collection("ToDo")
            .document(id)
            .setData(from: todo)
        
        try await addTarget(in: todo)
    }
    
    func updateCompletion(todos: [ToDo]) async throws {
        guard let uid = user?.uid else { return }
        
        let batch = database.batch()
        let membersRef = database
            .collection("Members")
            .document(uid)
       
        for todo in todos {
            guard let id = todo.id else { continue }
            
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
        
        try await batch.commit()
    }
    
    func updateExpiringDate(todos: [ToDo]) async throws {
        guard let uid = user?.uid else { return }
        
        let batch = database.batch()
        let calendar = Calendar.current
        
        for todo in todos {
            guard let startingTime = todo.startingTime else { continue }
            guard calendar.isDateInToday(startingTime) else { continue }
            guard let updatedCreatedAt = calendar.date(byAdding: .day, value: 1, to: startingTime) else { continue }
            if let id = todo.id {
                batch.updateData(["startingTime": updatedCreatedAt],
                                 forDocument:  database
                    .collection("Members")
                    .document(uid)
                    .collection("ToDo")
                    .document(id))
            }
        }
        
        try await batch.commit()
    }
    
    
    
    func remove(_ todo: ToDo) async throws {
        guard let uid = user?.uid else { return }
        guard let id = todo.id else { return }
        
        try await database
            .collection("Members")
            .document(uid)
            .collection("ToDo")
            .document(id)
            .delete()
        try await removeTarget(of: todo)
    }
    
    func removeToDos(_ todos: [ToDo]) async throws {
        guard let uid = user?.uid else { return }
        let batch = database.batch()
        
        for todo in todos {
            guard let id = todo.id else { continue }
            
            batch.deleteDocument(
                database
                    .collection("Members")
                    .document(uid)
                    .collection("ToDo")
                    .document(id)
            )
            
            for tag in todo.tags {
                batch.updateData(["count": FieldValue.increment(Int64(-1))], forDocument: database
                    .collection("Members")
                    .document(uid)
                    .collection("Tag")
                    .document(tag)
                )
            }
            
            try await removeTarget(of: todo)
        }
        
        try await batch.commit()
    }
}

// MARK: - Manage Related Target

extension ToDoRepository {
    private func addTarget(in todo: ToDo) async throws {
        guard let uid = user?.uid else { return }
        guard let todoId = todo.id else { return }
        guard let targetId = todo.relatedTarget else { return }
        
        let batch = database.batch()
        let ref = database
            .collection("Members")
            .document(uid)
            .collection("Target")
            .document(targetId)
        
        batch.updateData(["todos": FieldValue.arrayUnion([todoId]) ], forDocument: ref)
        
        try await batch.commit()
    }
    
    func removeTarget(of todo: ToDo) async throws {
        guard let todoId = todo.id else { return }
        guard let targetId = todo.relatedTarget else { return }
        guard let uid = user?.uid else { return }
        let batch = database.batch()
        let ref = database
            .collection("Members")
            .document(uid)
            .collection("Target")
            .document(targetId)

        batch.updateData(["todos": FieldValue.arrayRemove([todoId]) ], forDocument: ref)
        
        try await batch.commit()
    }
}
