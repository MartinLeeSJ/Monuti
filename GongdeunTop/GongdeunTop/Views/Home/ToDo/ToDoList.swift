//
//  ToDoList.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI


struct ToDoList: View {
    
    @StateObject var todoStore = ToDoStore()
    @State private var isAddSheetOn: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                if todoStore.todos.isEmpty {
                    ToDoRow(todo: .placeholder)
                        .disabled(true)
                } else {
                    ForEach(todoStore.todos, id: \.self) { todo in
                        ToDoRow(todo: todo)
                    }
                }
            }
            
            Divider()
            
            Button {
                isAddSheetOn = true
            } label: {
                Label("추가하기", systemImage: "plus.circle.fill")
            }
            .sheet(isPresented: $isAddSheetOn) {
                SetToDoForm()
            }
            .tint(.GTEnergeticOrange)
            .frame(height: 33)
            .padding(.bottom, 9)
        }
        .navigationTitle("오늘 하루 할 일")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal)
        .onAppear {
            todoStore.subscribeTodos()
        }
        .onDisappear {
            todoStore.unsubscribeTodos()
        }
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
