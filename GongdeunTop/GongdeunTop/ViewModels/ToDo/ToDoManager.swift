//
//  ToDoManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/20.
//

import Foundation
import Combine

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

final class ToDoManager: ObservableObject {
    @Published var todo: ToDo
    @Published var modified: Bool = false
    
    
    private let database = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    @MainActor
    init(todo: ToDo = .init(title: "", content: "", tags: [], timeSpent: 0, isCompleted: false, createdAt: Date.now )) {
        self.todo = todo
        self.$todo
            .dropFirst()
            .sink { [weak self] todo in
                self?.modified = true
            }
            .store(in: &self.cancellables)
    }
    
    private func reset() {
        self.todo = ToDo(createdAt: Date.now)
        self.modified = false
    }
    
    @MainActor
    private func addToDo(_ todo: ToDo) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if todo.id == nil {
            do {
                let documentRef = try database.collection("Members")
                    .document(uid)
                    .collection("ToDo")
                    .addDocument(from: todo)
                let documentId = documentRef.documentID
                
                await registerTodoInTarget(todoId: documentId, targetId: todo.relatedTarget)
                
                reset()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateToDo(_ todo: ToDo) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let id = todo.id else { return }
        
        do {
            try database.collection("Members").document(uid).collection("ToDo").document(id)
                .setData(from: self.todo)
            
            await registerTodoInTarget(todoId: id, targetId: todo.relatedTarget)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func removeToDo() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let id = todo.id else { return }
        
        do {
            try await database.collection("Members").document(uid).collection("ToDo").document(id).delete()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    private func addOrUpdateToDo() {
        Task {
            if let _ = self.todo.id {
                await updateToDo(self.todo)
            } else {
                self.todo.createdAt = Date.now
                await addToDo(self.todo)
            }
        }
    }
    
    // MARK: - Update Todo relatedTarget
    
    func manageRelatedTarget(ofId targetId: String?) {
        guard let newTargetId = targetId else { return }
        if let oldTargetId = self.todo.relatedTarget, oldTargetId == newTargetId {
            self.todo.relatedTarget = nil
        } else {
            self.todo.relatedTarget = newTargetId
        }
    }

    private func registerTodoInTarget(todoId: String, targetId: String?) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let targetId else { return }
        let batch = database.batch()
        let ref = database
            .collection("Members")
            .document(uid)
            .collection("Target")
            .document(targetId)
        
        batch.updateData(["todos": FieldValue.arrayUnion([todoId]) ], forDocument: ref)
        
        do {
            try await batch.commit()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    func deleteRelatedTarget(ofId targetId: String?) async {
        guard let todoId = todo.id else { return }
        guard let targetId else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let batch = database.batch()
        let ref = database
            .collection("Members")
            .document(uid)
            .collection("Target")
            .document(targetId)
        
        batch.updateData(["todos": FieldValue.arrayRemove([todoId]) ], forDocument: ref)
        do {
            try await batch.commit()
            self.todo.relatedTarget = nil
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - TextField Limit
    func setTitleCharacterCountBelow(limit: Int) {
        if limit < todo.title.count {
            todo.title = String(todo.title.prefix(limit))
        }
    }
    
    func setContentCharacterCountBelow(limit: Int) {
        if limit < todo.content.count {
            todo.content = String(todo.content.prefix(limit))
        }
    }
    
    //MARK: - UI Handler
    
    func handleDoneTapped() {
        addOrUpdateToDo()
    }
    
    func handleDeleteTapped() {
        Task {
           await removeToDo()
        }
    }

}
