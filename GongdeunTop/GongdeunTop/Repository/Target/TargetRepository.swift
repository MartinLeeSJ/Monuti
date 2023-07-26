//
//  TargetRepository.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/26.
//

import Foundation
import Combine

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol FirebaseListener {
    func subscribe(user: User?)
    func unsubscribe()
}

final class TargetRepository: ObservableObject, FirebaseListener {
    @Published var targets = [Target]()
    @Published var user: User? = nil
    private var listenerRegistration: ListenerRegistration?
    private var cancelables = Set<AnyCancellable>()
    private let database = Firestore.firestore()
    
    init() {
        
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
