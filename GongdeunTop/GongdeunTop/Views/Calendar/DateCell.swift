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
    
    var color: Color {
        switch self {
        case .weak: return .GTWeakBlue
        case .good: return .GTGoodBlue
        case .solid: return .GTSolidBlue
        }
    }
}

struct DateCell: View {
    @EnvironmentObject var themeManager: ThemeManager
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
                    .foregroundColor(isToday ? .white : Color("basicFontColor"))
                    .frame(minWidth: 20)
                    .background {
                        if isToday {
                            Capsule()
                                .fill(themeManager.getColorInPriority(of: .accent))
                        }
                    }
            }
            
            
            Button {
                manager.selectedDate = date
            } label: {
                RoundedHexagon(radius: 20, cornerAngle: 5)
                    .fill(.thinMaterial)
                    .frame(width: 33, height: 33)
                    .overlay {
                        if let evaluation, evaluation != 0, let priority = ColorPriority(rawValue: evaluation) {
                            RoundedHexagon(radius: 20, cornerAngle: 5)
                                .foregroundColor(themeManager.getColorInPriority(of: priority))
                        }
                    }
                    .overlay {
                        if scheme == .dark {
                            RoundedHexagon(radius: 20, cornerAngle: 5)
                                .stroke(.white.opacity(0.6), lineWidth: 1.5)
                        }
                    }
                    .overlay {
                        if isSelected {
                            RoundedHexagon(radius: 20, cornerAngle: 5)
                                .stroke(themeManager.getColorInPriority(of: .accent), lineWidth: 2)
                        }
                    }
            }
            
        }
        .padding(3)
        
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
