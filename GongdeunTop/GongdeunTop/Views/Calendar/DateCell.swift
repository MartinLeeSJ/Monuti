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
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.colorScheme) private var scheme
    
    @ObservedObject private var manager: CalendarManager
    private let date: Date
    private var evaluation: Int? = nil
    
    init(manager: CalendarManager, date: Date, evaluation: Int? = nil) {
        self.manager = manager
        self.date = date
        self.evaluation = evaluation
    }
    
    private var dateDigit: String {
        var str: String = date.formatted(Date.FormatStyle().day(.defaultDigits))
        
        if str.hasSuffix("일") {
            str.removeLast()
        }
        
        return str
    }
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    private var isSelected: Bool {
        Calendar.current.isDate(date, inSameDayAs: manager.selectedDate)
    }
    
    private func selectDate() {
        manager.selectDate(date)
    }
    
    private let dateCellRadius: CGFloat = 18
    private let dateCellCornerRadius: CGFloat = 6
    
    
    var body: some View {
        VStack(spacing: .spacing(of: .quarter)) {
            dateDigitView
            dateCellButton
        }
        
    }
    
    private var dateDigitView: some View {
        Text(dateDigit)
            .font(.caption.bold())
            .foregroundColor(isToday ? .white : Color("basicFontColor"))
            .frame(minWidth: 20)
            .background {
                if isToday {
                    Capsule()
                        .fill(themeManager.colorInPriority(in: .accent))
                }
            }
    }
    
    private var dateCellButton: some View {
        Button {
            selectDate()
        } label: {
            dateCellHexagon
                .modifier(HexagonStyle(scheme: scheme))
                .frame(width: dateCellRadius * 2, height: dateCellRadius * 2)
                .overlay {
                    if let evaluation,
                       let priority = ColorPriority(rawValue: evaluation),
                       evaluation != 0 {
                        dateCellHexagon
                            .foregroundColor(themeManager.colorInPriority(in: priority))
                    }
                }
                .overlay {
                    if scheme == .dark {
                        dateCellHexagon
                            .stroke(.white.opacity(0.6), lineWidth: 1.5)
                    }
                }
                .overlay {
                    if isSelected {
                        dateCellHexagon
                            .stroke(themeManager.colorInPriority(in: .accent), lineWidth: 2)
                    }
                }
        }
    }
    
    private var dateCellHexagon: some Shape {
        RoundedHexagon(radius: dateCellRadius, cornerAngle: dateCellCornerRadius)
    }
    
    
    
}

struct HexagonStyle: ViewModifier {
    var scheme: ColorScheme
    func body(content: Content) -> some View {
        if scheme == .light {
            content
                .foregroundColor(.white)
                .opacity(0.7)
        } else {
            content
                .foregroundStyle(Material.thinMaterial)
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
