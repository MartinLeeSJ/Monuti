//
//  TargetFormCell.swift
//  GongdeunTop
//
//  Created by Martin on 2023/09/04.
//

import SwiftUI

struct TargetFormCell: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding private var todo: ToDo
    private var targets: [Target]
    
    init(todo: Binding<ToDo>, targets: [Target]) {
        self._todo = todo
        self.targets = targets
    }
    
    var body: some View {
        FormContainer {
            currentTarget
            targetList
        }
    }
    
    private func findTarget(ofId id: String?) -> Target? {
        guard let id = id,
              let target = targets.first(where: { $0.id == id }) else {
            return nil
        }
        return target
    }
    
    @ViewBuilder
    private var currentTarget: some View {
        HStack(spacing: .spacing(of: .normal)) {
            Text("setToDoForm_target_title")
                .font(.headline)
                .fontWeight(.medium)
            
            if let target = findTarget(ofId: todo.relatedTarget) {
                Text(target.title)
                    .lineLimit(1)
                    .foregroundColor(Color("basicFontColor"))
            } else {
                Text("setToDoForm_target_placeholder")
                    .foregroundStyle(.tertiary)
            }
           
            Spacer()
            
            Button {
                todo.relatedTarget = nil
            } label: {
                Text("Delete")
            }
            .tint(.red)
            .opacity(todo.relatedTarget == nil ? 0 : 1)
        }
        
    }
    
    
    @ViewBuilder
    var targetList: some View {
        Divider()
        ScrollView {
            ForEach(targets, id: \.self) { target in
                Button {
                    todo.relatedTarget = target.id
                } label: {
                    HStack {
                        Group {
                            if let targetId = todo.relatedTarget, targetId == target.id {
                                Image(systemName: "largecircle.fill.circle")
                            } else {
                                Image(systemName: "circle")
                            }
                        }
                        .tint(themeManager.colorInPriority(in: .accent))
                        Text(target.title)
                            .foregroundColor(Color("basicFontColor"))
                        Spacer()
                    }
                }
                .padding(.vertical, .spacing(of: .quarter))
            }
        }
        .frame(minHeight: 30)
    }
}


