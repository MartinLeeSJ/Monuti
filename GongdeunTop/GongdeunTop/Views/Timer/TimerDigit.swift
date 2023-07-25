//
//  TimerDigit.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/25.
//

import SwiftUI

struct TimerDigit: View {
    let width: CGFloat
    let minuteString: String
    let secondString: String
    var body: some View {
        let minuteWidth = width * 0.425
        let secondWidth = width * 0.425
        let colonWidth = width * 0.15
        HStack(alignment: .center, spacing: 0) {
            Text(minuteString)
                .frame(width: minuteWidth, alignment: .trailing)
                .font(.system(size: 60, weight: .regular, design: .rounded))
            Text(":")
                .frame(width: colonWidth, alignment: .center)
                .font(.system(size: 54, weight: .regular))
            Text(secondString)
                .frame(width: secondWidth, alignment: .leading)
                .font(.system(size: 60, weight: .regular, design: .rounded))
        }
    }
}


