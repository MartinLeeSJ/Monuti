//
//  DateCell.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/27.
//

import SwiftUI

enum DateEvaluations: Int {
    case weak = 1
    case good = 2
    case solid = 3
    
    var image: Image {
        switch self {
        case .weak: return Image("sand.flat")
        case .good: return Image("brick.flat")
        case .solid: return Image("steel.flat")
        }
    }
}

struct DateCell: View {
    @Environment(\.colorScheme) var scheme
    @ObservedObject var manager: CalendarManager
    
    
    let date: Date
    var evaluation: Int? = nil
    
    private var day: String {
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
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    var body: some View {
        VStack(spacing: 5) {
            HAlignment(alignment: .center) {
                Text(day)
                    .font(.caption)
                    .foregroundColor(isToday ? .white : Color("basicFontColor"))
                    .padding(.horizontal, 3)
                    .background {
                        if isToday {
                            Capsule()
                                .fill(Color.GTDenimNavy)
                        }
                    }
            }
            
            
            Button {
                manager.selectedDate = date
            } label: {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 1)
                    .frame(width: 35, height: 35)
                    .background {
                        if let evaluation, evaluation != 0 {
                            DateEvaluations(rawValue: evaluation)?.image
                                .resizable()
                                .cornerRadius(5)
                        } else {
                            if scheme == .light {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color(uiColor: .systemGray6))
                            }
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
