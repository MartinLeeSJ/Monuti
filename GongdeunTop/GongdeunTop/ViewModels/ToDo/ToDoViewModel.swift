//
//  ToDoViewModel.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/20.
//

import Foundation
import Combine

import FirebaseFirestore
import FirebaseAuth

final class ToDoViewModel: ObservableObject {
    @Published var todo: ToDo
    @Published var tag: String = ""
    @Published var modified: Bool = false

    
    private let database = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    init(todo: ToDo = .init(title: "", content: "", tags: [], timeSpent: 0, isCompleted: false, createdAt: Timestamp(date: Date()) )) {
        self.todo = todo
        self.$todo
            .dropFirst()
            .sink { [weak self] todo in
                self?.modified = true
            }
            .store(in: &self.cancellables)
    }
    
    private func addToDo(_ todo: ToDo) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if todo.id == nil {
            do {
                try database.collection("Member").document(uid).collection("ToDo")
                    .addDocument(from: self.todo)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateToDo(_ todo: ToDo) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let id = todo.id else { return }
        
        do {
            try database.collection("Member").document(uid).collection("ToDo").document(id)
                .setData(from: self.todo)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func removeToDo() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let id = todo.id else { return }
        
        do {
            try await database.collection("Member").document(uid).collection("ToDo").document(id).delete()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    private func addOrUpdateToDo() {
        if let _ = self.todo.id {
            updateToDo(self.todo)
        } else {
            addToDo(self.todo)
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
