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
        case .title: return (String(localized: "title"),
                             String(localized: "todo_title"),
                             String(localized: "todo_title_footer"))
        case .content: return (String(localized: "content"),
                               String(localized: "todo_content"),
                               String(localized: "todo_content_footer"))
        case .tag: return (String(localized: "tag"),
                           String(localized: "todo_tag"),
                           String(localized: "todo_tag_footer"))
        }
    }
}

struct SetToDoForm: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var manager = ToDoManager()
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
    
    private func handleDoneTapped() {
        manager.handleDoneTapped()
        if mode == .edit {
            dismiss()
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(ToDoField.allCases, id: \.self) { fieldType in
                        ToDoFormCell(viewModel: manager, focusedField: $focusedField, fieldType: fieldType)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        handleDoneTapped()
                    } label: {
                        Text(mode == .new ? "Add" : "Edit")
                    }
                    .disabled(manager.todo.title.isEmpty)
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


