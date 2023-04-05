//
//  RecordView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI

struct RecordView: View {
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
                

              
            }
            .navigationTitle("보고서")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView(authViewModel: AuthViewModel())
    }
}
