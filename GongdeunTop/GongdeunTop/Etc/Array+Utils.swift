//
//  Array+Utils.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/10.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
