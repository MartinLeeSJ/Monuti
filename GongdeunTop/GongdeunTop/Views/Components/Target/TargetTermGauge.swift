//
//  TargetTermGauge.swift
//  GongdeunTop
//
//  Created by Martin on 2023/06/07.
//

import SwiftUI

struct TargetTermGauge: View {
    @EnvironmentObject private var themeManager: ThemeManager
    private let termIndex: Int
    private var description: String?
    
    init(termIndex: Int, description: String? = nil) {
        self.termIndex = termIndex
        self.description = description
    }
    
    private let gaugeHeight: CGFloat = 4
    private let gaugeWidth: CGFloat = 10
    
    
    var body: some View {
        HStack(spacing: 1) {
            ForEach(0..<Target.allTermsCount, id: \.self) { level in
                if level < termIndex {
                    Rectangle()
                        .fill(themeManager.colorInPriority(in: .accent))
                        .frame(width: gaugeWidth, height: gaugeHeight)
                } else {
                    Rectangle()
                        .fill(.tertiary)
                        .frame(width: gaugeWidth, height: gaugeHeight)
                }
            }
            
            if let description {
                Text(description)
                    .font(.caption.bold())
                    .padding(.leading, .spacing(of: .quarter))
            }
            
        }
        .padding(description != nil ? .spacing(of: .quarter) : .spacing(of: .normal))
        .background(in: RoundedRectangle(cornerRadius: 4))
        .backgroundStyle(.thickMaterial)
    }
}

struct TargetTermGauge_Previews: PreviewProvider {
    static var previews: some View {
        TargetTermGauge(termIndex: 2, description: "")
            .environmentObject(ThemeManager())
    }
}
