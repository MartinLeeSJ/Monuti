//
//  AddToDoSheetView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/21.
//

import SwiftUI

struct SetToDoForm: View {
    enum Field: Int, Hashable, CaseIterable {
        case title
        case content
        case tag
    }
    
    @ObservedObject var viewModel: ToDoViewModel
    @State private var tag: String = ""
    @FocusState private var focusedField: Field?
    
    
    private func focusPreviousField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue - 1) ?? .tag
        }
    }
    
    private func focusNextField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue + 1) ?? .title
        }
    }
    
    private func canFocusPreviousField() -> Bool {
        guard let currentFocusedField = focusedField else {
            return false
        }
        return currentFocusedField.rawValue > 0
    }
    
    private func canFocusNextField() -> Bool {
        guard let currentFocusedField = focusedField else {
            return false
        }
        return currentFocusedField.rawValue < Field.allCases.count - 1
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("제목")
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        Divider()
                        
                        TextField("할 일 제목", text: $viewModel.todo.title)
                            .focused($focusedField, equals: .title)
                        
                    }
                } footer: {
                    HAlignment(alignment: .trailling) {
                        Text("제목은 필수 항목입니다.")
                            .font(.caption2)
                    }
                }
                
                Section {
                    HStack {
                        Text("내용")
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        Divider()
                        
                        TextField("할 일 내용", text: $viewModel.todo.content)
                            .focused($focusedField, equals: .content)
                    }
                }
                
                Section {
                    
                    HStack {
                        Text("태그")
                            .font(.headline)
                            .fontWeight(.medium)
                            .padding(.vertical, 5)
                        
                        Divider()
                        
                        TextField("태그", text: $tag)
                            .focused($focusedField, equals: .tag)
                        
                        Button {
                            viewModel.todo.tags.append(tag)
                            tag = ""
                        } label: {
                            Text("등록")
                        }
                        .disabled(tag.isEmpty)
                    }
                    
                    if !viewModel.todo.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.todo.tags, id: \.self) {tag in
                                    Text(tag)
                                        .font(.caption)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 4)
                                        .background(Capsule().fill(.orange))
                                        .overlay(alignment: .topTrailing) {
                                            Button {
                                                
                                            } label: {
                                                Image(systemName: "x.circle.fill")
                                            }
                                            .tint(.black)
                                            .offset(x: 10, y : -10)

                                        }
                                }
                            }
                            .frame(height: 45)
                            .padding(.trailing, 60)
                        }
                    }
                }
                
                HAlignment(alignment: .center) {
                    Button {
                        viewModel.todos.append(viewModel.todo)
                        viewModel.todo = ToDo(title: "", content: "")
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("추가하기")
                        }
                    }
                    .disabled(viewModel.todo.title.isEmpty)
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button(action: focusPreviousField) {
                        Image(systemName: "chevron.up")
                    }
                    .disabled(!canFocusPreviousField())
                }
                
                ToolbarItem(placement: .keyboard) {
                    Button(action: focusNextField) {
                        Image(systemName: "chevron.down")
                    }
                    .disabled(!canFocusNextField())
                }
            }
        }
        
    }
}

struct AddToDoSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SetToDoForm(viewModel: ToDoViewModel())
    }
}



