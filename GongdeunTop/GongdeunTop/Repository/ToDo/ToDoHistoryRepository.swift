//
//  ToDoHistoryRepository.swift
//  GongdeunTop
//
//  Created by Martin on 2023/09/20.
//

import Foundation
import Combine

import Factory

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

public class ToDoHistoryRepository: ObservableObject {
    @Injected(\.authService) var authService
    @Injected(\.firestore) var database
    @Published var todos = [ToDo]()
    @Published var user: User? = nil
    @Published var date: Date = Date.now
    
    private var cancelables = Set<AnyCancellable>()
    private var listenerRegistration: ListenerRegistration?
    private let cache = NSCache<NSDate, NSArray>()
    
    init() {
        authService
            .$user
            .assign(to: &$user)
        
        $user
            .combineLatest($date)
            .sink { [weak self] (user, date) in
                self?.unsubscribe()
                self?.subscribe(user: user, date: date)
            }
            .store(in: &cancelables)
    }
    
    deinit {
        unsubscribe()
    }
    
    func setDate(_ date: Date) {
        self.date = date
    }
    
    func unsubscribe() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    func subscribe(user: User?, date: Date) {
        guard let uid = user?.uid else { return }
        guard listenerRegistration == nil else { return }

        let calendar = Calendar.current
        let startTime = calendar.startOfDay(for: date)
        let endTime = calendar.date(byAdding: .day, value: 1, to: startTime)!
        
        if let todos = cache.object(forKey: startTime as NSDate) as? [ToDo],
           !calendar.isDateInToday(date) {
            self.todos = todos
            return
        }
        
        let query = database.collection("Members")
            .document(uid)
            .collection("ToDo")
            .whereField("startingTime", isGreaterThanOrEqualTo: Timestamp(date: startTime))
            .whereField("startingTime", isLessThan: Timestamp(date: endTime))
        
        
        listenerRegistration = query.addSnapshotListener { [weak self] (snapshot, error) in
            guard let self = self, let documents = snapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "unknown")")
                return
            }
            let todos = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: ToDo.self)
            }
            self.todos = todos
            cache.setObject(todos as NSArray, forKey: startTime as NSDate)
        }
    }
}
