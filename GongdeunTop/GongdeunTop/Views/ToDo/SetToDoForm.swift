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





struct SetToDoForm: View {
    enum Mode {
        case add
        case edit
    }
    
    enum ToDoField: Int, Hashable, CaseIterable {
        case title
        case content
        case tag
        case target
    }
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    
    @State var todo: ToDo = .placeholder
    var targets: [Target]
 
    @StateObject var tagStore = TagStore()
    
    @State private var tagText: String = ""
    @State private var filteredTags: [Tag] = []

    @State private var isEditingTarget: Bool = false
    
    
    @FocusState private var focusedField: ToDoField?
    
    var mode: Mode = .add
    var onCommit: (_ todo: ToDo) -> Void
    private let db = Firestore.firestore()
    
    
    
    private func handleDoneTapped() {
        onCommit(todo)
        dismiss()
        
    }
    
    private func handleCloseTapped() {
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.sheetBackgroundColor()
                    .ignoresSafeArea(.all)
                ScrollView {
                    VStack(spacing: 32) {
                        titleAndContentTextField
                        startingTimeForm
                        tagForm
                        if !todo.tags.isEmpty {
                            tagScroll
                        }
                        targetForm
                    }
                    .padding(.horizontal)
                }
                .navigationTitle(mode == .add ?
                                 Text("setTodoForm_title_new") :
                                 Text("setTodoForm_title_edit"))
                .navigationBarTitleDisplayMode(.inline)
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

// MARK: - Title And Content
extension SetToDoForm {
    private var titleCharacterLimit: Int {
        return 35
    }
    
    private var contentCharacterLimit: Int {
        return 50
    }
    
    @ViewBuilder
    var titleAndContentTextField: some View {
        TextFieldFormContainer {
            HStack(alignment: .bottom, spacing: 12) {
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

// MARK: - Time
extension SetToDoForm {
    @ViewBuilder
    var startingTimeForm: some View {
        FormContainer {
            if let dateBinding = Binding<Date>($todo.startingTime) {
                    DatePicker(
                        "setTodoForm_startingTimeForm_datePickerTitle",
                        selection: dateBinding,
                        displayedComponents: [.hourAndMinute]
                    )
            } else {
                HStack {
                    Text("setTodoForm_startingTimeForm_timeIsNil")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                    Spacer()
                    Button {
                        todo.startingTime = Date.now
                    } label: {
                        Text("setTodoForm_startingTimeForm_setTimeButtonLabel")
                            .font(.caption2)
                    }
                }
            }
            if todo.startingTime != nil {
                Divider()
                Button {
                    todo.startingTime = nil
                } label: {
                    Text("setTodoForm_startingTimeForm_donotSetTime")
                        .font(.caption2)
                }
                .tint(.red)
            }
        }
    }
}

// MARK: - Tag
extension SetToDoForm {
    var tagLimit: Int {
        5
    }
    
    var tagCharacterLimit: Int {
        20
    }
    
    var canAddMoreTag: Bool {
        todo.tags.count < tagLimit
    }
    
    @ViewBuilder
    var tagForm: some View {
        FormContainer {
            HStack(alignment: .bottom, spacing: 12){
                tagFormTitle
                tagFormTextField
                tagFormCharacterLimitLabel
                addTagButton
            }
            
            if !filteredTags.isEmpty && canAddMoreTag {
                tagSearchList
            }
        } footer: {
            Text("todo_tag_footer")
        }
        .onAppear {
            tagStore.subscribeTags()
        }
        .onDisappear {
            tagStore.unsubscribeTags()
        }
    }
    private var tagFormTitle: some View {
        Text("tag")
            .font(.headline)
            .fontWeight(.medium)
    }
    
    private var tagFormTextField: some View {
        TextField(String(localized: "todo_tag"), text: $tagText)
            .focused($focusedField, equals: .tag)
            .onChange(of: tagText) { string in
                filteredTags = tagStore.tags.filter { $0.title.localizedCaseInsensitiveContains(string) }
            }
            .onReceive(Just(tagText)) { _ in
                if tagText.count > tagCharacterLimit {
                    tagText = String(tagText.prefix(tagCharacterLimit))
                }
            }
    }
    
    private var tagFormCharacterLimitLabel: some View {
        Text("\(tagText.count)/\(tagCharacterLimit)")
            .font(.caption)
            .fixedSize()
    }
    
    private var addTagButton: some View {
        Button {
            handleAddTagButton()
        } label: {
            Text("등록")
        }
        .disabled(tagText.isEmpty)
        .disabled(!canAddMoreTag)
    }
    
    @ViewBuilder
    var tagSearchList: some View {
        Divider()
        ScrollView {
            ForEach(filteredTags, id: \.self) { tag in
                HAlignment(alignment: .leading) {
                    Button {
                        handleTagListElementTapped(title: tag.title)
                    } label: {
                        HStack {
                            Image(systemName: "magnifyingglass.circle")
                                .opacity(0.5)
                            Text(tag.title)
                        }
                    }
                    .tint(Color("basicFontColor"))
                }
                .padding(.vertical, 4)
            }
        }
        .frame(minHeight: 30)
    }
    
    var tagScroll: some View {
        FormContainer {
            HStack(alignment: .bottom) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 18) {
                        ForEach(todo.tags, id: \.self) { tagTitle in
                            Text(tagTitle)
                                .font(.caption)
                                .padding(.vertical, 2)
                                .padding(.horizontal, 6)
                                .background(.thinMaterial, in: Capsule())
                                .background {
                                    HAlignment(alignment: .trailling) {
                                        Button {
                                            deleteTag(title: tagTitle)
                                        } label: {
                                            Image(systemName: "trash.fill")
                                                .foregroundColor(.white)
                                                .font(.caption)
                                                .padding(2)
                                                .background {
                                                    Circle()
                                                        .fill(Color.black)
                                                }
                                        }
                                    }
                                    .background(Capsule().fill(Color.black))
                                    .offset(x: 15)
                                }
                        }
                    }
                    .padding(.trailing, 60)
                }
                Text("\(todo.tags.count)/\(tagLimit)")
                    .font(.caption)
                    .fixedSize()
            }
        }
        
    }
}

// MARK: - Tag Actions
extension SetToDoForm {
    private func handleAddTagButton() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard !todo.tags.contains(where: { $0 == tagText }) else { return }
        
        let tagRef = db.collection("Members").document(uid).collection("Tag").document(tagText)
        
        if tagStore.tags.contains(where: { $0.title == tagText }) {
            updateTagCount(of: tagRef)
        } else {
            addTag(at: tagRef)
        }
        
        todo.tags.append(tagText)
        tagText = ""
        
    }
    
    private func updateTagCount(of tagRef: DocumentReference) {
        tagRef.updateData(["count" : FieldValue.increment(Int64(1))])
    }
    
    private func addTag(at tagRef: DocumentReference) {
        tagRef.setData([
            "title" : tagText,
            "count" : 1
        ])
    }
    
    private func deleteTag(title: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let tagRef = db.collection("Members").document(uid).collection("Tag").document(title)
        
        tagRef.updateData(["count" : FieldValue.increment(Int64(-1))])
        todo.tags = todo.tags.filter { $0 != title }
    }
    
    
    private func handleTagListElementTapped(title: String) {
        tagText = title
        handleAddTagButton()
        filteredTags = []
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

// MARK: - Connecting Target
extension SetToDoForm {
    private func findTargetTitle(ofId id: String?) -> String {
        guard let id = id, let target = targets.first(where: { $0.id == id }) else { return String(localized: "setToDoForm_target_placeholder") }
        return target.title
    }
    
    @ViewBuilder
    var targetForm: some View {
        FormContainer {
            currentTarget
            if todo.id == nil || isEditingTarget {
                targetList
            }
        }
    }
    
    @ViewBuilder
    var targetFormTitle: some View {
        Text("setToDoForm_target_title")
            .font(.headline)
            .fontWeight(.medium)
    }
    
    @ViewBuilder
    private var currentTarget: some View {
        HStack(spacing: 12) {
            targetFormTitle
            
            Text(findTargetTitle(ofId: todo.relatedTarget))
                .lineLimit(1)
                .foregroundColor(todo.relatedTarget == nil ?
                    .black.opacity(0.2) :
                    Color("basicFontColor")
                )
            Spacer()
            
            if mode == .edit {
                Button {
                    if isEditingTarget {
                      isEditingTarget = false
                    } else {
                        todo.relatedTarget = nil
                        isEditingTarget = true
                    }
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
                HStack {
                    Button {
                        todo.relatedTarget = target.id
                    } label: {
                        HStack {
                            if let targetId = todo.relatedTarget, targetId == target.id {
                                Image(systemName: "largecircle.fill.circle")
                                    .tint(themeManager.colorInPriority(of: .accent))
                            } else {
                                Image(systemName: "circle")
                                    .tint(themeManager.colorInPriority(of: .accent))
                            }
                            Text(target.title)
                            Spacer()
                        }
                    }
                    .tint(Color("basicFontColor"))
                }
                .padding(.vertical, 4)
            }
        }
        .frame(minHeight: 30)
    }
    
    
}




struct AddToDoSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SetToDoForm(targets: [], onCommit: {_ in})
    }
}


