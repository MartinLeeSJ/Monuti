//
//  RecordView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI

enum WeekDays: String, Identifiable, CaseIterable {
    case Sun = "Sun"
    case Mon, Tue, Wed, Thu, Fri, Sat
    
    var id: Self { self }
    
}

struct RecordView: View {
    @ObservedObject var authViewModel: AuthManager
    @StateObject var calendarManager = CalendarManager()
    
    @State private var showingSetMonth: Bool = false

    var firstWeekdayDigit: Int {
        if let startDate = calendarManager.currentMonthData.first {
            
            return Int(startDate.formatted(Date.FormatStyle().weekday(.oneDigit))) ?? 1
        } else {
            return 1
        }
    }
    
    var currentMonth: String {
        calendarManager.selectedDate.formatted(Date.FormatStyle().month(.abbreviated))
    }
    
    var isCalendarInCurrentMonth: Bool {
        currentMonth == Date.now.formatted(Date.FormatStyle().month(.abbreviated))
    }
    
    var currentYear: String {
        calendarManager.selectedDate.formatted(Date.FormatStyle().year(.defaultDigits))
    }
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 0), count: 7), spacing: 5) {
                    ForEach(WeekDays.allCases) { weekday in
                        HStack(alignment: .center) {
                            Text(String(localized: LocalizedStringResource(stringLiteral: weekday.rawValue))
                            )
                            .font(.headline)
                            .padding(5)
                        }
                    }
                    
                    ForEach(1..<firstWeekdayDigit, id: \.self) { _ in
                        VStack {
                            Spacer()
                        }
                    }
                    
                    ForEach(calendarManager.currentMonthData, id: \.self) { date in
                        DateCell(date: date)
                    }
                }
                .gesture(DragGesture(minimumDistance: 2.0, coordinateSpace: .local)
                    .onEnded { value in
                        switch(value.translation.width, value.translation.height) {
                        case (...0, -50...50):
                            calendarManager.handleNextButton(.month)
                        case (0..., -50...50):
                            calendarManager.handlePreviousButton(.month)
                        default:  print("no clue")
                        }
                    }
                )
                
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSetMonth.toggle()
                    } label: {
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text(currentMonth)
                                .font(.title.bold())
                            
                            Text(currentYear)
                                .font(.callout)
                                .foregroundColor(.secondary)
                                
                            Image(systemName: "chevron.down.circle")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                }
                
                if !isCalendarInCurrentMonth {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            calendarManager.handleTodayButton()
                        } label: {
                            Text("오늘")
                        }
                    }
                }
            }
            .blur(radius: showingSetMonth ? 10 : 0)
        }
        .overlay {
            if showingSetMonth {
                SetMonthView(manager: calendarManager, isShowing: $showingSetMonth)
            }
        }
    }
}



struct DateCell: View {
    let date: Date
    
    var day: String {
        var str: String =
        date.formatted(
            Date.FormatStyle()
                .day(.defaultDigits)
        )
        
        if str.hasSuffix("일") {
            str.removeAll { $0 == "일" }
        }
        
        return str
    }
    
    var weekday: String {
        date.formatted(
            Date.FormatStyle()
                .weekday(.oneDigit)
        )
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            HAlignment(alignment: .center) {
                Text(day).foregroundColor(Color("basicFontColor"))
                    .font(.callout)
            }
            
            Button {
                
            } label: {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 1)
                    .frame(width: 35, height: 35)
                
            }
            
        }
    }
}




struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecordView(authViewModel: AuthManager())
                .environment(\.locale, .init(identifier: "ko"))
            RecordView(authViewModel: AuthManager())
                .environment(\.locale, .init(identifier: "en"))
        }
    }
}
