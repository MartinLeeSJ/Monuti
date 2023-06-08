//
//  TextFieldFormContainer.swift
//  GongdeunTop
//
//  Created by Martin on 2023/06/08.
//

import SwiftUI

struct TextFieldFormContainer<Content>: View where Content: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ViewBuilder let content: () -> Content
    var header: (() -> Text)? = nil
    var footer: (() -> Text)? = nil
    
    var body: some View {
        FormContainer(paddingInsets: [.vertical, .leading], content: content, header: header, footer: footer)
        .textFieldStyle(.plain)
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.never)
    }
}


