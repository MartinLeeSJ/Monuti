//
//  FormContainer.swift
//  GongdeunTop
//
//  Created by Martin on 2023/06/08.
//

import SwiftUI

struct FormContainer<Content>: View where Content: View {
    @EnvironmentObject var themeManager: ThemeManager
    var paddingInsets: Edge.Set = [.all]
    @ViewBuilder let content: () -> Content
    var header: (() -> Text)? = nil
    var footer: (() -> Text)? = nil
    
    var body: some View {
        VStack {
            content()
        }
        .padding(paddingInsets)
        .background(themeManager.getComponentColor(), in: RoundedRectangle(cornerRadius: 10))
        .overlay(alignment: .topLeading) {
            if let header = header {
                header()
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .offset(x: 8, y: -16)
            }
        }
        .overlay(alignment: .bottomLeading) {
            if let footer = footer {
                footer()
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .offset(x: 8, y: 16)
            }
        }
    }
}


