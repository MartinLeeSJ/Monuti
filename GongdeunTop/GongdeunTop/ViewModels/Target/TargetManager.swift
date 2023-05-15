//
//  TargetManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/15.
//

import Foundation
import Combine

import FirebaseFirestore
import FirebaseAuth

final class TargetManager: ObservableObject {
    @Published var target: Target
    @Published var modified: Bool = false
    
    private let database = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    init(target: Target = .placeholder) {
        self.target = target
        self.$target
            .dropFirst()
            .sink { [weak self] target in
                self?.modified = true
            }
            .store(in: &self.cancellables)
    }
    
    private func addTarget(_ target: Target) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if target.id == nil {
            do {
                try database.collection("Members")
                    .document(uid)
                    .collection("Target")
                    .addDocument(from: target)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateTarget(_ target: Target) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let id = target.id else { return }
        
        do {
            try database
                .collection("Members")
                .document(uid)
                .collection("Target")
                .document(id)
                .setData(from: target)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func removeTarget() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let id = target.id else { return }
        
        do {
            try await
            database.collection("Members")
                .document(uid)
                .collection("Target")
                .document(id)
                .delete()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func addOrUpdateTarget() {
        if let _ = self.target.id {
            updateTarget(self.target)
        } else {
            addTarget(self.target)
        }
    }
    
    //MARK: - UI Handler
    func handleDoneTapped() {
        addOrUpdateTarget()
    }
    
    func handleDeleteTapped() {
        Task {
            await removeTarget()
        }
    }
    
    
}
