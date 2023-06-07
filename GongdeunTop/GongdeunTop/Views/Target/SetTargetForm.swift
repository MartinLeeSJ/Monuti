//
//  SetTargetForm.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/15.
//

import SwiftUI

struct SetTargetForm: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var targetManager = TargetManager()
    
    let startDateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let dateInterval = calendar.dateInterval(of: .day, for: Date())
        let startTime: Date = dateInterval?.start ?? Date()
        let endTime: Date = calendar.date(byAdding: .month, value: 6, to: startTime) ?? Date()
        return startTime...endTime
    }()
    
    var endDateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let dateInterval = calendar.dateInterval(of: .day, for: targetManager.target.startDate)
        let startTime: Date = dateInterval?.start ?? Date()
        let endTime = calendar.date(byAdding: .month, value: 6, to: startTime) ?? Date()
        return startTime...endTime
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.getSheetBackgroundColor()
                    .ignoresSafeArea(.all)
                VStack(spacing: 16) {
                    titleAndSubtitleTextField
                    startAndDuteDatePicker
                    termsInfos
                    
                    
                    Spacer()
                }
                .toolbar {
                    ToolbarItem {
                        Button {
                            targetManager.handleDoneTapped()
                        } label: {
                            Text("Add")
                        }
                        .disabled(!targetManager.modified)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(Text("새 목표"))
                .font(.headline)
                .padding()
            }
        }
    }
    
    @ViewBuilder
    var titleAndSubtitleTextField: some View {
        VStack {
            HStack {
                Text("targetTitle")
                TextField(text: $targetManager.target.title) {
                    Text("targetTitle_placeholder")
                }
                .font(.body)
            }
            
            Divider()
            
            HStack {
                Text("targetSubTitle")
                TextField(text: $targetManager.target.subtitle) {
                    Text("targetSubTitle_placeHolder")
                }
                .font(.body)
            }
        }
        .padding([.vertical, .leading])
        .background(themeManager.getComponentColor(), in: RoundedRectangle(cornerRadius: 10))
        .textFieldStyle(.plain)
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.never)
        .padding(.top, 16)
        .overlay(alignment: .topLeading) {
            Text("target_titleAndSubtitle")
                .font(.caption)
                .foregroundColor(.secondary)
                .offset(y: -2)
        }
    }
    
    @ViewBuilder
    var startAndDuteDatePicker: some View {
        VStack {
            DatePicker(
                String(localized: "target_start_date"),
                selection: $targetManager.target.startDate,
                in: startDateRange,
                displayedComponents: [.date]
            )
            
            DatePicker(
                String(localized: "target_due_date"),
                selection: $targetManager.target.dueDate,
                in: endDateRange,
                displayedComponents: [.date]
            )
        }
        .padding()
        .background(themeManager.getComponentColor(), in: RoundedRectangle(cornerRadius: 10))
        .padding(.top, 16)
        .overlay(alignment: .topLeading) {
            Text("target_start_and_due_date")
                .font(.caption)
                .foregroundColor(.secondary)
                .offset(y: -2)
        }
    }
    
    @ViewBuilder
    var termsInfos: some View {
        HStack {
            Text("\(targetManager.target.daysFromStartToDueDate) target_total_days")
            Spacer()
            TargetTermGauge(termIndex: targetManager.target.termIndex)
            Text(targetManager.target.dateTerms)
        }
        .padding()
        .background(themeManager.getComponentColor(), in: RoundedRectangle(cornerRadius: 10))

    }
}

struct SetTargetForm_Previews: PreviewProvider {
    static var previews: some View {
        SetTargetForm(targetManager: TargetManager())
            .environmentObject(ThemeManager())
    }
}
