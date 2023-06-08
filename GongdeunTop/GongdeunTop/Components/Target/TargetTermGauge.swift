//
//  TargetTermGauge.swift
//  GongdeunTop
//
//  Created by Martin on 2023/06/07.
//

import SwiftUI

struct TargetTermGauge: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let termIndex: Int
    var body: some View {
        HStack(spacing: 1) {
            ForEach(0..<4) { level in
                if level < termIndex {
                    Rectangle()
                        .fill(themeManager.getColorInPriority(of: .accent))
                } else {
                    Rectangle()
                        .fill(.tertiary)
                }
            }
        }
        .frame(width: 50, height: 4)
        .padding(8)
        .background(in: RoundedRectangle(cornerRadius: 4))
        .backgroundStyle(.thickMaterial)
    }
}

struct TargetTermGauge_Previews: PreviewProvider {
    static var previews: some View {
        TargetTermGauge(termIndex: 2)
            .environmentObject(ThemeManager())
    }
}
