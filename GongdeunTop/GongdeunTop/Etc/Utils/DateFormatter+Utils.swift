//
//  DateFormatter+Utils.swift
//  GongdeunTop
//
//  Created by Martin on 2023/06/12.
//

import Foundation

extension DateFormatter {
    static var shortTimeFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }
}
