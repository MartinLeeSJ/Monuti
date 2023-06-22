//
//  TargetStore.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/15.
//

import Foundation

import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

final class TargetStore: ObservableObject {
    @Published var targets: [Target] = []
    @Published var isEditing: Bool = false
    @Published var multiSelection = Set<String?>()
    
    private var listenerRegistration: ListenerRegistration?
    private let database = Firestore.firestore()
    
    func unsubscribeTargets() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    func subscribeTargets() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
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
    
    func deleteTargets() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard !multiSelection.isEmpty else { return }
        let memberRef = database.collection("Members").document(uid)
        let batch = database.batch()
        let filteredTarget: [Target] = self.targets.filter {
            multiSelection.contains($0.id)
        }
        
        for target in filteredTarget {
            for todo in target.todos {
                batch.updateData(["relatedTarget" : nil ?? ""],
                                 forDocument: memberRef.collection("ToDo").document(todo))
            }
        }
        
        for id in multiSelection {
            guard let id else { continue }
            
            batch.deleteDocument(memberRef
                .collection("Target")
                .document(id)
            )
        }
        
        batch.commit() { err in
            if let err {
                print(err.localizedDescription)
            }
        }
    }
    
 
}
