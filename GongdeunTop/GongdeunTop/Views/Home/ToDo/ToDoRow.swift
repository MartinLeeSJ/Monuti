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
        
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(todo.title)
                    .font(.title3.bold())
                
                Text(todo.content)
                    .font(.caption)
                
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
                Button {
                    isEditingSheetOn = true
                } label: {
                    Image(systemName: "chevron.right")
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
        
        
        
    }
}