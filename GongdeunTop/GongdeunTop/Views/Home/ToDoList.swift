//
//  ToDoList.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI



struct ToDoList: View {
    @ObservedObject var viewModel: ToDoViewModel
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ScrollView {
                    if viewModel.todos.isEmpty {
                        ToDoRow(todo: .placeholder)
                    } else {
                        ForEach(viewModel.todos, id: \.self) { todo in
                            ToDoRow(todo: todo)
                        }
                    }
                }
                
               
                Divider()
               
                SheetPresenter("  추가하기", image: UIImage(systemName: "plus.circle.fill"), isUndimmed: true) {
                    SetToDoForm(viewModel: viewModel)
                    
                }
                .tint(.GTEnergeticOrange)
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
