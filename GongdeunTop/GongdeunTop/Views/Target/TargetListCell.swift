//
//  TargetListCell.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/15.
//

import SwiftUI

struct TargetListCell: View {
    @EnvironmentObject var themeManager: ThemeManager
    let target: Target
    var body: some View {
        VStack(spacing: 10) {
            targetDatesHeader
            targetTitles
            targetInfoBadges
        }
        .padding()
        .background(themeManager.getComponentColor(), in: RoundedRectangle(cornerRadius: 10))
    }
}
// MARK: - Header
extension TargetListCell {
    @ViewBuilder
    var targetDatesHeader: some View {
        HStack(spacing: 5) {
            Text(target.dateTerms)
                .font(.caption)
                .padding(3)
                .background(themeManager.getColorInPriority(of: target.termColorPriority))
            Spacer()
            Text(target.startDateString)
                .font(.caption)
                .fixedSize()
                .padding(4)
                .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 8))
            
            Text(target.dueDateString)
                .font(.caption)
                .fixedSize()
                .padding(4)
                .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 8))
        }
    }
}

// MARK: - Titles
extension TargetListCell {
    @ViewBuilder
    var targetTitles: some View {
        HAlignment(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(target.title)
                    .font(.headline)
                Text(target.subtitle)
                    .font(.subheadline)
            }
        }
    }
}

// MARK: - Badges
extension TargetListCell {
    @ViewBuilder
    var targetInfoBadges: some View {
        Divider()
        HStack(spacing: 16) {
            VStack {
                Text("성취도")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize()
                RoundedHexagon(radius: 16, cornerAngle: 5)
                    .frame(width: 35)
            }
            .padding()
            
            VStack {
                Text("해낸 일들")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize()
                Text("0")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray.opacity(0.5))
            }
            .padding()
            
            VStack {
                Text("남은 일수")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize()
                Text("D-3")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray.opacity(0.5))
                    .fixedSize()
            }
            .padding()
        }
    }
}

struct TargetListCell_Previews: PreviewProvider {
    static var previews: some View {
        TargetListCell(target: .placeholder)
    }
}
