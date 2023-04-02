//
//  RecordView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI

struct RecordView: View {
    @ObservedObject var toDoViewModel: ToDoViewModel
    @ObservedObject var authViewModel: AuthViewModel
    var body: some View {
        NavigationView {
            
            List {
             
                Button {
                    authViewModel.signOut()
                } label: {
                    Text("로그아웃")
                        .foregroundColor(.red)
                }
                

                ForEach(toDoViewModel.todos, id: \.self) { todo in
                    
                }
            }
            .navigationTitle("보고서")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView(toDoViewModel: ToDoViewModel(todo: .placeholder), authViewModel: AuthViewModel())
    }
}
