//
//  TargetRepository+Injection.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/26.
//

import Foundation

import Factory


extension Container {
    public var targetRepository: Factory<TargetRepository> {
        self {
            TargetRepository()
        }.singleton
    }
}
