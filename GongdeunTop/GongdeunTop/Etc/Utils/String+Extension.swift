//
//  String+Extension.swift
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
