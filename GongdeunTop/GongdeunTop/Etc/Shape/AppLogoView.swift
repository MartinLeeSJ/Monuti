//
//  AppLogoView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/06/07.
//

import SwiftUI

struct AppLogoView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let radius: CGFloat
    var body: some View {
        RoundedHexagon(radius: radius, cornerAngle: 8)
            .foregroundColor(themeManager.colorInPriority(in: .weak))
            .overlay {
                CircularSector(endDegree: 120)
                    .foregroundColor(themeManager.colorInPriority(in: .solid))
                    .frame(width: radius * 2)
            }
            .clipShape(RoundedHexagon(radius: radius, cornerAngle: 8))
    }
}

struct AppLogoView_Previews: PreviewProvider {
    static var previews: some View {
        AppLogoView(radius: 20)
            .environmentObject(ThemeManager())
    }
}
