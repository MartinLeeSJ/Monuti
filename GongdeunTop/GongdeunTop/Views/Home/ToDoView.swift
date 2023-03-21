//
//  ToDoView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI



struct ToDoView: View {
    @ObservedObject var viewModel: ToDoViewModel
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ScrollView {
                    if viewModel.todos.isEmpty {
                        HAlignment(alignment: .leading) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("할 일을 여기에 추가해 보세요")
                                    .font(.headline)
                                Text("세부내용이 표시됩니다")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(12)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.GTyellowBright)
                            
                        }
                    } else {
                        ForEach(viewModel.todos, id: \.self) { todo in
                            HAlignment(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(todo.title)
                                        .font(.headline)
                                    Text(todo.content)
                                        .font(.callout)
                                        .foregroundColor(.gray)
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(todo.tags, id: \.self) {tag in
                                                Text(tag)
                                                    .font(.caption)
                                                    .padding(.vertical, 2)
                                                    .padding(.horizontal, 4)
                                                    .background(Capsule().fill(.green))
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(12)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.GTyellowBright)
                                
                            }
                        }
                    }
                }
                .frame(width: .infinity)
               
                Divider()
               
                SheetPresenter("  추가하기", image: UIImage(systemName: "plus.circle.fill"), isUndimmed: true) {
                    
                    SetToDoView(viewModel: viewModel)
                    
                }
                .tint(.black)
                .frame(height: 33)
                .padding(.bottom, 9)
            }
            
        }
        .navigationTitle("오늘 하루 할 일")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
