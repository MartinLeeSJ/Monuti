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
                VStack {
                    VStack {
                        HStack {
                            Text("타겟 이름")
                            TextField(text: $targetManager.target.title) {
                                Text("targetTitle")
                                    .font(.body)
                            }
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("타겟 설명")
                            TextField(text: $targetManager.target.subtitle) {
                                Text("targetSubTitle")
                                    .font(.body)
                            }
                        }
                    }
                    .padding([.vertical, .leading])
                    .background(themeManager.getColorInPriority(of: .weak), in: RoundedRectangle(cornerRadius: 10))
                    .textFieldStyle(.plain)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .padding(.top, 16)
                    
                    VStack {
                        DatePicker(
                            "Start Date",
                            selection: $targetManager.target.startDate,
                            in: startDateRange,
                            displayedComponents: [.date]
                        )
                        
                        DatePicker(
                            "End Date",
                            selection: $targetManager.target.dueDate,
                            in: endDateRange,
                            displayedComponents: [.date]
                        )
                    }
                    .padding()
                    .background(themeManager.getColorInPriority(of: .weak), in: RoundedRectangle(cornerRadius: 10))
                    
                    Spacer()
                }
                .foregroundColor(.black)
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
