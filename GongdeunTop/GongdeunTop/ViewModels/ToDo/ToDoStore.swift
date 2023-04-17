//
//  ToDosViewModel.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/02.
//

import Foundation
import Combine


import FirebaseFirestore
import FirebaseAuth

final class ToDoStore: ObservableObject {
    private var listenerRegistration: ListenerRegistration?
    
    private let database = Firestore.firestore()
    
    @Published var todos: [ToDo] = []
    @Published var isEditing: Bool = false
    @Published var multiSelection = Set<String?>()
    
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
            //Get the current date and time
            let now = Date()
            
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: now)
            
            let startTimestamp = Timestamp(date: calendar.date(byAdding: .day, value: -1, to: calendar.date(from: dateComponents)!)!)
            let endTimestamp = Timestamp(date: calendar.date(byAdding: .day, value: 1, to: calendar.date(from: dateComponents)!)!)
            
            
            let query = database.collection("Members")
                .document(uid)
                .collection("ToDo")
                .whereField("createdAt", isGreaterThanOrEqualTo: startTimestamp)
                .whereField("createdAt", isLessThan: endTimestamp)
                .whereField("isCompleted", isEqualTo: false)
            
            
            
            
            listenerRegistration = query.addSnapshotListener { [weak self] (snapshot, error) in
                guard let self = self, let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error!.localizedDescription)")
                    return
                }
                
                self.todos = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: ToDo.self)
                }
            }
        }
    }
    
    
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
        
        let batch = database.batch()
        
        for id in multiSelection {
            if let id {
                batch.updateData(["isCompleted": true],
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