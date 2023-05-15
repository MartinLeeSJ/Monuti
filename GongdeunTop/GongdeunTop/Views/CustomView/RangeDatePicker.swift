//
//  RangeDatePicker.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/15.
//

import SwiftUI


struct RangeDatePicker: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    @State private var showCalendar: Bool = false
    var dateRange: ClosedRange<Date> = Date.now...Date.now
    
    var startDateFormatted: String {
        startDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    var endDateFormatted: String {
        endDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    
    
    var body: some View {
        HStack {
            Text("Select Date!")
            Button {
                showCalendar.toggle()
            } label: {
                HStack(spacing: 10) {
                    Text(startDateFormatted)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 8))
                    
                    Text(endDateFormatted)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .popover(isPresented: $showCalendar) {
            Text("test")
                
        }
    }
}

struct RageDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        RangeDatePicker(startDate: .constant(Date.now),
                       endDate: .constant(Date.now))
    }
}
