//
//  DayDetailView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/08/23.
//

import SwiftUI

struct DayRecordView: View {
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject private var themeManager: ThemeManager
    
    @State private var isCompletedToDoHistorySheetPresented: Bool = false
    @State private var isNotCompletedToDoHistorySheetPresented: Bool = false
    
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
    
    private func presentCompletedToDoHistorySheet() {
        isCompletedToDoHistorySheetPresented = true
    }
    
    private func presentNotCompletedToDoHistorySheet() {
        isNotCompletedToDoHistorySheetPresented = true
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                cylecesOfDayRecords()
                
                HStack {
                    Text("완료한 할 일")
                        .font(.headline)
                    Spacer()
                    Button {
                        if !completedTodos.isEmpty {
                            presentCompletedToDoHistorySheet()
                        }
                    } label: {
                        Text("\(completedTodos.count)")
                            .padding(.horizontal, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .tint(themeManager.colorInPriority(in: .accent))
                    .disabled(completedTodos.isEmpty)
                }
                .sheet(isPresented: $isCompletedToDoHistorySheetPresented) {
                    ToDoHistoryList(.completed, todos: completedTodos)
                }
                
                HStack {
                    Text("완료하지 못한 할 일")
                        .font(.headline)
                    Spacer()
                    Button {
                        if !notCompletedTodos.isEmpty {
                            presentNotCompletedToDoHistorySheet()
                        }
                    } label: {
                        Text("\(notCompletedTodos.count)")
                            .padding(.horizontal, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .tint(themeManager.colorInPriority(in: .accent))
                    .disabled(notCompletedTodos.isEmpty)
                }
                .sheet(isPresented: $isNotCompletedToDoHistorySheetPresented) {
                    ToDoHistoryList(.notCompleted, todos: notCompletedTodos)
                }
                
                
            }
        }
        
    }
    
    @ViewBuilder
    private func cylecesOfDayRecords() -> some View {
        if !cycles.isEmpty {
            Text("집중 타이머 기록")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: .spacing(of: .normal)) {
                    ForEach(cycles, id: \.self) {
                        cycle in
                        CyclesOfDayListCell(cycle: cycle)
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
