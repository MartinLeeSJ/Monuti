//
//  AuthService+Injection.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/26.
//

import Foundation
import Factory

extension Container {
    public var authService: Factory<AuthService> {
        self {
            AuthService()
        }.singleton
    }
}
