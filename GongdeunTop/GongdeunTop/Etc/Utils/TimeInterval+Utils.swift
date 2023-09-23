//
//  TimeInterval+Utils.swift
//  GongdeunTop
//
//  Created by Martin on 2023/08/19.
//

import Foundation

extension TimeInterval {
    var sessionTimerDigit: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: self) ?? ""
    }
    
    var todoSpentTimeString: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropLeading
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: self) ?? ""
    }
}
