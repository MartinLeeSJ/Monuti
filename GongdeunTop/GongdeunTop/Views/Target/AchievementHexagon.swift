//
//  AchievementHexagon.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/31.
//

import SwiftUI

struct AchievementHexagon: View {
    let radius: Double
    let achievementRate: Double
    let color: Color
    
    var frameWidth: CGFloat {
        CGFloat(radius) * 2
    }
    
    var percent: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter.string(for: achievementRate) ?? ""
    }
    
    var body: some View {
        GeometryReader { geo in
            let height = geo.size.height
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.tertiary)
                Rectangle()
                    .fill(color)
                    .frame(height: height * achievementRate)
            }
        }
        .frame(width: frameWidth, height: frameWidth)
        .overlay {
            Text(percent)
                .font(.system(size: frameWidth / 4, weight: .black))
                .blendMode(.overlay)
        }
        .clipShape(RoundedHexagon(radius: radius, cornerAngle: 5))
        
    }
}

struct AchievementHexagon_Previews: PreviewProvider {
    static var previews: some View {
        AchievementHexagon(radius: 16, achievementRate: 0.6, color: .GTDenimBlue)
    }
}
