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
    let header: () -> Text

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
              header()
                .font(.caption)
                .foregroundColor(.secondary)
                .offset(y: -2)
        }
    }
}


