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
    @Published var cyclesOfDate = [Date : [Cycle]]()
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
            .assign(to: &$cyclesOfDate)
        
        $cyclesOfDate
            .subscribe(on: DispatchQueue.main)
            .delay(for: 0.5, scheduler: DispatchQueue.global())
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
        dictionary.reduce(into: [Date: Int]()) { (result, element) in
            let (date, cycles) = element
            
            let cyclesCount = cycles.count == 0 ? 1 : cycles.count
            let sumOfEvaluation = cycles.reduce(0) { $0 + $1.evaluation }
            let averageOfEvaluation = Int(sumOfEvaluation / cyclesCount)
            
            result[date] = averageOfEvaluation
        }
    }
    
    private func resetDict() {
        cyclesOfDate = [Date : [Cycle]]()
    }
}
