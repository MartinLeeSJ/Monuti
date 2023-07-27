//
//  TagStore.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/05.
//

import Foundation

import FirebaseAuth
import FirebaseFirestore


final class TagStore: ObservableObject {
    
    private var listenerRegistration: ListenerRegistration?
    
    private let database = Firestore.firestore()
    
    @Published var tags: [Tag] = []
    
    func unsubscribeTags() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    
    func subscribeTags() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        if listenerRegistration == nil {
      
            listenerRegistration = database.collection("Members").document(uid).collection("Tag").addSnapshotListener { [weak self] (snapshot, error) in
                guard let self = self, let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "unknown")")
                    return
                }
                
                self.tags = documents.compactMap{ queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Tag.self)
                }
            }
        }
    }
    
    
}
