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
        content
            .onReceive(Just(text)) { _ in
                String.textCountLimit(text: &text, limit: limit)
            }
    }
}

extension View {
    func textfieldLimit(text: Binding<String>, limit: Int) -> some View {
        modifier(TextFieldLimitModifier(text: text, limit: limit))
    }
}
