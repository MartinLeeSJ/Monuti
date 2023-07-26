//
//  GongdeunTopApp.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/16.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
    
}


@main
struct GongdeunTopApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var themeManager = ThemeManager()
    @StateObject var launchScreenManager = LaunchScreenManager()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()

                if launchScreenManager.state != .finished {
                    LauchScreen()
                }
            }
            .environmentObject(themeManager)
            .environmentObject(launchScreenManager)
        }
    }
}
