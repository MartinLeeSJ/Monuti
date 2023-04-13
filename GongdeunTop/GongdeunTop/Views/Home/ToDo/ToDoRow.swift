//
//  ToDoRow.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/27.
//

import SwiftUI

struct ToDoRow: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isEditingSheetOn: Bool = false
    
    let todo: ToDo
    
    var body: some View {
        
        Button {
            isEditingSheetOn = true
        } label: {
            HAlignment(alignment: .leading) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(todo.title)
                        .font(.headline)
                        .foregroundColor(.black)
                    Text(todo.content)
                        .font(.callout)
                        .foregroundColor(.white)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(todo.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 2)
                                    .padding(.horizontal, 6)
                                    .background(Capsule().fill(Color.GTDenimNavy))
                            }
                        }
                    }
                }
                if todo != .placeholder {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                }
            }
            .padding(12)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.GTDenimBlue)
            }
        }
        .sheet(isPresented: $isEditingSheetOn) {
            SetToDoForm(viewModel: ToDoViewModel(todo: todo), mode: .edit) { result in
                if case .success(let action) = result, action == .delete {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        
    }
}
