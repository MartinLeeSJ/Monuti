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
            
            Button {
                isEditingSheetOn = true
            } label: {
                Image(systemName: "chevron.right")
            }
            .sheet(isPresented: $isEditingSheetOn) {
                SetToDoForm(manager: ToDoManager(todo: todo), mode: .edit) { result in
                    if case .success(let action) = result, action == .delete {
                        self.dismiss()
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(themeManager.getComponentColor(), in: RoundedRectangle(cornerRadius: 8))
    }
}
