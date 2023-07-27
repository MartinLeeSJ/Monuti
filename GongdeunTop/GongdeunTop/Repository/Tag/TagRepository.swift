//
//  TagRepository.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/27.
//

import Foundation
import Combine

import Factory

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

public class TagRepository: ObservableObject, FirebaseListener {
    @Injected(\.authService) var authService
    @Injected(\.firestore) var database
    @Published var tags = [Tag]()
    @Published var user: User? = nil
    
    private var cancelables = Set<AnyCancellable>()
    private var listenerRegistration: ListenerRegistration?
    
    init() {
        authService
            .$user
            .assign(to: &$user)
        
        $user
            .sink { [weak self] user in
                self?.unsubscribe()
                self?.subscribe(user: user)
            }
            .store(in: &cancelables)
    }
    
    deinit {
        unsubscribe()
    }
    
    func unsubscribe() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    func subscribe(user: User?) {
        guard let uid = user?.uid else { return }
        guard listenerRegistration == nil else { return }
        
        listenerRegistration = database
            .collection("Members")
            .document(uid)
            .collection("Tag")
            .addSnapshotListener { [weak self] (snapshot, error) in
                guard let self = self, let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "unknown")")
                    return
                }
                
                self.tags = documents.compactMap{ queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Tag.self)
                }
            }
        
    }
    
    func add(_ tag: Tag) {
        guard let tagReference = reference(of: tag) else { return }
        tagReference.setData([
            "title" : tag.title,
            "count" : 1
        ])
    }
    
    func increaseCount(of tag: Tag) {
        guard let tagReference = reference(of: tag) else { return }
        tagReference.updateData(["count" : FieldValue.increment(Int64(1))])
    }
    
    func decreaseCount(of tag: Tag) {
        guard let tagReference = reference(of: tag) else { return }
        tagReference.updateData(["count" : FieldValue.increment(Int64(-1))])
    }
    
    func decreaseCount(of tags: [Tag]) async throws {
        let batch = database.batch()
        
        for tag in tags {
            guard let tagReference = reference(of: tag) else { continue }
            batch.updateData(["count": FieldValue.increment(Int64(-1))],
                             forDocument: tagReference)
        }
        
        try await batch.commit()
    }
    
    func delete(_ tag: Tag) async throws {
        guard let tagReference = reference(of: tag) else { return }
        try await tagReference.delete()
    }
    

    private func reference(of tag: Tag) -> DocumentReference?  {
        guard let uid = user?.uid else { return nil }
        return database
            .collection("Members")
            .document(uid)
            .collection("Tag")
            .document(tag.title)
    }
}
