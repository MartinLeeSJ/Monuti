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
                        HStack {
                            Text(todo.title)
                                .font(.headline)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                    }
                }
                .padding()
                .frame(width: width, height: height * 0.5)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.GTyellow)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("제목")
                        .font(.headline)
                        .fontWeight(.medium)
                        
                        
                    
                    TextField("할 일 제목", text: $todo.title)
                        .overlay {
                           Divider()
                                .overlay(.gray)
                                .offset(y: 15)
                        }
                        .padding(.bottom)
                        
                    
                    Text("내용")
                        .font(.headline)
                        .fontWeight(.medium)
                        
                    
                    TextField("할 일 내용", text: $todo.content)
                        .overlay {
                           Divider()
                                .overlay(.gray)
                                .offset(y: 15)
                        }
                        .padding(.bottom)
                    
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
                }
                .padding(.horizontal)
                .frame(width: width, height: height * 0.4)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.GTyellowBright)
                }
                
            }
        }
        .navigationTitle("To Do List")
        .padding()
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView()
    }
}
