//
//  CycleListCell.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/27.
//

import SwiftUI

struct CyclesOfDayListCell: View {
    @Environment(\.colorScheme) private var scheme: ColorScheme
    @EnvironmentObject private var themeManager: ThemeManager
    
    @StateObject private var cycleManager: CycleManager
    @State private var showDetails: Bool = false
    
    init(cycle: Cycle) {
        self._cycleManager = StateObject(wrappedValue: CycleManager(cycle: cycle))
    }
    
    private var cycle: Cycle {
        cycleManager.cycle
    }
    
    private var hourAndMinute: String {
        cycle.createdAt.dateValue().formatted(
            Date.FormatStyle()
                .hour()
                .minute()
        )
    }
    
    private func handleShowDetail() {
        showDetails.toggle()
    }
    
    private let cellSizeRadius: CGFloat = 20
    private let cellCornerRadius: CGFloat = 5
    
    var body: some View {
        
        Button (action: handleShowDetail) {
            VStack {
                RoundedHexagon(radius: cellSizeRadius, cornerAngle: cellCornerRadius)
                    .fill(themeManager.colorInPriority(in: cycle.colorPriority))
                    .background {
                        if scheme == .dark {
                            RoundedHexagon(radius: cellSizeRadius, cornerAngle: cellCornerRadius)
                                .stroke(Color.white, lineWidth: 0.5)
                        }
                    }
                    .frame(width: cellSizeRadius * 2, height: cellSizeRadius * 2)
                Text("\(hourAndMinute)")
                    .font(.caption2)
                    .fontWeight(.bold)
            }
        }
        .sheet(isPresented: $showDetails) {
            CyclesOfDayDetailView(cycleManager: cycleManager)
                .presentationDetents([.medium, .large])
        }
    }
}


