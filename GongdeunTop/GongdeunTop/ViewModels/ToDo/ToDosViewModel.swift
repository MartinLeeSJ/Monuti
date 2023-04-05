//
//  ToDosViewModel.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/02.
//

import Foundation
import Combine


import FirebaseFirestore
import FirebaseAuth

final class ToDosViewModel: ObservableObject {
    private var listenerRegistration: ListenerRegistration?
    
    private var currentUser: User? = Auth.auth().currentUser
    
    private let database = Firestore.firestore()
    
    @Published var todos: [ToDo] = []
    
    func unsubscribeTodos() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    func subscribeTodos() {
        guard let currentUser else {
            return
        }
        if listenerRegistration == nil {
            //Get the current date and time
            let now = Date()
            
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: now)
            
            let startTimestamp = Timestamp(date: calendar.date(from: dateComponents)!)
            let endTimestamp = Timestamp(date: calendar.date(byAdding: .day, value: 1, to: calendar.date(from: dateComponents)!)!)
            
            
            let query = database.collection("Member")
                .document(currentUser.uid)
                .collection("ToDo")
                .whereField("createdAt", isGreaterThanOrEqualTo: startTimestamp)
                .whereField("createdAt", isLessThan: endTimestamp)
            
            
            listenerRegistration = query.addSnapshotListener { [weak self] (snapshot, error) in
                guard let self = self, let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error!.localizedDescription)")
                    return
                }
                
                self.todos = documents.compactMap{ queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: ToDo.self)
                }
            }
        }
    }
    
    
}
