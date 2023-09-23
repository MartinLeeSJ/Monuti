//
//  StartingTimeFormCell.swift
//  GongdeunTop
//
//  Created by Martin on 2023/09/01.
//

import SwiftUI

struct StartingTimeFormCell: View {
    @Binding var startingTime: Date
    
    private var fromNowToTomorrow: ClosedRange<Date> {
        let now = Date.now
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now) ?? Date.now
        let tomorrowEnd = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: tomorrow) ?? Date.now
        return now...tomorrowEnd
    }
    var body: some View {
        FormContainer {
            DatePicker(
                "setTodoForm_startingTimeForm_datePickerTitle",
                selection: $startingTime,
                in: fromNowToTomorrow,
                displayedComponents: [.hourAndMinute, .date]
            )
            .datePickerStyle(.compact)
        }
    }
}
