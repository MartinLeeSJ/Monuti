//
//  CycleManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/17.
//

import Foundation
import Combine

import FirebaseAuth
import FirebaseFirestore

final class CycleManager: ObservableObject {
    @Published var cycle: Cycle
    @Published var todos: [ToDo] = []
    @Published var modified: Bool = false
    
    private let database = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    init(cycle: Cycle = Cycle(createdAt: Timestamp(date: Date()), todos: [], evaluation: 0, memoirs: "", sessions: 0, minutes: 0),
         todos: [ToDo] = []) {
        self.cycle = cycle
        self.todos = todos
        self.$cycle
            .dropFirst()
            .sink { [weak self] cycle in
                self?.modified = true
            }
            .store(in: &self.cancellables)
    }
    
    private func addCycle() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        if cycle.id == nil {
            do {
                try database
                    .collection("Members")
                    .document(uid)
                    .collection("Cycle")
                    .addDocument(from: self.cycle)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateCycle() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let id = cycle.id else { return }
        
        do {
            try database
                .collection("Members")
                .document(uid)
                .collection("Cycle")
                .document(id)
                .setData(from: self.cycle)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    private func removeCycle() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let id = cycle.id else { return }
        
        do {
            try await database
                .collection("Members")
                .document(uid)
                .collection("Cycle")
                .document(id)
                .delete()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func handleFinishButton() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.addToDoIdInCycle()
        
        let batch = database.batch()
        
        for todo in todos {
            if let id = todo.id {
                let ref = database
                    .collection("Members")
                    .document(uid)
                    .collection("ToDo")
                    .document(id)
                
                
                batch.updateData(["timeSpent": todo.timeSpent,
                                  "isCompleted": todo.isCompleted
                                 ], forDocument: ref)
            }
        }
        
        batch.commit() { err in
            if let err {
                print(err.localizedDescription)
            } else {
                self.addCycle()
            }
        }
        
    }
    
    private func addToDoIdInCycle() {
        self.cycle.todos = todos.compactMap { $0.id }
    }
    
    func fetchToDos() {
        guard !cycle.todos.isEmpty else { return }
        guard !cycle.todos.contains("") else { return }
        guard cycle.id != nil else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = database.collection("Members")
            .document(uid)
            .collection("ToDo")
            .whereField(FieldPath.documentID(), in: cycle.todos)
        
        query.getDocuments { [weak self] (snapshot, error) in
            guard let self = self, let documents = snapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "unknown")")
                return
            }
            
            self.todos = documents.compactMap { try? $0.data(as: ToDo.self) }
        }
        
        print(todos)
    }
}
