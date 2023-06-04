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
            case .authenticated:
                NavigationView {
                    ZStack {
                        themeManager.getColorInPriority(of: .background)
                            .ignoresSafeArea()
                        ScrollView {
                            LazyVGrid(columns: .init(repeating: .init(.flexible(), spacing: 10), count: 2), spacing: 10) {
                                NavigationLink {
                                    ToDoList()
                                } label: {
                                    VStack(alignment: .trailing) {
                                        HAlignment(alignment: .leading) {
                                            Text("오늘 할 일")
                                            Image(systemName: "checklist")
                                                .foregroundStyle(themeManager.getColorInPriority(of: .accent), .gray)
                                        }
                                        Spacer()
                                        Text("0")
                                            .font(.title)
                                            .fontWeight(.bold)
                                    }
                                    .padding()
                                    .background(themeManager.getComponentColor(), in: RoundedRectangle(cornerRadius: 8))
                                }
                                
                                NavigationLink {
                                    TargetList()
                                } label: {
                                    VStack(alignment: .trailing) {
                                        HAlignment(alignment: .leading) {
                                            Text("목표")
                                            Image(systemName: "target")
                                                .foregroundStyle(themeManager.getColorInPriority(of: .accent), .gray)
                                        }
                                        Spacer()
                                        Text("0")
                                            .font(.title)
                                            .fontWeight(.bold)
                                    }
                                }
                                .padding()
                                .background(themeManager.getComponentColor(), in: RoundedRectangle(cornerRadius: 8))
                                
                                NavigationLink {
                                    RecordView()
                                        .environmentObject(authManager)
                                } label: {
                                    VStack(alignment: .trailing) {
                                        HAlignment(alignment: .leading) {
                                            Text("달력")
                                            Image(systemName: "calendar")
                                                .foregroundStyle(themeManager.getColorInPriority(of: .accent))
                                        }
                                        Spacer()
                                        Text("0")
                                            .font(.title)
                                            .fontWeight(.bold)
                                    }
                                }
                                .padding()
                                .background(themeManager.getComponentColor(), in: RoundedRectangle(cornerRadius: 8))
                            }
                            .font(.title3.weight(.semibold))
                            .tint(Color("basicFontColor"))
                        }
                        .padding()
                    }
                }
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
