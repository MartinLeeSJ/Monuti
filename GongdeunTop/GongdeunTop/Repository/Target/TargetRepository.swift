//
//  TargetRepository.swift
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

protocol FirebaseListener {
    func subscribe(user: User?)
    func unsubscribe()
}

public class TargetRepository: ObservableObject, FirebaseListener {
    @Injected(\.firestore) var database
    @Injected(\.authService) var authService
    
    @Published var targets = [Target]()
    @Published var user: User? = nil
    
    private var listenerRegistration: ListenerRegistration?
    private var cancelables = Set<AnyCancellable>()
    
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
        
        if listenerRegistration == nil {
            let query = database.collection("Members")
                .document(uid)
                .collection("Target")
                .whereField("dueDate", isGreaterThanOrEqualTo: Timestamp(date: Date.now))
            
            listenerRegistration = query.addSnapshotListener{ [weak self] (snapshot, error) in
                guard let self = self, let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "unknown")")
                    return
                }
                
                self.targets = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Target.self)
                }
            }
        }
    }
}

// MARK: - CRUD
extension TargetRepository {
    func addTarget(_ target: Target) throws {
        guard let uid = user?.uid else { return }
        guard target.id == nil else { return }
        
        try database.collection("Members")
            .document(uid)
            .collection("Target")
            .addDocument(from: target)
    }
    
    func updateTarget(_ target: Target) throws {
        guard let uid = user?.uid else { return }
        guard let id = target.id else { return }
        
        try database
            .collection("Members")
            .document(uid)
            .collection("Target")
            .document(id)
            .setData(from: target)
    }
    
    func removeTarget(_ target: Target) async throws {
        guard let uid = user?.uid else { return }
        guard let id = target.id else { return }
        let memberRef = database.collection("Members").document(uid)
        let batch = database.batch()
        
        for todo in target.todos {
            batch.updateData(["relatedTarget" : nil ?? ""],
                             forDocument: memberRef.collection("ToDo").document(todo))
        }
        
        batch.deleteDocument(memberRef.collection("Target").document(id))
        
        try await batch.commit()
    }
    
    func removeTargets(filteredTarget targets: [Target]) async throws {
        guard let uid = user?.uid else { return }
        let memberRef = database.collection("Members").document(uid)
        let batch = database.batch()
        
        for target in targets {
            guard let id = target.id else { continue }
            
            batch.deleteDocument(memberRef
                .collection("Target")
                .document(id)
            )
            
            for todo in target.todos {
                batch.updateData(["relatedTarget" : nil ?? ""],
                                 forDocument: memberRef.collection("ToDo").document(todo))
            }
        }
        
        try await batch.commit()
    }
}
