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
        NavigationView {
            VStack(spacing: 16) {
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
                        Text("Target")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .offset(y: -2)
                    }
                    
                    VStack {
                        DatePicker(
                            String(localized: "Start Date"),
                            selection: $targetManager.target.startDate,
                            in: startDateRange,
                            displayedComponents: [.date]
                        )
                        
                        DatePicker(
                            String(localized: "End Date"),
                            selection: $targetManager.target.dueDate,
                            in: endDateRange,
                            displayedComponents: [.date]
                        )
                    }
                    .padding()
                    .background(themeManager.getComponentColor(), in: RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 16)
                    .overlay(alignment: .topLeading) {
                        Text("Date")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .offset(y: -2)
                    }
                    
                    HAlignment(alignment: .center) {
                        Text("Total \(targetManager.target.daysFromStartToDueDate)days")
                        Text(targetManager.target.dateTerms)
                            .background(.thinMaterial, in: Rectangle())
                    }
                    .padding()
                    .background(themeManager.getComponentColor(), in: RoundedRectangle(cornerRadius: 10))
                    
                    Spacer()
                }
                .font(.headline)
                .padding()
                .toolbar {
                    ToolbarItem {
                        Button {
                            targetManager.handleDoneTapped()
                        } label: {
                            Text("Add")
                                
                        }
                    }
                }
            
        }
    }
}

struct SetTargetForm_Previews: PreviewProvider {
    static var previews: some View {
        SetTargetForm(targetManager: TargetManager())
            .environmentObject(ThemeManager())
    }
}
