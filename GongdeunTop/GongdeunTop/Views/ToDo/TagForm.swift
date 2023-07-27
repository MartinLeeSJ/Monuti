//
//  TagForm.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/27.
//

import SwiftUI
import Combine

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


struct TagForm: View {
    @StateObject var tagManager = TagManager()
    @Binding var todo: ToDo
    @FocusState var focusedField: SetToDoForm.ToDoField?
    @State private var tag: Tag = Tag(title: "", count: 0)
    @State private var filteredTags: [Tag] = []

    var body: some View {
        VStack {
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
            if !todo.tags.isEmpty {
                tagScroll
            }
        }
      
    }
}


extension TagForm {
    var tagLimit: Int {
        5
    }
    
    var tagCharacterLimit: Int {
        20
    }
    
    var canAddMoreTag: Bool {
        todo.tags.count < tagLimit
    }
    
    private var tagFormTitle: some View {
        Text("tag")
            .font(.headline)
            .fontWeight(.medium)
    }
    
    private var tagFormTextField: some View {
        TextField(String(localized: "todo_tag"), text: $tag.title)
            .focused($focusedField, equals: .tag)
            .onChange(of: tag.title) { string in
                filteredTags = tagManager.tags.filter { $0.title.localizedCaseInsensitiveContains(string) }
            }
            .onReceive(Just(tag.title)) { _ in
                if tag.title.count > tagCharacterLimit {
                    tag.title = String(tag.title.prefix(tagCharacterLimit))
                }
            }
    }
    
    private var tagFormCharacterLimitLabel: some View {
        Text("\(tag.title.count)/\(tagCharacterLimit)")
            .font(.caption)
            .fixedSize()
    }
    
    private var addTagButton: some View {
        Button {
            handleAddTagButton()
        } label: {
            Text("등록")
        }
        .disabled(tag.title.isEmpty)
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
                                            removeTagInTodo(tagTitle: tagTitle)
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

extension TagForm {
    private func handleAddTagButton() {
        if tagManager.tags.contains(where: { $0.title == tag.title }) {
            tagManager.increaseCount(of: tag)
        } else {
            tagManager.add(tag)
        }
        
        todo.tags.append(tag.title)
        tag.title = ""
    }
    
    private func removeTagInTodo(tagTitle: String) {
        tagManager.decreaseCount(of: Tag(title: tagTitle, count: 0))
        todo.tags = todo.tags.filter { $0 != tagTitle }
    }
    
    
    private func handleTagListElementTapped(title: String) {
        tag.title = title
        handleAddTagButton()
        filteredTags = []
    }
}


