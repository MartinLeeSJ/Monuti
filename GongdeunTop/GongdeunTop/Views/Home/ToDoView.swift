//
//  ToDoView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI

struct ToDo: Hashable {
    var title: String = ""
    var content: String = ""
}

struct ToDoView: View {
    @State private var todo: ToDo = .init(title: "", content: "")
    @State private var todos: [ToDo] = []
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            
            VStack {
                ScrollView {
                    ForEach(todos, id: \.self) { todo in
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(todo.title)
                                        .font(.headline)
                                    Text(todo.content)
                                        .font(.callout)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            Divider()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 2)
                    }
                }
                .padding()
                .frame(width: width, height: height * 0.4)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.GTyellow)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("제목")
                        .font(.headline)
                        .fontWeight(.medium)
                        .padding(.vertical, 5)
                        .padding(.top, 20)
                        
                        
                    
                    TextField("할 일 제목", text: $todo.title)
                        .overlay {
                           Divider()
                                .overlay(.gray)
                                .offset(y: 15)
                        }
                        
                        
                    Spacer()
                        
                    
                    Text("내용")
                        .font(.headline)
                        .fontWeight(.medium)
                        .padding(.vertical, 5)
                        
                    
                    TextField("할 일 내용", text: $todo.content)
                        .overlay {
                           Divider()
                                .overlay(.gray)
                                .offset(y: 15)
                        }
                    
                    Spacer()
                    
                    HStack{
                       Spacer()
                        Button {
                            todos.append(todo)
                            todo = .init()
                        } label: {
                            Label("추가하기", systemImage: "plus.circle.fill")
                        }
                       Spacer()
                    }
                    .padding(.bottom)
                }
                .padding(.horizontal)
                .frame(minWidth: width, idealWidth: width, maxWidth: width, minHeight: height * 0.4, idealHeight: height * 0.45, maxHeight: height * 0.48)
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
        ToDoView()
    }
}
