//
//  TextFieldFormContainer.swift
//  GongdeunTop
//
//  Created by Martin on 2023/06/08.
//

import SwiftUI

struct TextFieldFormContainer<Content, Header, Footer>: View where Content: View, Header: View, Footer: View {
    @EnvironmentObject var themeManager: ThemeManager
    private let content: () -> Content
    private let header: () -> Header
    private let footer: () -> Footer
    
    init(
        @ViewBuilder content: @escaping () -> Content,
        header: @escaping () -> Header = { EmptyView() },
        footer: @escaping () -> Footer = { EmptyView() }
    ) {
        self.content = content
        self.header = header
        self.footer = footer
    }
    
    var body: some View {
        FormContainer(
            paddingInsets: [.vertical, .leading],
            content: content,
            header: header,
            footer: footer
        )
        .textFieldStyle(.plain)
//        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.never)
    }
}


