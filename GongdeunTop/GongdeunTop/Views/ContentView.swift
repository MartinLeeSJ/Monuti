//
//  ContentView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var scheme: ColorScheme
    
    @StateObject var authViewModel = AuthManager()
 
    var body: some View {
        switch authViewModel.authState {
        case .unAuthenticated: SignUpView(viewModel: authViewModel)
        case .authenticated, .authenticating:
            TabView {
                ToDoList()
                    .tabItem {
                        Label("하루", systemImage: "deskclock")
                    }
                    .tag(1)
                
                RecordView(authManager: authViewModel)
                    .tabItem {
                        Label("기록", systemImage: "text.redaction")
                    }
                    .tag(2)
            }
            .tint(scheme == .dark ? Color.white : Color.black)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
