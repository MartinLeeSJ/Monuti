//
//  ToDoFormRow.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/12.
//

import SwiftUI

import FirebaseFirestore
import FirebaseAuth

struct ToDoFormRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject var tagStore = TagStore()
    @ObservedObject var viewModel: ToDoManager
    
    @Environment(\.colorScheme) var scheme: ColorScheme
    
    @State private var tagText: String = ""
    @State private var filteredTags: [Tag] = []
    
    var focusedField: FocusState<ToDoField?>.Binding
    var fieldType: ToDoField
    private let db = Firestore.firestore()
    
    
    var text: Binding<String> {
        switch fieldType {
        case .title: return $viewModel.todo.title
        case .content: return $viewModel.todo.content
        case .tag: return $tagText
        }
    }
    
    var fieldString: (title: String, fieldTitle: String, footer: String) {
        fieldType.fieldString
    }
    
    var body: some View {
        
        VStack(spacing: 5) {
            textInput
            
            footer
            
            if fieldType == .tag && !viewModel.todo.tags.isEmpty {
                tagScroll
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(themeManager.getColorInPriority(of: .accent))
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .onAppear {
            if fieldType == .tag {
                tagStore.subscribeTags()
            }
        }
        .onDisappear {
            if fieldType == .tag {
                tagStore.unsubscribeTags()
            }
        }
        
    }
}

extension ToDoFormRow {
    var textInput: some View {
        VStack {
            HStack {
                Text(fieldString.title)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Divider()
                
                TextField(fieldString.fieldTitle, text: text)
                    .focused(focusedField, equals: fieldType)
                    .onChange(of: tagText) { string in
                        if fieldType == .tag {
                            filteredTags = tagStore.tags.filter { $0.title.localizedCaseInsensitiveContains(string) }
                        }
                    }
                
                if fieldType == .tag {
                    addTagButton
                }
            }
            if fieldType == .tag && !filteredTags.isEmpty {
                tagSearchList
            }
        }
        .padding(.vertical , 10)
        .padding(.horizontal, 10)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(scheme == .light ? .white : .black)
        }
        .padding(.bottom , 5)
    }
    
 
    
    
    var footer: some View {
        HAlignment(alignment: .leading) {
            Text(fieldString.footer)
                .foregroundColor(.white)
                .font(.caption2)
        }
        .frame(height: 5)
    }
    
    
}

// MARK: - Tag
extension ToDoFormRow {
    private func handleAddTagButton() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard !viewModel.todo.tags.contains(where: { $0 == tagText }) else { return }
        
        let tagRef = db.collection("Members").document(uid).collection("Tag").document(tagText)
        
        if tagStore.tags.contains(where: { $0.title == tagText }) {
            updateTagCount(of: tagRef)
        } else {
            addTag(at: tagRef)
        }
        
        viewModel.todo.tags.append(tagText)
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
        viewModel.todo.tags = viewModel.todo.tags.filter { $0 != title }
    }
    
    
    private func handleTagListElementTapped(title: String) {
        tagText = title
        handleAddTagButton()
        filteredTags = []
    }
    
    
    var addTagButton: some View {
        Button {
            handleAddTagButton()
        } label: {
            Text("등록")
        }
        .disabled(tagText.isEmpty)
    }
    
    var tagSearchList: some View {
        Group {
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
                        .tint(scheme == .light ? .black : .white)
                    }
                    .padding(.vertical, 4)
                }
            }
            .frame(minHeight: 30)
        }
        
        
    }
    
    var tagScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 18) {
                ForEach(viewModel.todo.tags, id: \.self) { tagTitle in
                    Text(tagTitle)
                        .font(.caption)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 6)
                        .background(Capsule().fill(themeManager.getColorInPriority(of: .accent)))
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
            .frame(height: 45)
            .padding(.trailing, 60)
        }
    }
}

