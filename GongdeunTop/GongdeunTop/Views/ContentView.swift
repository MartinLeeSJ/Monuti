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
    @StateObject var todoStore = ToDoStore()
    @StateObject var targetStore = TargetStore()
    @StateObject var timerManager = TimerManager()
    @EnvironmentObject var launchScreenManager: LaunchScreenManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack {
            switch authManager.authState {
            case .unAuthenticated: SignUpView(manager: authManager)
            case .authenticating: ProgressView()
            case .authenticated where authManager.nickNameRegisterState != .existingUser: SetNickNameView(manager: authManager)
            case .authenticated:
                MainRouterView()
                    .environmentObject(authManager)
                    .environmentObject(todoStore)
                    .environmentObject(targetStore)
                    .environmentObject(timerManager)
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
