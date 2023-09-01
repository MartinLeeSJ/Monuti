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
                    .overlay(alignment: .topTrailing) {
                        Image(systemName: "staroflife.fill")
                            .font(.system(size: 6))
                            .foregroundColor(.red)
                            .offset(x: 8)

                    }
                
                TextField(String(localized: "todo_title"), text: $todo.title)
                    .focused($focusedField, equals: .title)
                    .onReceive(Just(todo.title)) { _ in
                        if titleCharacterLimit < todo.title.count {
                            todo.title = String(todo.title.prefix(titleCharacterLimit))
                        }
                    }
                
                Text("\(todo.title.count)/\(titleCharacterLimit)")
                    .font(.caption)
                    .fixedSize()
                    .padding(.trailing, 8)
            }
            
            Divider()
            
            HStack(alignment: .bottom, spacing: 12) {
                Text("content")
                    .font(.headline)
                    .fontWeight(.medium)
                
                TextField(String(localized: "todo_content"), text: $todo.content)
                    .focused($focusedField, equals: .content)
                    .onReceive(Just(todo.content)) { _ in
                        if contentCharacterLimit < todo.content.count {
                            todo.content = String(todo.content.prefix(contentCharacterLimit))
                        }
                    }
                
                Text("\(todo.content.count)/\(contentCharacterLimit)")
                    .font(.caption)
                    .fixedSize()
                    .padding(.trailing, 8)
            }
        } footer: {
            Text("todo_content_footer")
        }
    }
}

