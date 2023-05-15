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
    @EnvironmentObject var launchScreenManager: LaunchScreenManager
    
    var body: some View {
        VStack {
            switch authManager.authState {
            case .unAuthenticated: SignUpView(manager: authManager)
            case .authenticating: ProgressView()
            case .authenticated where authManager.nickNameRegisterState != .existingUser: SetNickNameView(manager: authManager)
            case .authenticated:
                TabView {
                    ToDoList()
                        .tabItem {
                            Label("하루", systemImage: "deskclock")
                        }
                        .tag(1)
                    
                    TargetList()
                        .tabItem {
                            Label("단기목표", systemImage: "target")
                        }
                        .tag(2)
                    
                    RecordView()
                        .tabItem {
                            Label("기록", systemImage: "text.redaction")
                        }
                        .environmentObject(authManager)
                        .tag(3)
                }
                .tint(scheme == .dark ? Color.white : Color.black)
                
                
            }
        }
        .task {
            self.launchScreenManager.dismiss()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(LaunchScreenManager())
    }
}
