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
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject var tagManager = TagManager()
    
    @State var todo: ToDo = ToDo(createdAt: Date.now)
    @State private var isEditingTarget: Bool = false
    @FocusState private var focusedField: ToDoField?
    
    var targets: [Target]
    var mode: Mode = .add
    var onCommit: (_ todo: ToDo) -> Void
    
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
                        ToDoTitleFormCell(
                            todo: $todo,
                            focusedField: _focusedField
                        )
                        
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
                        
                        targetForm
                    }
                    .padding(.horizontal)
                }
                .navigationTitle(mode == .add ?
                                 Text("setTodoForm_title_new") :
                                 Text("setTodoForm_title_edit"))
                .navigationBarTitleDisplayMode(.inline)
                .interactiveDismissDisabled()
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            handleCloseTapped()
                        } label: {
                            Text("Cancel")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            handleDoneTapped()
                        } label: {
                            Text(mode == .add ? "Add" : "Edit")
                        }
                        .disabled(todo.title.isEmpty)
                    }
                    
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

// MARK: - Connecting Target
extension SetToDoForm {
    private func findTargetTitle(ofId id: String?) -> String {
        guard let id = id,
              let target = targets.first(where: { $0.id == id }) else {
            return String(localized: "setToDoForm_target_placeholder")
        }
        return target.title
    }
    
    @ViewBuilder
    var targetForm: some View {
        FormContainer {
            currentTarget
            if mode == .add || isEditingTarget {
                targetList
            }
        }
    }
    
    @ViewBuilder
    private var currentTarget: some View {
        HStack(spacing: .spacing(of: .normal)) {
            Text("setToDoForm_target_title")
                .font(.headline)
                .fontWeight(.medium)
            
            Text(findTargetTitle(ofId: todo.relatedTarget))
                .lineLimit(1)
                .foregroundColor(todo.relatedTarget == nil ?
                    .secondary :
                    Color("basicFontColor")
                )
            Spacer()
            
            if mode == .edit {
                Button {
                    if !isEditingTarget {
                        todo.relatedTarget = nil
                    }
                    isEditingTarget.toggle()
                } label: {
                    Text(isEditingTarget ? "Done" : "Edit")
                }
                .tint(isEditingTarget ? .blue : .red)
            }
            
        }
        
    }
    
    
    @ViewBuilder
    var targetList: some View {
        Divider()
        ScrollView {
            ForEach(targets, id: \.self) { target in
                Button {
                    todo.relatedTarget = target.id
                } label: {
                    HStack {
                        Group {
                            if let targetId = todo.relatedTarget, targetId == target.id {
                                Image(systemName: "largecircle.fill.circle")
                            } else {
                                Image(systemName: "circle")
                            }
                        }
                        .tint(themeManager.colorInPriority(in: .accent))
                        Text(target.title)
                            .foregroundColor(Color("basicFontColor"))
                        Spacer()
                    }
                }
                .padding(.vertical, .spacing(of: .quarter))
            }
        }
        .frame(minHeight: 30)
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


