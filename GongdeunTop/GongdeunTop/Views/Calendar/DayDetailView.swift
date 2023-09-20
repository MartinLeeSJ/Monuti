//
//  DayDetailView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/08/23.
//

import SwiftUI

struct DayDetailView: View {
    private let cycles: [Cycle]
    private let completedTodos: [ToDo]
    private let notCompletedTodos: [ToDo]
    
    init(
        cycles: [Cycle],
        completedTodos: [ToDo],
        notCompletedTodos: [ToDo]
    ) {
        self.cycles = cycles
        self.completedTodos = completedTodos
        self.notCompletedTodos = notCompletedTodos
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            timerRecords()
            Divider()
            HStack {
                Text("완료한 할 일")
                    .font(.headline)
                Spacer()
                Button {
                    
                } label: {
                    Text("\(completedTodos.count)")
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
            }
            Divider()
            HStack {
                Text("완료하지 못한 할 일")
                    .font(.headline)
                Spacer()
                Button {
                    
                } label: {
                    Text("\(notCompletedTodos.count)")
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
            }
            Spacer()
        }
        
    }
    
    @ViewBuilder
    private func timerRecords() -> some View {
        if !cycles.isEmpty {
            Text("집중 타이머 기록")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: .spacing(of: .normal)) {
                    ForEach(cycles, id: \.self) {
                        cycle in
                        CycleListCell(cycle: cycle)
                            .tint(Color("basicFontColor"))
                    }
                }
            }
            .padding(8)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))
            .transition(.move(edge: .leading).animation(.linear(duration: 0.3)))
        }
    }
}

//struct DayDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DayDetailView(cycles: Cycle.previews)
//    }
//}
