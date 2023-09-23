//
//  DateCell.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/27.
//

import SwiftUI
import Combine

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
    
    @Binding var selectedDate: Date?
    private let date: Date
    private var evaluation: Int? = nil
    private let onSelect: () -> Void

    init(
        selectedDate: Binding<Date?>,
        date: Date,
        evaluation: Int? = nil,
        onSelect: @escaping () -> Void
    ) {
        self._selectedDate = selectedDate
        self.date = date
        self.evaluation = evaluation
        self.onSelect = onSelect
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
        guard let selectedDate = selectedDate else { return false }
        return Calendar.current.isDate(date, inSameDayAs: selectedDate)
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
            onSelect()
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
                        dateCellHexagon
                            .stroke(
                                scheme == .dark ?
                                    .white.opacity(0.6) :
                                    .gray.opacity(0.1),
                                lineWidth: 1.5
                            )
                }
                .overlay {
                    if isSelected {
                        dateCellHexagon
                            .stroke(themeManager.colorInPriority(in: .accent), lineWidth: 2.5)
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
