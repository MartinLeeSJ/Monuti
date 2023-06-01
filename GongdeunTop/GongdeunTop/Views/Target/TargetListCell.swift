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
    var isDateYetToCome: Bool {
        Date.now < target.startDate
    }
    
    var todoCountString: AttributedString {
        let todoCount = target.todos.count
        let todoString = todoCount > 1 ? "Todos" : "Todo"
        var attributedString = AttributedString("\(target.todos.count) \(todoString)")
        
        if let todoStringRange = attributedString.range(of: "\(todoString)"),
           let todoCountRange = attributedString.range(of: "\(target.todos.count)")
        {
            attributedString[todoCountRange].font = .title.weight(.semibold)
            attributedString[todoCountRange].foregroundColor = .secondary
            attributedString[todoStringRange].font = .caption
            attributedString[todoStringRange].foregroundColor = .secondary
        }
        return attributedString
    }
    
    @ViewBuilder
    var targetInfoBadges: some View {
        Divider()
        HStack(spacing: 16) {
            achievementBadges
            completionBadges
            dayLeftBadges
        }
    }
    
    var achievementBadges: some View {
        VStack {
            Text("Achievement")
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize()
            Spacer()
            RoundedHexagon(radius: 16, cornerAngle: 5)
                .frame(width: 35)
        }
        .padding()
    }
    
    var completionBadges: some View {
        VStack {
            Text("Completed")
                .font(.caption)
                .fixedSize()
            Spacer()
            Text(todoCountString)
        }
        .foregroundColor(.secondary)
        .padding()
    }
    
    var dayLeftBadges: some View {
        VStack {
            Text(isDateYetToCome ? "Target Begins" : "Due date")
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize()
            Spacer()
            Text("D-\(target.dayDifferenceFromToday)")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .fixedSize()
        }
        .padding()
    }
}

struct TargetListCell_Previews: PreviewProvider {
    static var previews: some View {
        TargetListCell(target: .placeholder)
    }
}
