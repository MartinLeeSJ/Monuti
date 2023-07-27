//
//  TagRepository+Injection.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/27.
//

import Foundation
import Factory

extension Container {
    public var tagRepository: Factory<TagRepository> {
        self {
            TagRepository()
        }.singleton
    }
}
