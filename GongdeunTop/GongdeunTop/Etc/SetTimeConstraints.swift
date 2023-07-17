//
//  SetTimeConstraints.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/13.
//

import Foundation

struct SetTimeContraint {
    static let looseSessionsBound: Range<Int> = 1..<9
    static let sessionsBound: Range<Int> = 1..<6
    static let sessionStep: Int.Stride = 1
    static let basicSessions: Int = 4
    
    static let looseConcentrationSecondBound: Range<Int> = (1 * 60)..<((50 * 60) + 1)
    static var looseConcentrationMinuteBound: Range<Int> { Self.getMinuteBound(bound: Self.looseConcentrationSecondBound) }
    static let concentrationSecondBound: Range<Int> = (15 * 60)..<((50 * 60) + 1)
    static var concentrationMinuteBound: Range<Int> { Self.getMinuteBound(bound: Self.concentrationSecondBound) }
    static let concentrationSecondStep: Int.Stride = 5 * 60
    
    static let looseRestSecondBound: Range<Int> = 0..<((30 * 60) + 1)
    static var looseRestMinuteBound: Range<Int> { Self.getMinuteBound(bound: Self.looseRestSecondBound) }
    static let restSecondBound: Range<Int> = (5 * 60)..<((10 * 60) + 1)
    static var restMinuteBound: Range<Int> { Self.getMinuteBound(bound: Self.restSecondBound) }
    static let restSecondStep: Int.Stride = 1 * 60
    
    static func getMinuteBound(bound: Range<Int>) -> Range<Int> {
        let lowerBound: Int = bound.lowerBound / 60
        let upperBound: Int = (bound.upperBound - 1) / 60 + 1
        return lowerBound..<upperBound
    }
}
