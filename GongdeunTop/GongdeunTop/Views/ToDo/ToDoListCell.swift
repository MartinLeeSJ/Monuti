//
//  ToDoRow.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/27.
//

import SwiftUI

struct ToDoListCell: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    @State private var isEditingSheetOn: Bool = false
    
    let todo: ToDo
    let targets: [Target]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(todo.title)
                    .font(.headline)
                
                Text(todo.content)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(todo.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.vertical, 2)
                                .padding(.horizontal, 6)
                                .background(Capsule().fill(.thinMaterial))
                        }
                    }
                }
            }
            
            startingTimeContainer
            
            Button {
                isEditingSheetOn = true
            } label: {
                Image(systemName: "chevron.right")
            }
            .sheet(isPresented: $isEditingSheetOn) {
                SetToDoForm(todo: todo, targets: targets, mode: .edit) { todo in
                    
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(themeManager.componentColor(), in: RoundedRectangle(cornerRadius: 8))
    }
}


extension ToDoListCell {
    @ViewBuilder
    var startingTimeContainer: some View {
        if let timeString = todo.startingTimeString {
            Text(timeString)
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(.vertical)
                .padding(.horizontal, 8)
                .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 8))
        } else {
            EmptyView()
        }
    }
}
