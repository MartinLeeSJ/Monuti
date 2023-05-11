//
//  SettingView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/01.
//

import SwiftUI



enum SheetType: Identifiable {
    case color
    var id: Self { self }
}

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthManager
    @AppStorage("theme") private var theme: String = "Blue"
    @State private var modified: Bool = false
    @State private var sheetType: SheetType?
    
    private func changeTheme(color: String) {
        theme = color
        NotificationCenter.default.post(name: Notification.Name(rawValue: "colorPreferenceChanged"), object: nil)
    }
    
    var body: some View {
        NavigationView {
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
            }
            .sheet(item: $sheetType) { type in
                switch type {
                case .color:
                    ColorThemeSetting(modified: $modified)
                        .presentationDetents([.medium])
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                    }
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
