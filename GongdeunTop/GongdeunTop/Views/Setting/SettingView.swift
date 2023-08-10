//
//  SettingView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/01.
//

import SwiftUI
import FamilyControls



enum SheetType: Identifiable {
    case color
    var id: Self { self }
}

struct SettingView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var appShieldManager: AppShieldManager
    @State private var sheetType: SheetType?
    
    @State private var isAppScreenModeOn: Bool = false
    @State private var isActivitySelectionPickerOn: Bool = false
    
    private let center = AuthorizationCenter.shared

    var body: some View {
        NavigationStack {
            List {
                Button {
                    sheetType = .color
                } label: {
                    Text("ColorSetting")
                }
                
                Button {
                    authManager.signOut()
                } label: {
                    Text("SignOut")
                }
                
                Section {
                    Toggle("집중 시 다른 앱 차단", isOn: $appShieldManager.isAppShieldOn.animation())
                        .onChange(of: appShieldManager.isAppShieldOn) { newValue in
                            appShieldManager.setAppShield(newValue: newValue)
                            
                            guard newValue == true else { return }
                            
                            if center.authorizationStatus == .notDetermined {
                                Task {
                                    do {
                                        try await center.requestAuthorization(for: .individual)
                                        isActivitySelectionPickerOn = true
                                        print(center.authorizationStatus.description)
                                    } catch {
                                        print("Failed to enroll")
                                    }
                                }
                            }
                        }
                    if appShieldManager.isAppShieldOn {
                        HStack {
                            Spacer()
                            Button {
                                isActivitySelectionPickerOn = true
                            } label: {
                                Text("설정하기")
                            }
                        }
                    }
                }.familyActivityPicker(isPresented: $isActivitySelectionPickerOn, selection: $appShieldManager.activitySelection)
                
            }
            .sheet(item: $sheetType) { type in
                switch type {
                case .color:
                    ColorThemeSetting()
                        .presentationDetents([.medium])
                }
            }
        }
        .task {
            if center.authorizationStatus == .approved { isAppScreenModeOn = true }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
