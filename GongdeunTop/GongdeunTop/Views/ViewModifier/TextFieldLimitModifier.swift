//
//  TextFieldLimitModifier.swift
//  GongdeunTop
//
//  Created by Martin on 2023/09/02.
//

import SwiftUI
import Combine

struct TextFieldLimitModifier: ViewModifier {
    @Binding private var text: String
    private let limit: Int
    
    init(text: Binding<String>, limit: Int) {
        self._text = text
        self.limit = limit
    }
    
    func body(content: Content) -> some View {
        HStack(alignment: .bottom, spacing: .spacing(of: .normal)) {
            content
                .onReceive(Just(text)) { _ in
                    String.textCountLimit(text: &text, limit: limit)
                }
            
            Text("\(text.count)/\(limit)")
                .font(.caption)
                .fixedSize(horizontal: true, vertical: true)
                .padding(.trailing, .spacing(of: .half))
        }
    }
}

extension View {
    func textfieldLimit(text: Binding<String>, limit: Int) -> some View {
        modifier(TextFieldLimitModifier(text: text, limit: limit))
    }
}
