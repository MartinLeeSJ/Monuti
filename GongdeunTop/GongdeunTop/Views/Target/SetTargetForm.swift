//
//  SetTargetForm.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/15.
//

import SwiftUI

struct SetTargetForm: View {
    enum Mode {
        case add
        case edit
    }
    
    enum TargetField: Int, Hashable, CaseIterable {
        case title
        case content
    }
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var target: Target = Target(title: "",
                                       subtitle: "",
                                       createdAt: Date.now,
                                               startDate: Date.now,
                                       dueDate: Date.now,
                                       todos: [],
                                       achievement: 0,
                                       memoirs: "")
    @FocusState private var focusedField: TargetField?
    
    private var mode: Mode = .add
    private var onCommit: (_ target: Target) -> Void
    
    init(mode: Mode = .add, onCommit: @escaping (_: Target) -> Void) {
        self.mode = mode
        self.onCommit = onCommit
    }
    
    private let startDateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let dateInterval = calendar.dateInterval(of: .day, for: Date())
        let startTime: Date = dateInterval?.start ?? Date()
        let endTime: Date = calendar.date(byAdding: .month, value: 6, to: startTime) ?? Date()
        return startTime...endTime
    }()
    
    private var endDateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let dateInterval = calendar.dateInterval(of: .day, for: target.startDate)
        let startTime: Date = dateInterval?.end ?? Date()
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
                ScrollView {
                    VStack(spacing: .spacing(of: .long)) {
                        titleAndSubtitleTextField
                        startAndDuteDatePicker
                        termsInfos
                    }
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
                        .disabled(target.title.isEmpty)
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
    
    
    private var titleCharacterLimit: Int { 25 }
    private var subtitleCharacterLimit: Int { 40 }
    
    @ViewBuilder
    var titleAndSubtitleTextField: some View {
        TextFieldFormContainer {
            HStack(alignment: .bottom, spacing: .spacing(of: .normal)) {
                Text("targetTitle")
                    .font(.headline)
                    .fontWeight(.medium)
                    .requiredMark()
                TextField(text: $target.title) {
                    Text("targetTitle_placeholder")
                }
                .textfieldLimit(text: $target.title, limit: titleCharacterLimit)
                .focused($focusedField, equals: .title)
                .submitLabel(.next)
                .onSubmit { DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {focusedField = .content} }
                .font(.body)
            }
            
            Divider()
            
            HStack(alignment: .bottom, spacing: .spacing(of: .normal)) {
                Text("targetSubTitle")
                    .font(.headline)
                    .fontWeight(.medium)
                TextField(text: $target.subtitle) {
                    Text("targetSubTitle_placeHolder")
                }
                .textfieldLimit(text: $target.subtitle, limit: subtitleCharacterLimit)
                .focused($focusedField, equals: .content)
                .submitLabel(.continue)
                .onSubmit { focusedField = nil }
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
            Text(target.termDescription)
        }
        .padding()
        .background(themeManager.componentColor(), in: RoundedRectangle(cornerRadius: 10))

    }
}
