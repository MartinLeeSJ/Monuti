//
//  AddToDoSheetView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/21.
//

import SwiftUI

enum ToDoField: Int, Hashable, CaseIterable {
    case title
    case content
    case tag
}
struct SetToDoForm: View {
    
    @ObservedObject var viewModel: ToDoViewModel
    @State private var tag: String = ""
    @FocusState private var focusedField: ToDoField?
    
    
    private func focusPreviousField() {
        focusedField = focusedField.map {
            ToDoField(rawValue: $0.rawValue - 1) ?? .tag
        }
    }
    
    private func focusNextField() {
        focusedField = focusedField.map {
            ToDoField(rawValue: $0.rawValue + 1) ?? .title
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
        return currentFocusedField.rawValue < ToDoField.allCases.count - 1
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(ToDoField.allCases, id: \.self) { fieldType in
                        ToDoFormRow(viewModel: viewModel, focusedField: $focusedField, fieldType: fieldType)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.todos.append(viewModel.todo)
                        viewModel.todo = ToDo(title: "", content: "")
                    } label: {
                        Text("추가하기")
                    }
                    .disabled(viewModel.todo.title.isEmpty)
                }
                
                
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

extension ToDoField {
    var fieldString: (title: String, fieldTitle: String, footer: String) {
        switch self {
        case .title: return ("제목", "할 일 제목", "제목은 반드시 포함되어야 하는 필수 항목입니다.")
        case .content: return ("내용", "할 일 내용", "구체적이고 명확하게 기록하면 집중도가 높아집니다.")
        case .tag: return ("태그", "태그 입력", "태그를 등록해 보세요")
        }
    }
}


struct ToDoFormRow: View {
    @ObservedObject var viewModel: ToDoViewModel
    var focusedField: FocusState<ToDoField?>.Binding
    var fieldType: ToDoField
    
    
    var text: Binding<String> {
        switch fieldType {
        case .title: return $viewModel.todo.title
        case .content: return $viewModel.todo.content
        case .tag: return $viewModel.tag
        }
    }
    
    var fieldString: (title: String, fieldTitle: String, footer: String) {
        fieldType.fieldString
    }
    
    
    
    var body: some View {
        
        VStack(spacing: 5) {
            HStack {
                Text(fieldString.title)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Divider()
                
                TextField(fieldString.fieldTitle, text: text)
                    .focused(focusedField, equals: fieldType)
                
                if fieldType == .tag {
                    Button {
                        viewModel.todo.tags.append(viewModel.tag)
                        viewModel.tag = ""
                    } label: {
                        Text("등록")
                    }
                    .disabled(viewModel.tag.isEmpty)
                }
            }
            .frame(height: 30)
            .padding(.vertical , 5)
            .padding(.horizontal, 10)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.white)
                    
            }
            
            Divider()
            
            HAlignment(alignment: .leading) {
                Text(fieldString.footer)
                    .foregroundColor(.gray)
                    .font(.caption2)
            }
            .frame(height: 5)
            
            if !viewModel.todo.tags.isEmpty && fieldType == .tag {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.todo.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 6)
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
        
        .padding()
        .background {
//            RoundedRectangle(cornerRadius: 15)
            Rectangle()
                .foregroundColor(.GTDenimBlue)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        
        
    }
}

struct AddToDoSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SetToDoForm(viewModel: ToDoViewModel())
    }
}



