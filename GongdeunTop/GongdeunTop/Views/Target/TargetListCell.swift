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
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(themeManager.getComponentColor(), in: RoundedRectangle(cornerRadius: 10))
        .id(target.id)
        
    }
}
// MARK: - Header
extension TargetListCell {
    @ViewBuilder
    var targetDatesHeader: some View {
        HStack(spacing: 5) {
            TargetTermGauge(termIndex: target.termIndex)
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
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Badges
extension TargetListCell {
    @ViewBuilder
    var targetInfoBadges: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 16) {
                daysBadges
                dayLeftBadges
                completionBadges
                achievementBadges
            }
        }
    }
    
    var isDateYetToCome: Bool {
        Date.now < target.startDate
    }
    
    var todoCountString: AttributedString {
        getTargetBadgeString(localized: "\(target.todos.count) todo_in_target", number: target.todos.count)
    }
    
    
    var dayLeftUntilStartDateCountString: AttributedString {
        getTargetBadgeString(localized: "\(target.dayLeftUntilStartDate) target_dayLeft_count", number: target.dayLeftUntilStartDate)
    }
    
    var dayLeftUntilDueDateCountString: AttributedString {
        getTargetBadgeString(localized: "\(target.dayLeftUntilDueDate) target_dayLeft_count", number: target.dayLeftUntilDueDate)
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
        .padding(8)
        .background(in: RoundedRectangle(cornerRadius: 10))
        .backgroundStyle(.thickMaterial)
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
        .padding(8)
        .background(in: RoundedRectangle(cornerRadius: 10))
        .backgroundStyle(.thickMaterial)
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
        .padding(8)
        .background(in: RoundedRectangle(cornerRadius: 10))
        .backgroundStyle(.thickMaterial)
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
            Text(isDateYetToCome ?
                 dayLeftUntilStartDateCountString :
                    dayLeftUntilDueDateCountString
            )
            .fixedSize()
        }
        .padding(8)
        .background(in: RoundedRectangle(cornerRadius: 10))
        .backgroundStyle(.thickMaterial)
    }
    
    var badgeDivider: some View {
        Divider()
            .frame(height: 30)
    }
}

struct TargetListCell_Previews: PreviewProvider {
    static var previews: some View {
        TargetListCell(target: .placeholder)
            .environmentObject(ThemeManager())
    }
}
