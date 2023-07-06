//
//  TargetDetailView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/06/12.
//

import SwiftUI

struct TargetDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    
    let target: Target
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                titles
                termInfo
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward.circle.fill")
                }
                .tint(themeManager.getColorInPriority(of: .accent))
            }
        }
    }
}

// MARK: - Titles
extension TargetDetailView {
    @ViewBuilder
    var titles: some View {
        Text(target.title)
            .font(.title)
            .fontWeight(.bold)
        Text(target.subtitle)
            .font(.title3)
            .fontWeight(.semibold)
        Divider()
    }
}

// MARK: - Term Info
extension TargetDetailView {
    @ViewBuilder
    var termInfo: some View {
        termText
        termGraph
    }
    var termText: some View {
        HStack {
            Text("targetDetail_term")
                .font(.headline)
            Divider()
            
            Text(target.startDateString)
            Text("~")
            Text(target.dueDateString)
        }
    }
    
    @ViewBuilder
    var termGraph: some View {
        GeometryReader { geo in
            let leftDayRatio = CGFloat(target.dayLeftUntilDueDate) / CGFloat(target.daysFromStartToDueDate)
            let leftDayWidth: CGFloat = geo.size.width * leftDayRatio
            HStack {
                Spacer()
                HStack(spacing: 4) {
                    Text("\(target.dayLeftUntilDueDate)")
                    Text("/")
                    Text("\(target.daysFromStartToDueDate)")
                }
                .font(.headline)
                .padding(4)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                Spacer()
            }
            .padding()
            .background {
                Rectangle()
                    .foregroundColor(themeManager.getColorInPriority(of: .weak))
                    .overlay(alignment: .leading) {
                        Rectangle()
                            .frame(width: leftDayWidth)
                            .foregroundColor(themeManager.getColorInPriority(of: .solid))
                    }
                    .clipShape(Capsule())
            }
        }
    }
}


