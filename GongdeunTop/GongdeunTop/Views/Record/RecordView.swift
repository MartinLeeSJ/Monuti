//
//  RecordView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI

struct RecordView: View {
    @ObservedObject var toDoViewModel: ToDoViewModel
    
    var body: some View {
        NavigationView {
            List(toDoViewModel.todos) { todo in
             
            }
            .navigationTitle("보고서")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
