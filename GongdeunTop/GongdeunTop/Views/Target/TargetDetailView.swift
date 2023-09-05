//
//  TargetDetailView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/06/12.
//

import SwiftUI

struct TargetDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var manager: TargetDetailManager
    private let target: Target
    
    init(target: Target) {
        self.target = target
        self._manager = StateObject(wrappedValue: TargetDetailManager(target: target))
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: .spacing(of: .long)) {
                titles
                termInfo()
                achievementInfo()
                completedTodos
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward.circle.fill")
                }
                .tint(themeManager.colorInPriority(in: .accent))
            }
        }
    }
}

// MARK: - Titles
extension TargetDetailView {
    @ViewBuilder
    var titles: some View {
        VStack(alignment: .leading, spacing: .spacing(of: .normal)) {
            Text(target.title)
                .font(.title)
                .fontWeight(.bold)
            Text(target.subtitle)
                .font(.title3)
                .fontWeight(.semibold)
            Divider()
        }
    }
}

// MARK: - Term Info
extension TargetDetailView {
    
    private func termInfo() -> some View {
        VStack(alignment: .leading, spacing: .spacing(of: .normal)) {
            termText
            termGraph
        }
    }
    
    private var termText: some View {
        HStack {
            Text("targetDetail_term")
                .font(.title3.bold())
            Divider()
            
            Text(target.startDateString)
            Text("~")
            Text(target.dueDateString)
        }
    }
    
    @ViewBuilder
    private var termGraph: some View {
        Rectangle()
            .fill(.tertiary)
            .frame(height: 50)
            .overlay(alignment: .leading) {
                GeometryReader { geo in
                    let leftDayRatio = CGFloat(target.dayLeftUntilDueDate) / CGFloat(target.daysFromStartToDueDate)
                    let leftDayWidth: CGFloat = geo.size.width * leftDayRatio
                    Rectangle()
                        .frame(width: leftDayWidth)
                        .foregroundColor(themeManager.colorInPriority(in: .accent))
                }
            }
            .clipShape(Capsule())
            .overlay {
                HAlignment(alignment: .center) {
                    HStack(spacing: .spacing(of: .quarter)) {
                        Text("\(target.dayLeftUntilDueDate)")
                        Text("/")
                        Text("\(target.daysFromStartToDueDate)")
                        Text(target.dayLeftUntilDueDate > 1 ? "targetDetail_days" : "targetDetail_day")
                    }
                    .font(.headline)
                    .padding(.spacing(of: .quarter))
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                }
            }
            
        
    }
}

// MARK: - Achievement Info
extension TargetDetailView {
    
    private func achievementInfo() -> some View {
        VStack(alignment: .leading, spacing: .spacing(of: .normal)) {
            Text("target_completed")
                .font(.title3.bold())
            HAlignment(alignment: .center) {
                AchievementHexagon(radius: UIScreen.main.bounds.width / 4,
                                   achievementRate: target.achievementRate,
                                   color: themeManager.colorInPriority(in: .accent))
            }
        }
    }
    
    
    private var completedTodos: some View {
        VStack(alignment: .leading) {
            ForEach(0..<manager.completedTodo.count, id: \.self) { index in
                ToDoInfoCell(todo: manager.completedTodo[index])
                if index != manager.completedTodo.endIndex - 1 {
                    Divider()
                }
            }
        }
        .padding([.leading, .vertical])
        .background(themeManager.sheetBackgroundColor(),
                    in: RoundedRectangle(cornerRadius: 10))
        .opacity(manager.completedTodo.isEmpty ? 0 : 1)
    }
}

struct TargetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let target = Target(title: "Sample", subtitle: "This is an sample", createdAt: .now, startDate: .now, dueDate: Date.distantFuture, todos: [], memoirs: "")
        TargetDetailView(target: target)
            .environmentObject(ThemeManager())
    }
}

