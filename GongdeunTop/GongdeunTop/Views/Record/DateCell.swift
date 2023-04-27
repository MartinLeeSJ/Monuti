//
//  DateCell.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/27.
//

import SwiftUI

struct DateCell: View {
    @Environment(\.colorScheme) var scheme
    @ObservedObject var manager: CalendarManager
    
    
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
    
    var body: some View {
        VStack(spacing: 5) {
            HAlignment(alignment: .center) {
                Text(day).foregroundColor(Color("basicFontColor"))
                    .font(.caption)
            }
            
            Button {
                manager.selectedDate = date
            } label: {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 1)
                    .frame(width: 35, height: 35)
                    .background {
                        if scheme == .light {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.white)
                        }
                    }
                
            }
            .tint(scheme == .light ? .GTDenimBlue : .white)
        }
        .padding(5)
        .background {
            if Calendar.current.isDate(date, inSameDayAs: manager.selectedDate) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.GTPastelBlue)
            }
        }
    }

}

struct DateCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                DateCell(manager: CalendarManager(), date: Date.now)
            }.frame(width: 50)
        }
    }
}
