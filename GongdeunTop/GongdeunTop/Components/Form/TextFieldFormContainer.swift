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

    var body: some View {
        VStack {
            content()
        }
        .padding([.vertical, .leading])
        .background(themeManager.getComponentColor(), in: RoundedRectangle(cornerRadius: 10))
        .textFieldStyle(.plain)
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.never)
        .padding(.top, 16)
        .overlay(alignment: .topLeading) {
            if let header = header {
                header()
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .offset(y: -2)
            }
        }
    }
}


