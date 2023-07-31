//
//  CycleRepository+Injection.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/31.
//

import Foundation
import Factory

extension Container {
    public var cycleRepository: Factory<CycleRepository> {
        self {
            CycleRepository()
        }.singleton
    }
}
