//
//  TagManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/27.
//

import Foundation
import Combine

import Factory
import FirebaseAuth
import FirebaseFirestore

final class TagManager: ObservableObject {
    @Injected(\.tagRepository) var tagRepository
    
    @Published var tags = [Tag]()
    
    init() {
        tagRepository
            .$tags
            .assign(to: &$tags)
    }
    
    func add(_ tag: Tag) {
        tagRepository.add(tag)
    }
    
    func increaseCount(of tag: Tag) {
        tagRepository.increaseCount(of: tag)
    }
    
    func decreaseCount(of tag: Tag) {
        tagRepository.decreaseCount(of: tag)
    }
    
    func decreaseCountOfTags(of titles: [String]) {
        guard !titles.isEmpty else { return }
        let tags: [Tag] = titles.map { Tag(title: $0) }
        Task {
            do {
                try await tagRepository.decreaseCount(of: tags)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func delete(_ tag: Tag) {
        Task {
            do {
                try await tagRepository.delete(tag)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
