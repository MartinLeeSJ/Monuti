//
//  Firebase+Injection.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/26.
//

import Foundation
import Factory

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

extension Container {
    public var firestore: Factory<Firestore> {
        self {
            return Firestore.firestore()
        }.singleton
    }
    
    public var auth: Factory<Auth> {
        self {
            return Auth.auth()
        }.singleton
    }
}
