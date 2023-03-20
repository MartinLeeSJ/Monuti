//
//  ToDoView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI



struct ToDoView: View {
    @ObservedObject var viewModel: ToDoViewModel
    @State private var tag: String = ""
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            
            VStack {
                ScrollView(showsIndicators: false) {
                    ForEach(viewModel.todos, id: \.self) { todo in
                        VStack {
                            DisclosureGroup {
                                HAlignment(alignment: .leading) {
                                    Text(todo.content)
                                        .font(.callout)
                                        .foregroundColor(.gray)
                                }
                            } label: {
                                Text(todo.title)
                                    .font(.headline)
                                    .foregroundColor(.black)
                            }
                            Divider()
                        }
                        .padding(.vertical, 2)
                    }
                }
                .padding()
                .frame(width: width, height: height * 0.35)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.GTyellow)
                }
                
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("제목")
                                .font(.headline)
                                .fontWeight(.medium)
                            Divider()
                            
                            TextField("할 일 제목", text: $viewModel.todo.title)
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        
                        Spacer()
                        
                        HStack {
                            Text("내용")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            Divider()
                            
                            TextField("할 일 내용", text: $viewModel.todo.content)
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        
                        Spacer()
                        
                        HStack {
                            Text("태그")
                                .font(.headline)
                                .fontWeight(.medium)
                                .padding(.vertical, 5)
                            
                            Divider()
                            
                            TextField("태그", text: $tag)
                            
                            Button {
                                viewModel.todo.tags.append(tag)
                                tag = ""
                            } label: {
                                Text("등록")
                            }
                            .disabled(tag.isEmpty)
                           
                            
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        
                        Spacer()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.todo.tags, id: \.self) {tag in
                                    Text(tag)
                                        .font(.caption)
                                        .padding(.vertical, 2)
                                        .padding(.horizontal, 4)
                                        .background(Capsule().fill(.green))
                                }
                            }
                        }
                        .frame(height: 10)
                        
                        Spacer()
                 
                            
                        
                        Divider()
                            
                        
                        HAlignment(alignment: .center) {
                            Button {
                                viewModel.todos.append(viewModel.todo)
                                viewModel.todo = ToDo(title: "", content: "")
                            } label: {
                                Label("추가하기", systemImage: "plus.circle.fill")
                            }
                            .tint(.black)
                        }
                        .padding(.vertical, 10)
                        
                    }
                .padding(12)
                .frame(minWidth: width, idealWidth: width, maxWidth: width, minHeight: height * 0.6, idealHeight: height * 0.6, maxHeight: height * 0.64)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.GTyellowBright)
                }
                
            }
        }
        .navigationTitle("오늘 하루 할 일 적기")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
