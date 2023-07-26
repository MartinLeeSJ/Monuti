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
    @StateObject var todoManager = ToDoManager()
    @StateObject var targetManager = TargetManager()
    @StateObject var timerManager = TimerManager()
    @EnvironmentObject var launchScreenManager: LaunchScreenManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack {
            switch authManager.authState {
            case .unAuthenticated: SignUpView(manager: authManager)
            case .authenticated where authManager.nickNameRegisterState != .existingUser: SetNickNameView(manager: authManager)
            case .authenticated where authManager.nickNameRegisterState == .existingUser:
                MainRouterView()
                    .environmentObject(authManager)
                    .environmentObject(todoManager)
                    .environmentObject(targetManager)
                    .environmentObject(timerManager)
            default: ProgressView()
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
