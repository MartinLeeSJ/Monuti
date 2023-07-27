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
    @StateObject var tagStore = TagStore()
    @Binding var todo: ToDo
    @FocusState var focusedField: SetToDoForm.ToDoField?
    @State private var tagText: String = ""
    @State private var filteredTags: [Tag] = []
    private let db = Firestore.firestore()

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
        .onAppear {
            tagStore.subscribeTags()
        }
        .onDisappear {
            tagStore.unsubscribeTags()
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

extension TagForm {
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


