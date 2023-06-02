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
        VStack(spacing: 8) {
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
                .fontWeight(.bold)
                .padding(3)
                .background(themeManager.getColorInPriority(of: target.termColorPriority))
            Spacer()
            Text(target.startDateString)
                .font(.caption)
                .fontWeight(.semibold)
                .fixedSize()
                .padding(4)
                .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 8))
            
            Text(target.dueDateString)
                .font(.caption)
                .fontWeight(.semibold)
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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                daysBadges
                badgeDivider
                achievementBadges
                badgeDivider
                completionBadges
                badgeDivider
                dayLeftBadges
            }
        }
    }
    
    var isDateYetToCome: Bool {
        Date.now < target.startDate
    }
    
    var todoCountString: AttributedString {
        getTargetBadgeString(localized: "\(target.todos.count) todo_in_target", number: target.todos.count)
    }
    
    
    var targetDayLeftCountString: AttributedString {
        getTargetBadgeString(localized: "\(target.dayDifferenceFromToday) target_dayLeft_count", number: target.dayDifferenceFromToday)
    }
    
    private func getTargetBadgeString(localized string: LocalizedStringResource, number: Int) -> AttributedString {
        var attributedString = AttributedString(localized: string)
        attributedString.font = .systemFont(ofSize: 10)
        attributedString.foregroundColor = .secondary
        
        if let numberRange = attributedString.range(of: String(number)) {
            attributedString[numberRange].font = .title.weight(.semibold)
        }
        
        return attributedString
    }
    
    // MARK: - Badge SubViews
    var daysBadges: some View {
        VStack {
            Text("target_days")
                .font(.caption)
                .fixedSize()
            Spacer()
            Text("\(target.daysFromStartToDueDate)")
                .font(.title)
                .fixedSize()
        }
        .fontWeight(.semibold)
        .foregroundColor(.secondary)
        .padding()
    }
    
    var achievementBadges: some View {
        VStack {
            Text("target_achievement")
                .font(.caption)
                .foregroundColor(.secondary)
                .fontWeight(.semibold)
                .fixedSize()
            Spacer()
            RoundedHexagon(radius: 16, cornerAngle: 5)
                .frame(width: 35)
        }
        .padding()
    }
    
    var completionBadges: some View {
        VStack {
            Text("target_completed")
                .font(.caption)
                .foregroundColor(.secondary)
                .fontWeight(.semibold)
                .fixedSize()
            Spacer()
            Text(todoCountString)
                .fixedSize()
        }
        .padding()
    }
    
    var dayLeftBadges: some View {
        VStack {
            Text(isDateYetToCome ?
                 String(localized: "target_begins") :
                 String(localized: "target_due_date")
            )
                .font(.caption)
                .foregroundColor(.secondary)
                .fontWeight(.semibold)
                .fixedSize()
            Spacer()
            Text(targetDayLeftCountString)
                .fixedSize()
        }
        .padding()
    }
    
    var badgeDivider: some View {
        Divider()
            .frame(height: 30)
    }
}

struct TargetListCell_Previews: PreviewProvider {
    static var previews: some View {
        TargetListCell(target: .placeholder)
    }
}
