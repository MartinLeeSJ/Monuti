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
    @Published var cyclesOrderedByDate = [Date : [Cycle]]() {
        didSet {
            evaluateDate()
        }
    }
    @Published var dateEvaluations = [Date : Int]()
    
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
            
            print("startDate : \(startDate)")
            print("endDate : \(endDate)")
            
            
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
    
    private func evaluateDate() {
        for (date , cycles) in cyclesOrderedByDate {
            var value: Int = 0
            var todoCount: Int = 0
            for cycle in cycles {
                var cycleTodos: Int = (cycle.todos.count == 0 ? 1: cycle.todos.count)
                value += cycle.evaluation * cycleTodos
                todoCount += cycleTodos
            }
            
            guard todoCount != 0 else { continue }
            
            
            dateEvaluations[date] = averageAndRoundUp(total: value, count: todoCount)
        }
    }
    
    private func averageAndRoundUp(total: Int, count: Int) -> Int {
        return Int(Double(total / count).rounded())
    }
    
    private func resetDict() {
        cyclesOrderedByDate = [Date : [Cycle]]()
    }
}
