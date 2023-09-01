//
//  String+Utils.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/31.
//

import Foundation

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

// MARK: - 글자 수 제한
extension String {
    static func textCountLimit(text: inout String, limit: Int) {
        if limit < text.count {
            text = String(text.prefix(limit))
        }
    }
}
