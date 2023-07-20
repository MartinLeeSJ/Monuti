//
//  Session.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/20.
//

import Foundation

struct Session: Identifiable, Codable {
    var id: String = UUID().uuidString
    var concentrationSeconds: Int
    var restSeconds: Int
    
    var sessionSeconds: Int {
        concentrationSeconds + restSeconds
    }
}
