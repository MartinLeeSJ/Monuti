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
                .whereField("startDate", isLessThanOrEqualTo: Timestamp(date: Date.now))
                .whereField("dueDate", isGreaterThanOrEqualTo: Timestamp(date: Date.now))
            
            listenerRegistration = query.addSnapshotListener{ [weak self] (snapshot, error) in
                guard let self = self, let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "unknown")")
                    return
                }
                
                self.targets = documents.compactMap{ queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Target.self)
                }
            }
        }
    }
}
