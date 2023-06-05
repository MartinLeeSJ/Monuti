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
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack {
            switch authManager.authState {
            case .unAuthenticated: SignUpView(manager: authManager)
            case .authenticating: ProgressView()
            case .authenticated where authManager.nickNameRegisterState != .existingUser: SetNickNameView(manager: authManager)
            case .authenticated: MainSummaryView().environmentObject(authManager)
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
