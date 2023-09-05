//
//  TargetDetailView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/06/12.
//

import SwiftUI

struct TargetDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var manager: TargetDetailManager
    private let target: Target
    
    init(target: Target) {
        self.target = target
        self._manager = StateObject(wrappedValue: TargetDetailManager(target: target))
        
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 16) {
                titles
                termInfo
                achievementInfo
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
        Text(target.title)
            .font(.title)
            .fontWeight(.bold)
        Text(target.subtitle)
            .font(.title3)
            .fontWeight(.semibold)
        Divider()
    }
}

// MARK: - Term Info
extension TargetDetailView {
    @ViewBuilder
    var termInfo: some View {    
        termText
        termGraph
    }
    
    var termText: some View {
        HStack {
            Text("targetDetail_term")
                .font(.headline)
            Divider()
            
            Text(target.startDateString)
            Text("~")
            Text(target.dueDateString)
        }
    }
    
    @ViewBuilder
    var termGraph: some View {
        Rectangle()
            .frame(height: 50)
            .foregroundColor(themeManager.colorInPriority(in: .weak))
            .overlay(alignment: .leading) {
                GeometryReader { geo in
                    let leftDayRatio = CGFloat(target.dayLeftUntilDueDate) / CGFloat(target.daysFromStartToDueDate)
                    let leftDayWidth: CGFloat = geo.size.width * leftDayRatio
                    Rectangle()
                        .frame(width: leftDayWidth)
                        .foregroundColor(themeManager.colorInPriority(in: .solid))
                }
            }
            .clipShape(Capsule())
            .overlay {
                HAlignment(alignment: .center) {
                    HStack(spacing: 4) {
                        Text("\(target.dayLeftUntilDueDate)")
                        Text("/")
                        Text("\(target.daysFromStartToDueDate)")
                    }
                    .font(.headline)
                    .padding(4)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                }
            }
            
        
    }
}

// MARK: - Achievement Info
extension TargetDetailView {
    @ViewBuilder
    var achievementInfo: some View {
        Text("target_completed")
            .font(.headline)
        HAlignment(alignment: .center) {
            AchievementHexagon(radius: UIScreen.main.bounds.width / 4,
                               achievementRate: target.achievementRate,
                               color: themeManager.colorInPriority(in: .accent))
        }
        
    }
    
    @ViewBuilder
    var completedTodos: some View {
        VStack(alignment: .leading) {
            ForEach(0..<manager.completedTodo.count, id: \.self) { index in
                ToDoInfoCell(todo: manager.completedTodo[index])
                if index != manager.completedTodo.endIndex - 1 {
                    Divider()
                }
            }
        }
        .padding([.leading, .vertical])
        .background(themeManager.colorInPriority(in: .background),
                    in: RoundedRectangle(cornerRadius: 10))
    }
}

struct TargetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let target = Target(title: "Sample", subtitle: "This is an sample", createdAt: .now, startDate: .now, dueDate: Date.distantFuture, todos: [], memoirs: "")
        TargetDetailView(target: target)
            .environmentObject(ThemeManager())
    }
}

