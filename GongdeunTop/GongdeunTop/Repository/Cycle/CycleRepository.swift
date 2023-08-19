//
//  CycleRepository.swift
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

public class CycleRepository: ObservableObject {
    @Injected(\.authService) var authService
    @Injected(\.firestore) var database
    @Published var cycles = [Cycle]()
    @Published var baseDate = Date.now
    @Published var user: User? = nil
    
    private var cancelables = Set<AnyCancellable>()
    private var listenerRegistration: ListenerRegistration?
    
    init() {
        authService
            .$user
            .assign(to: &$user)
        
        $user
            .combineLatest($baseDate)
            .sink { [weak self] (user, date) in
            print("Combine is working!")
            self?.unsubscribe()
            self?.subscribe(user: user, baseDate: date)
        }
        .store(in: &cancelables)
    }
    
    deinit {
        unsubscribe()
    }
    
    func setBaseDate(_ date: Date) {
        baseDate = date
    }
    
    func unsubscribe() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    func subscribe(user: User?, baseDate: Date = Date.now) {
        guard let uid = user?.uid else { return }
        
        guard listenerRegistration == nil else { return }
        
        let dateInterval = Calendar.current.dateInterval(of: .month, for: baseDate)
        
        let startDate: Date = dateInterval?.start ?? Date()
        let endDate: Date = dateInterval?.end ?? Date()
        
        let query = database.collection("Members")
            .document(uid)
            .collection("Cycle")
            .whereField("createdAt", isGreaterThanOrEqualTo: Timestamp(date: startDate))
            .whereField("createdAt", isLessThan: Timestamp(date: endDate))
        
        listenerRegistration = query.addSnapshotListener { [weak self] (snapshot, error) in
            guard let self = self, let documents = snapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "unknown")")
                return
            }
            
            self.cycles = documents.compactMap { try? $0.data(as: Cycle.self) }
        }
    }
}
