//
//  TimerHexagon.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/25.
//

import SwiftUI

struct TimerHexagon: View {
    let width: CGFloat
    let timerEndDegree: Double
    let foregroundColor: Color
    let backgroundColor: Color
    var body: some View {
        CircularSector(endDegree: timerEndDegree)
            .frame(width: width * 0.85, height: width * 0.85)
            .foregroundColor(foregroundColor)
            .clipShape(RoundedHexagon(radius: width * 0.425, cornerAngle: 5))
            .overlay {
                CubeHexagon(radius: width * 0.425)
                    .stroke(style: .init(lineWidth: 8, lineJoin: .round))
                    .foregroundColor(.white.opacity(0.2))
            }
            .background {
                RoundedHexagon(radius: width * 0.425, cornerAngle: 5)
                    .foregroundColor(backgroundColor)
            }
    }
}
