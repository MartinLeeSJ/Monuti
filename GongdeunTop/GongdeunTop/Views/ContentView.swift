//
//  ContentView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var scheme: ColorScheme
    @StateObject var authManager = AuthManager()
    
    var body: some View {
        
        
        switch authManager.authState {
        case .unAuthenticated: SignUpView(manager: authManager)
        case .authenticating: Text("loading")
        case .authenticated where authManager.nickNameRegisterState != .existingUser: SetNickNameView(manager: authManager)
        case .authenticated:
                TabView {
                    ToDoList()
                        .tabItem {
                            Label("하루", systemImage: "deskclock")
                        }
                        .tag(1)
                    
                    RecordView()
                        .tabItem {
                            Label("기록", systemImage: "text.redaction")
                        }
                        .environmentObject(authManager)
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
