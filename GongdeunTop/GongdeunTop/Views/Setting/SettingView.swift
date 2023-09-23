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
    @State private var isSignOutPresented: Bool = false
    
    private let center = AuthorizationCenter.shared
    
    var body: some View {
        NavigationStack {
            List {
                Button {
                    sheetType = .color
                } label: {
                    Text("ColorThemeSetting")
                }
                .tint(.basicFontColor)

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
                
                Section {
                    Button {
                        isSignOutPresented = true
                    } label: {
                        Text("SignOut")
                    }
                    .tint(.basicFontColor)
                    .confirmationDialog("SignOut", isPresented: $isSignOutPresented) {
                        Button(role: .cancel) {
                            isSignOutPresented = false
                        } label: {
                            Text("Cancel")
                        }
                        
                        Button(role: .destructive) {
                            authManager.signOut()
                        } label: {
                            Text("SignOut")
                        }
                    } message: {
                        Text("really_signOut")
                    }
                }
                
            }
            .sheet(item: $sheetType) { type in
                switch type {
                case .color:
                    ColorThemeSetting()
                        .presentationDetents([.fraction(0.2)])
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
