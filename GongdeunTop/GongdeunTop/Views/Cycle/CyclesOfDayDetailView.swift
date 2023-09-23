//
//  CycleListCellDetailView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/08.
//

import SwiftUI

struct CyclesOfDayDetailView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject private var cycleManager: CycleManager
    
    init(cycleManager: CycleManager) {
        self.cycleManager = cycleManager
    }
    
    private var fetchedAllTodos: Bool {
        guard !cycleManager.cycle.todos.isEmpty else { return true }
        if cycleManager.todos.isEmpty { return false }
        return true
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .spacing(of: .normal)) {
                Spacer()
                    .frame(maxHeight: .spacing(of: .normal))
                sessionsInfo()
                concetrationAssesmentInfo()
                cycleTodoList()
                cycleMemoirs()
            }
            .padding()
        }
        .task {
          cycleManager.fetchToDos()
        }
        .redacted(reason: fetchedAllTodos ? [] : .placeholder)
    }
}

// MARK: - SessionInfo Section
extension CyclesOfDayDetailView {
    private var sessionCounts: Int {
        cycleManager.cycle.sessions ?? 0
    }
    
    private func timeDescription(of time: Int?) -> String {
        guard let time = time else { return "" }
        return TimeInterval(time).todoSpentTimeString
    }
    
    @ViewBuilder
    private func sessionsInfo() -> some View {
        HStack(alignment: .top, spacing: .spacing(of: .normal)) {
            Text("\(sessionCounts) session")
                .font(.title2.bold())
            if sessionCounts > 0 {
                VStack(alignment: .leading ,spacing: .spacing(of: .normal)) {
                    Text("CyclesOfDayDetail_Concentration") +
                    Text(" \(timeDescription(of: cycleManager.cycle.concentrationSeconds))")
                    
                    Text("CyclesOfDayDetail_Rest") +
                    Text(" \(timeDescription(of: cycleManager.cycle.refreshSeconds))")
                    
                    
                    Text("CyclesOfDayDetail_Total") +
                    Text(" \(timeDescription(of: cycleManager.cycle.totalSeconds))")
                }
                .font(.footnote)
            }
        }
        Divider()
    }
}

// MARK: - Cycle Assesment Section
extension CyclesOfDayDetailView {
    @ViewBuilder
    private func concetrationAssesmentInfo() -> some View {
        HStack(spacing: .spacing(of: .normal)) {
            Text("CyclesOfDayDetail_ConcetrationAssesment")
                .font(.title2.bold())
            RoundedHexagon(radius: 15, cornerAngle: 5)
                .fill(themeManager.colorInPriority(in: cycleManager.cycle.colorPriority))
                .frame(width: 32, height: 32)
                .overlay {
                    Text(cycleManager.cycle.evaluationDescription)
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                }
        }
        
        Divider()
    }
}

// MARK: - Cycle Todo
extension CyclesOfDayDetailView {
    @ViewBuilder
    private func cycleTodoList() -> some View {
        Text("\(cycleManager.todos.count)개의 한 일")
            .font(.title2.bold())
        if !cycleManager.todos.isEmpty {
            CycleToDoList(manager: cycleManager, mode: .cyclesOfDayDetail)
                .padding()
                .background(.thinMaterial ,in: RoundedRectangle(cornerRadius: 10))
        }
    }
}

// MARK: - Cycle Memoirs
extension CyclesOfDayDetailView {
    @ViewBuilder
    private func cycleMemoirs() -> some View {
        if !cycleManager.cycle.memoirs.isEmpty {
            Divider()
            Text("CyclesOfDayDetail_Memoirs")
                .font(.title2.bold())
            Text(cycleManager.cycle.memoirs)
        }
    }
}
