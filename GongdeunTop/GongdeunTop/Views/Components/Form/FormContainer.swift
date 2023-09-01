//
//  FormContainer.swift
//  GongdeunTop
//
//  Created by Martin on 2023/06/08.
//

import SwiftUI

struct FormContainer<Content, Header, Footer>: View where Content: View, Header: View, Footer: View {
    @EnvironmentObject var themeManager: ThemeManager
    var paddingInsets: Edge.Set = [.all]
     private let content: () -> Content
    private let header: () -> Header
    private let footer: () -> Footer
    
    init(
        paddingInsets: Edge.Set = [.all],
        @ViewBuilder content: @escaping () -> Content,
        header: @escaping () -> Header = {EmptyView()},
        footer: @escaping () -> Footer = {EmptyView()}
    ) {
        self.paddingInsets = paddingInsets
        self.content = content
        self.header = header
        self.footer = footer
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing(of: .minimum)) {
            header()
                .font(.caption)
                .foregroundStyle(.tertiary)
                .padding(.leading, 10)

            VStack {
                content()
            }
            .padding(paddingInsets)
            .background(themeManager.componentColor(), in: RoundedRectangle(cornerRadius: 10))
            
            footer()
                .font(.caption)
                .foregroundStyle(.tertiary)
                .padding(.leading, 10)
        }
    }
}


