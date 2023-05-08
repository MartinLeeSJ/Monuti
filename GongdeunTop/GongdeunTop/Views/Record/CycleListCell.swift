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
    
    @ObservedObject var cycleManager = CycleManager()
    @State private var showDetails: Bool = false
    var cycle: Cycle {
        cycleManager.cycle
    }
    
    var body: some View {
        Button {
            showDetails.toggle()
        } label: {
            let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: cycle.createdAt.dateValue())
            HStack {
                Text("\(dateComponent.hour ?? 0)시 \(dateComponent.minute ?? 0)분")
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.callout)
                    .opacity(0.5)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background {
                    RoundedRectangle(cornerRadius: 10)
                    .fill(themeManager.getColorInPriority(of: cycle.colorPriority))
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
        .task {
            cycleManager.fetchToDos()
        }
        .sheet(isPresented: $showDetails) {
            VStack {
                TextEditor(text: $cycleManager.cycle.memoirs)
                    .frame(width: 120, height: 100)
                Button("저장") {
                    cycleManager.handleUpdateButton()
                }
            }
            Text("디테일")
                .presentationDetents([.medium])
        }
    }
}


