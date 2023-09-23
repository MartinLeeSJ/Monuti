//
//  CycleManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/17.
//

import Foundation
import Combine

import Factory

import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class CycleManager: ObservableObject {
    @Injected(\.firestore) var database
    @Published var cycle: Cycle
    @Published var todos: [ToDo] = []
    @Published var modified: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        cycle: Cycle = Cycle(
            createdAt: Timestamp(date: Date.now),
            todos: [],
            evaluation: 0,
            memoirs: ""
        ),
        todos: [ToDo] = []
    ) {
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
    
    
    public func handleUpdateButton(){
        self.updateCycle()
    }
    
    
    public func handleFinishedCycleButton() {
        Task {
            self.addToDoIdInCycle()
            await updateToDos()
            await updateTargetAchievements()
            self.addCycle()
        }
    }
    
    public func evaluateCycle(_ evaluation: Int) {
        self.cycle.evaluation = evaluation
    }
    
    public func toggleToDoCompletion(of index: Int) {
        guard !todos.isEmpty else { return }
        guard (0..<todos.count).contains(index) else { return }
        
        todos[index].isCompleted.toggle()
    }
    
    private func addToDoIdInCycle() {
        self.cycle.todos = todos.compactMap { $0.id }
    }
    
    private func updateToDos() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let batch = database.batch()
        
        for todo in todos {
            guard let id = todo.id else { continue }
            
            let todoRef = database
                .collection("Members")
                .document(uid)
                .collection("ToDo")
                .document(id)
            
            batch.updateData(["timeSpent": todo.timeSpent,
                              "isCompleted": todo.isCompleted
                             ], forDocument: todoRef)
        }
        
        do {
           try await batch.commit()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func updateTargetAchievements() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let batch = database.batch()
        
        for todo in todos {
            guard let targetId = todo.relatedTarget else { continue }
            guard todo.isCompleted else { continue }
            
            let targetRef = database
                .collection("Members")
                .document(uid)
                .collection("Target")
                .document(targetId)
            
            batch.updateData(["achievement": FieldValue.increment(Int64(1))],
                             forDocument: targetRef)
        }
        
        do {
           try await batch.commit()
        } catch {
            print(error.localizedDescription)
        }
    }
    
   
    
    public func fetchToDos() {
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
            
            self.todos = documents.compactMap {
                try? $0.data(as: ToDo.self)
            }
            print(todos)
        }
    }
}
