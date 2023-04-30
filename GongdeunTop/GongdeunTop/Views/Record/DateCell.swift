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
        case .weak: return Image("sand.flat.blue")
        case .good: return Image("brick.flat.blue")
        case .solid: return Image("steel.flat.blue")
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
    
    private var isSelected: Bool {
        Calendar.current.isDate(date, inSameDayAs: manager.selectedDate)
    }
    
    var body: some View {
        VStack(spacing: 5) {
            HAlignment(alignment: .center) {
                Text(day)
                    .font(.caption)
                    .foregroundColor(isToday || isSelected ? .white : Color("basicFontColor"))
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

                Color.GTWarmGray
                    .frame(width: 35, height: 35)
                    .cornerRadius(5)
                    .overlay {
                        if let evaluation, evaluation != 0 {
                            DateEvaluations(rawValue: evaluation)?.image
                                .resizable()
                                .cornerRadius(5)
                        }
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.white, lineWidth: 1)
                    }
            }
            
        }
        .padding(5)
        .background {
            if isSelected {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.GTDenimNavy)
                    
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
