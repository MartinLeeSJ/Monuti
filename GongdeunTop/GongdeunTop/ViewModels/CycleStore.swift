//
//  CycleStore.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/27.
//

import Foundation
import Combine

import FirebaseAuth
import FirebaseFirestore

final class CycleStore: ObservableObject {
    @Published var cycles: [Cycle] = [] {
        didSet {
            orderCyclesByDate()
        }
    }
    @Published var cyclesOrderedByDate = [Date : [Cycle]]()
    
    private let database = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    func resetAndSubscribe(_ date: Date) {
        unsubscribeCycles()
        subscribeCycles(date)
    }
   
    
    func unsubscribeCycles() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    
    func subscribeCycles(_ startingPoint: Date) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        if listenerRegistration == nil {
            let dateInterval = Calendar.current.dateInterval(of: .month, for: startingPoint)
            
            let startDate: Date = dateInterval?.start ?? Date()
            let endDate: Date = dateInterval?.end ?? Date()
            
            let query = database.collection("Members")
                .document(uid)
                .collection("Cycle")
                .whereField("createdAt", isGreaterThanOrEqualTo: Timestamp(date: startDate))
                .whereField("createdAt", isLessThan: Timestamp(date: endDate))
            
            listenerRegistration = query.addSnapshotListener { [weak self] (snapshot, error) in
                guard let self = self, let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error!.localizedDescription)")
                    return
                }
                
                self.cycles = documents.compactMap { try? $0.data(as: Cycle.self) }
            }
        }
    }
    
    
    private func orderCyclesByDate() {
        resetDict()
        
        for cycle in cycles {
            let date: Date =  cycle.createdAt.dateValue()
            
            guard let dateStart = Calendar.current.dateInterval(of: .day, for: date)?.start else {
                continue
            }
            
            if cyclesOrderedByDate[dateStart] == nil {
                cyclesOrderedByDate[dateStart] = []
            }
                
            cyclesOrderedByDate[dateStart]?.append(cycle)
        }
    }
    
    private func resetDict() {
        cyclesOrderedByDate = [Date : [Cycle]]()
    }
}
