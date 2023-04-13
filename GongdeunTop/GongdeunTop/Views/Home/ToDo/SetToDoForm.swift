//
//  AddToDoSheetView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/21.
//

import SwiftUI

enum Mode {
    case new
    case edit
}

enum Action {
    case delete
    case done
    case cancel
}

enum ToDoField: Int, Hashable, CaseIterable {
    case title
    case content
    case tag
    
    var fieldString: (title: String, fieldTitle: String, footer: String) {
        switch self {
        case .title: return ("제목", "할 일 제목", "제목은 반드시 포함되어야 하는 필수 항목입니다.")
        case .content: return ("내용", "할 일 내용", "구체적이고 명확하게 기록하면 집중도가 높아집니다.")
        case .tag: return ("태그", "태그 입력", "태그를 등록해 보세요")
        }
    }
}

struct SetToDoForm: View {
    @ObservedObject var viewModel = ToDoViewModel()
    @FocusState private var focusedField: ToDoField?
    
    var mode: Mode = .new
    var completionHandler: ((Result<Action, Error>) -> Void)?
    
    
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
                        viewModel.handleDoneTapped()
                    } label: {
                        Text(mode == .new ? "추가하기" : "수정하기")
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





struct AddToDoSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SetToDoForm()
    }
}


