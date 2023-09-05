//
//  ToDoTitleFormCell.swift
//  GongdeunTop
//
//  Created by Martin on 2023/09/01.
//

import SwiftUI
import Combine

struct ToDoTitleFormCell: View {
    @Binding var todo: ToDo
    @FocusState var focusedField: SetToDoForm.ToDoField?
    
    private var titleCharacterLimit: Int {
        return 35
    }
    
    private var contentCharacterLimit: Int {
        return 50
    }
    
    var body: some View {
        TextFieldFormContainer {
            HStack(alignment: .bottom, spacing: .spacing(of: .normal)) {
                Text("title")
                    .font(.headline)
                    .fontWeight(.medium)
                    .requiredMark()
                
                TextField(String(localized: "todo_title"), text: $todo.title)
                    .focused($focusedField, equals: .title)
                    .textfieldLimit(text: $todo.title, limit: titleCharacterLimit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
            }
            .onTapGesture {
                focusedField = .title
            }
            
            Divider()
            
            HStack(alignment: .bottom, spacing: .spacing(of: .normal)) {
                Text("content")
                    .font(.headline)
                    .fontWeight(.medium)
                
                TextField(String(localized: "todo_content"), text: $todo.content)
                    .focused($focusedField, equals: .content)
                    .textfieldLimit(text: $todo.content, limit: contentCharacterLimit)
            }
            .onTapGesture {
                focusedField = .content
            }
            
        } footer: {
            Text("todo_content_footer")
        }
    }
}

