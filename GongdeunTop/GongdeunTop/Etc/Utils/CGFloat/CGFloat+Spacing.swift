//
//  CGFloat+Spacing.swift
//  GongdeunTop
//
//  Created by Martin on 2023/09/01.
//

import Foundation

extension CGFloat {
    enum Spacing: CGFloat {
        case minimum = 2
        case quarter = 4
        case half = 8
        case normal = 16
        case middle = 24
        case long = 32
    }
    static func spacing(of length: Self.Spacing) -> Self {
        return length.rawValue
    }
}
