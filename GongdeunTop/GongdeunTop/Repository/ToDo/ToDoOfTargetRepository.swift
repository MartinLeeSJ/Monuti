//
//  ToDoOfTargetRepository.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/31.
//

import Foundation
import Combine

import Factory

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

public class ToDoOfTargetRepository: ObservableObject {
    @Injected(\.authService) var authService
    @Injected(\.firestore) var database
    @Published var todos = [ToDo]()
    @Published var user: User? = nil
    private let target: Target
    
    private var cancelables = Set<AnyCancellable>()
    private var listenerRegistration: ListenerRegistration?
    
    init(target: Target) {
        self.target = target
        
        authService
            .$user
            .assign(to: &$user)
        
        $user
            .sink { [weak self] user in
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
        
        
        let query = database.collection("Members")
            .document(uid)
            .collection("ToDo")
            .whereField("relatedTarget", isEqualTo: target.id ?? "")
        
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
