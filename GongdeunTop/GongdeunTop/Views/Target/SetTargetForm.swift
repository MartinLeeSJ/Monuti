//
//  SetTargetForm.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/15.
//

import SwiftUI

struct SetTargetForm: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @State var target: Target = Target(title: "",
                                       subtitle: "",
                                       createdAt: Date.now,
                                       startDate: Date.now,
                                       dueDate: Date.now,
                                       todos: [],
                                       achievement: 0,
                                       memoirs: "")
    enum Mode {
        case add
        case edit
    }
    var mode: Mode = .add
    var onCommit: (_ target: Target) -> Void
    
    let startDateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let dateInterval = calendar.dateInterval(of: .day, for: Date())
        let startTime: Date = dateInterval?.start ?? Date()
        let endTime: Date = calendar.date(byAdding: .month, value: 6, to: startTime) ?? Date()
        return startTime...endTime
    }()
    
    var endDateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let dateInterval = calendar.dateInterval(of: .day, for: target.startDate)
        let startTime: Date = dateInterval?.start ?? Date()
        let endTime = calendar.date(byAdding: .month, value: 6, to: startTime) ?? Date()
        return startTime...endTime
    }
    
    private func commit() {
        onCommit(target)
        dismiss()
    }
    
    private func cancel() {
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.sheetBackgroundColor()
                    .ignoresSafeArea(.all)
                VStack(spacing: 32) {
                    titleAndSubtitleTextField
                    startAndDuteDatePicker
                    termsInfos
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            cancel()
                        } label: {
                            Text("Cancel")
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            commit()
                        } label: {
                            Text(mode == .add ? "Add" : "Edit")
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(mode == .add ?
                                 String(localized: "targetForm_title_add") :
                                    String(localized: "targetForm_title_edit"))
                .font(.headline)
                .padding()
            }
        }
    }
    
    @ViewBuilder
    var titleAndSubtitleTextField: some View {
        TextFieldFormContainer {
            HStack {
                Text("targetTitle")
                TextField(text: $target.title) {
                    Text("targetTitle_placeholder")
                }
                .font(.body)
            }
            
            Divider()
            
            HStack {
                Text("targetSubTitle")
                TextField(text: $target.subtitle) {
                    Text("targetSubTitle_placeHolder")
                }
                .font(.body)
            }
        } header: {
            Text("target_titleAndSubtitle")
        }
    }
    
    @ViewBuilder
    var startAndDuteDatePicker: some View {
        FormContainer {
            DatePicker(
                String(localized: "target_start_date"),
                selection: $target.startDate,
                in: startDateRange,
                displayedComponents: [.date]
            )
            
            DatePicker(
                String(localized: "target_due_date"),
                selection: $target.dueDate,
                in: endDateRange,
                displayedComponents: [.date]
            )
        } header: {
            Text("target_start_and_due_date")
        }
    }
    
    @ViewBuilder
    var termsInfos: some View {
        HStack {
            Text("\(target.daysFromStartToDueDate) target_total_days")
            Spacer()
            TargetTermGauge(termIndex: target.termIndex)
            Text(target.dateTerms)
        }
        .padding()
        .background(themeManager.componentColor(), in: RoundedRectangle(cornerRadius: 10))

    }
}
//
//struct SetTargetForm_Previews: PreviewProvider {
//    static var previews: some View {
//        SetTargetForm()
//            .environmentObject(ThemeManager())
//    }
//}
