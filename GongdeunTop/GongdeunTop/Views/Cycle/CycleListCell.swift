//
//  CycleListCell.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/27.
//

import SwiftUI

struct CycleListCell: View {
    @Environment(\.colorScheme) var scheme: ColorScheme
    @EnvironmentObject var themeManager: ThemeManager
    
    @StateObject var cycleManager = CycleManager()
    @State private var showDetails: Bool = false
    
    var cycle: Cycle {
        cycleManager.cycle
    }
    
    var hourAndMinute: String {
        cycle.createdAt.dateValue().formatted(
            Date.FormatStyle()
                .hour()
                .minute()
        )
        
    }
    
    var body: some View {
        Button {
            showDetails.toggle()
        } label: {

            HStack(spacing: 0) {
                Group {
                    Text("sessions\(cycle.sessions ?? 0)")
                    Text("totalTime\(cycle.minutes ?? 0)")
                }
                .font(.callout)
                
                Spacer()
                    
                
                Text("\(hourAndMinute)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.trailing, 5)
                
                
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .opacity(0.5)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background {
                    RoundedRectangle(cornerRadius: 10)
                    .fill(themeManager.colorInPriority(of: cycle.colorPriority))
            }
            .background {
                if scheme == .dark {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 0.5)
                }
            }
        }
        .padding(.top, 6)
        .padding(.horizontal, 5)
        .sheet(isPresented: $showDetails) {
            CycleListCellDetail(cycleManager: cycleManager)
                .presentationDetents([.medium, .large])
        }
    }
}


