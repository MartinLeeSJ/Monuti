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
    @EnvironmentObject var appBlockManager: AppBlockManager
    @State private var sheetType: SheetType?
    
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
                    Toggle("집중 시 다른 앱 차단",
                           isOn: $appBlockManager.isAppBlockOn.animation())
                    .onChange(of: appBlockManager.isAppBlockOn,
                              perform: { appBlockManager.setFamilyControl(isOn: $0) })
                    
                    if appBlockManager.isAppBlockOn {
                        HStack {
                            Spacer()
                            Button {
                                appBlockManager.isActivitySelectionPickerOn = true
                            } label: {
                                Text("설정하기")
                            }
                        }
                    }
                }.familyActivityPicker(
                    isPresented: $appBlockManager.isActivitySelectionPickerOn,
                    selection: $appBlockManager.activitySelection)
                
            }
            .sheet(item: $sheetType) { type in
                switch type {
                case .color:
                    ColorThemeSetting()
                        .presentationDetents([.medium])
                }
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
