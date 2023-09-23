//
//  AddToDoSheetView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/21.
//

import SwiftUI
import Combine

import FirebaseFirestore
import FirebaseAuth




// TODO: - Target 관련 로직 리팩토링
struct SetToDoForm: View {
    enum Mode {
        case add
        case edit
    }
    
    enum ToDoField: Int, Hashable, CaseIterable {
        case title
        case content
        case tag
    }
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var tagManager = TagManager()
    
    @State private var todo: ToDo = ToDo(createdAt: Date.now)
    @State private var isEditingTarget: Bool = false
    @FocusState private var focusedField: ToDoField?
    
    private var targets: [Target]
    private var mode: Mode = .add
    private var onCommit: (_ todo: ToDo) -> Void
    
    init(
        todo: ToDo = ToDo(createdAt: Date.now),
        targets: [Target],
        mode: Mode = .add,
        onCommit: @escaping (_ todo: ToDo) -> Void
    ) {
        self._todo = State(initialValue: todo)
        self.targets = targets
        self.mode = mode
        self.onCommit = onCommit
    }
    
    private func handleDoneTapped() {
        onCommit(todo)
        dismiss()
        
    }
    
    private func handleCloseTapped() {
        dismiss()
        if mode == .add {
            tagManager.decreaseCountOfTags(of: todo.tags)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.sheetBackgroundColor()
                    .ignoresSafeArea(.all)
                ScrollView {
                    VStack(spacing: .spacing(of: .long)) {
                        ToDoTitleFormCell(todo: $todo, focusedField: _focusedField)

                        if let startingTime = Binding<Date>($todo.startingTime) {
                            StartingTimeFormCell(startingTime: startingTime)
                        }
                        
                        TagFormCell(
                            todo: $todo,
                            focusedField: _focusedField,
                            tags: tagManager.tags,
                            onAddTag: {onAddTag($0)},
                            onRemoveTag: { onRemoveTag($0) }
                        )
                        
                        TargetFormCell(todo: $todo, targets: targets)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle(mode == .add ?
                             Text("setTodoForm_title_new") :
                             Text("setTodoForm_title_edit"))
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
            .toolbar {
                cancelToolbarButton()
                doneToolbarButton()
                ToolbarItemGroup(placement: .keyboard) {
                    HAlignment(alignment: .leading) {
                        Button(action: focusPreviousField) {
                            Image(systemName: "chevron.up")
                        }
                        .disabled(!canFocusPreviousField())
                        Button(action: focusNextField) {
                            Image(systemName: "chevron.down")
                        }
                        .disabled(!canFocusNextField())
                    }
                }
            }
        }
        
    }
}

// MARK: - Toolbar
extension SetToDoForm {
    @ToolbarContentBuilder
    func cancelToolbarButton() -> some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button {
                handleCloseTapped()
            } label: {
                Text("Cancel")
            }
            .tint(themeManager.colorInPriority(in: .accent))
        }
    }
    
    @ToolbarContentBuilder
    func doneToolbarButton() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                handleDoneTapped()
            } label: {
                Text(mode == .add ? "Add" : "Edit")
            }
            .tint(themeManager.colorInPriority(in: .accent))
            .disabled(todo.title.isEmpty)
        }
    }
    
}


// MARK: - Tag Action
extension SetToDoForm {
    private func onAddTag(_ tag: Tag) {
        guard !todo.tags.contains(where:{ $0 == tag.title }) else { return }
        todo.tags.append(tag.title)
        if tagManager.tags.contains(where: { $0.title == tag.title }) {
            tagManager.increaseCount(of: tag)
        } else {
            tagManager.add(tag)
        }
    }
    
    private func onRemoveTag(_ tag: Tag) {
        tagManager.decreaseCount(of: Tag(title: tag.title))
        todo.tags = todo.tags.filter { $0 != tag.title }
    }
}


// MARK: - Keyboard Focus Actions
extension SetToDoForm {
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
}



struct AddToDoSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SetToDoForm(targets: [], onCommit: {_ in})
    }
}


