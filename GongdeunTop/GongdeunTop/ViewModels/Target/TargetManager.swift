//
//  TargetManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/15.
//

import Foundation
import Combine
import Factory

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

final class TargetManager: ObservableObject {
    @Injected(\.firestore) var database
    @Injected(\.targetRepository) var targetRepository
    @Published var targets = [Target]()
    @Published var isEditing: Bool = false
    @Published var multiSelection = Set<String?>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        targetRepository
            .$targets
            .assign(to: &$targets)
    }
    
    func addTarget(_ target: Target) {
        do {
            try targetRepository.addTarget(target)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateTarget(_ target: Target) {
        do {
            try targetRepository.updateTarget(target)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeTarget(_ target: Target) async {
        do {
            try await targetRepository.removeTarget(target)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeTargets() {
        guard !multiSelection.isEmpty else { return }
        let filteredTarget: [Target] = self.targets.filter {
            multiSelection.contains($0.id)
        }
        Task {
            do {
                try await targetRepository.removeTargets(filteredTarget: filteredTarget)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
