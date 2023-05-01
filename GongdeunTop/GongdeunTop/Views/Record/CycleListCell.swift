//
//  CycleListCell.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/27.
//

import SwiftUI

struct CycleListCell: View {
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
            .padding(.vertical, 8)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.GTPastelBlue)
            }
        }
        .padding(.top, 6)
        .task {
            cycleManager.fetchToDos()
        }
        .sheet(isPresented: $showDetails) {
            Text("디테일")
                .presentationDetents([.medium])
        }
    }
}


