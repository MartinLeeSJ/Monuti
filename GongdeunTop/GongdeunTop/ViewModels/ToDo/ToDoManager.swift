//
//  ToDoManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/20.
//

import Foundation
import Combine

import FirebaseFirestore
import FirebaseAuth

final class ToDoManager: ObservableObject {
    @Published var todo: ToDo
    @Published var modified: Bool = false

    
    private let database = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
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
    
    private func addToDo(_ todo: ToDo) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if todo.id == nil {
            do {
                try database.collection("Members")
                    .document(uid)
                    .collection("ToDo")
                    .addDocument(from: todo)
                reset()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateToDo(_ todo: ToDo) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let id = todo.id else { return }
        
        do {
            try database.collection("Members").document(uid).collection("ToDo").document(id)
                .setData(from: self.todo)
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
        if let _ = self.todo.id {
            updateToDo(self.todo)
        } else {
            self.todo.createdAt = Date.now
            addToDo(self.todo)
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
