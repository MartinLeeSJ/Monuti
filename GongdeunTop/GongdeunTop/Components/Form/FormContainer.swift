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
        VStack(alignment: .leading, spacing: 2) {
            
            if let header = header {
                header()
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.leading, 10)
            }
            
            VStack {
                content()
            }
            .padding(paddingInsets)
            .background(themeManager.componentColor(), in: RoundedRectangle(cornerRadius: 10))
            
            if let footer = footer {
                footer()
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.leading, 10)
            }
        }
    }
}


