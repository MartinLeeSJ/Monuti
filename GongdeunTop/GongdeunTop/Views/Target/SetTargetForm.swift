//
//  SetTargetForm.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/15.
//

import SwiftUI

struct SetTargetForm: View {
    @ObservedObject var targetManager = TargetManager()
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var dates: Set<DateComponents> = .init()
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let dateInterval = calendar.dateInterval(of: .day, for: Date())
        let startTime: Date = dateInterval?.start ?? Date()
        let endTime: Date = calendar.date(byAdding: .month, value: 6, to: startTime) ?? Date()
        
        return startTime...endTime
    }()
    
    let dateRange2: Range<Date> = {
        let calendar = Calendar.current
        let dateInterval = calendar.dateInterval(of: .day, for: Date())
        let startTime: Date = dateInterval?.start ?? Date()
        let endTime: Date = calendar.date(byAdding: .month, value: 6, to: startTime) ?? Date()
        return startTime..<endTime
    } ()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField(text: $targetManager.target.title) {
                    Text("targetTitle")
                }
                
                TextField(text: $targetManager.target.subtitle) {
                    Text("targetSubTitle")
                }
                
                DatePicker(
                        "Start Date",
                         selection: $startDate,
                         in: dateRange,
                         displayedComponents: [.date]
                    )
            
                
                DatePicker(
                        "End Date",
                         selection: $endDate,
                         in: dateRange,
                         displayedComponents: [.date]
                    )
                
                
             
            }
            .textFieldStyle(.roundedBorder)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .padding()
        }
        
    }
}

struct SetTargetForm_Previews: PreviewProvider {
    static var previews: some View {
        SetTargetForm(targetManager: TargetManager())
    }
}
