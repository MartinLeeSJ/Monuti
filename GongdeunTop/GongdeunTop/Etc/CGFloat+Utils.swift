//
//  CGFloat+Utils.swift
//  GongdeunTop
//
//  Created by Martin on 2023/06/03.
//

import Foundation
import UIKit

extension CGFloat {
    static func getScreenWidthDivided(with divider: Int) -> CGFloat {
        UIScreen.main.bounds.width / CGFloat(divider)
    }
}
