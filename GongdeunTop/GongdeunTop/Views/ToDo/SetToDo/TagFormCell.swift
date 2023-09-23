//
//  TagFormCell.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/27.
//

import SwiftUI
import Combine

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift




struct TagFormCell: View {
    @Binding var todo: ToDo
    @FocusState var focusedField: SetToDoForm.ToDoField?
    
    @State private var tag: Tag = Tag(title: "", count: 0)
    @State private var filteredTags: [Tag] = []
    
    var tags: [Tag]
    var onAddTag: (_ tag: Tag) -> Void
    var onRemoveTag: (_ tag: Tag) -> Void

    var body: some View {
            FormContainer {
                HStack(alignment: .bottom, spacing: .spacing(of: .normal)){
                    tagFormTitle
                    tagFormTextField
                    addTagButton
                }
                
                if !filteredTags.isEmpty && canAddMoreTag {
                    tagSearchList
                }
                
                if !todo.tags.isEmpty {
                    Divider()
                    tagScroll
                        .padding(.top, .spacing(of: .normal))
                }
                
            } footer: {
                Text("todo_tag_footer")
                    .opacity(todo.tags.isEmpty ? 1 : 0)
            }
    }
}


extension TagFormCell {
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
                filteredTags = tags.filter { $0.title.localizedCaseInsensitiveContains(string) }
            }
            .textfieldLimit(text: $tag.title, limit: tagCharacterLimit)
          
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
                                .fixedSize(horizontal: true, vertical: true)
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

extension TagFormCell {
    private func handleAddTagButton() {
        onAddTag(tag)
        tag.title = ""
    }
    
    private func removeTagInTodo(tagTitle: String) {
        onRemoveTag(Tag(title: tagTitle, count: 0))
    }
    
    
    private func handleTagListElementTapped(title: String) {
        tag.title = title
        handleAddTagButton()
        filteredTags = []
    }
}


