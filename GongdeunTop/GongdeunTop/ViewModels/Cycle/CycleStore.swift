//
//  CycleStore.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/27.
//

import Foundation
import Combine

import Factory

import FirebaseAuth
import FirebaseFirestore

final class CycleStore: ObservableObject {
    @Injected(\.cycleRepository) var cycleRepository
    @Injected(\.firestore) var database
    @Published var cycles: [Cycle] = []
    @Published var cyclesDictionary = [Date : [Cycle]]()
    @Published var dateEvaluations = [Date : Int]()
    
    private var listenerRegistration: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    init() {
        cycleRepository
            .$cycles
            .assign(to: &$cycles)
        
        $cycles
            .removeDuplicates()
            .map { [weak self] cycles in
                self?.orderCyclesByDate(cycles: cycles) ?? [Date : [Cycle]]()
            }
            .assign(to: &$cyclesDictionary)
        
        $cyclesDictionary
            .removeDuplicates()
            .map { [weak self] dictionary in
                self?.evaluateDate(dictionary: dictionary) ?? [Date: Int]()
            }
            .assign(to: &$dateEvaluations)
        
    }
    
    func setBaseDate(_ date: Date) {
        cycleRepository.setBaseDate(date)
    }

    private func orderCyclesByDate(cycles: [Cycle]) -> [Date : [Cycle]] {
        var dictionary = [Date : [Cycle]]()
        
        for cycle in cycles {
            let date: Date =  cycle.createdAt.dateValue()
            
            guard let dateStart = Calendar.current.dateInterval(of: .day, for: date)?.start else {
                continue
            }
            if dictionary[dateStart] == nil {
                dictionary[dateStart] = []
            }
            dictionary[dateStart]?.append(cycle)
        }
        
        return dictionary
    }
    
    private func evaluateDate(dictionary: [Date : [Cycle]]) -> [Date : Int] {
        var result = [Date: Int]()
        for (date , cycles) in dictionary {
            var value: Int = 0
            var todoCount: Int = 0
            for cycle in cycles {
                let cycleTodos: Int = (cycle.todos.count == 0 ? 1: cycle.todos.count)
                value += cycle.evaluation * cycleTodos
                todoCount += cycleTodos
            }
            
            guard todoCount != 0 else { continue }
            
            
            result[date] = averageAndRoundUp(total: value, count: todoCount)
        }
        return result
    }
    
    private func averageAndRoundUp(total: Int, count: Int) -> Int {
        return Int(Double(total / count).rounded())
    }
    
    private func resetDict() {
        cyclesDictionary = [Date : [Cycle]]()
    }
}
