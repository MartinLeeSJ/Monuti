//
//  CycleManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/17.
//

import Foundation
import Combine

import FirebaseAuth
import FirebaseFirestore

final class CycleManager: ObservableObject {
    @Published var cycle: Cycle
    @Published var modified: Bool = false

    private let database = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    init(cycle: Cycle = Cycle(createdAt: Timestamp(date: Date()), todos: [], evaluation: 0, memoirs: "")) {
        self.cycle = cycle
        self.$cycle
            .dropFirst()
            .sink { [weak self] cycle in
                self?.modified = true
            }
            .store(in: &self.cancellables)
    }
    
}
