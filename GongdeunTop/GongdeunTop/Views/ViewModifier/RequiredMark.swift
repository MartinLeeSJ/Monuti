//
//  RequiredMark.swift
//  GongdeunTop
//
//  Created by Martin on 2023/09/05.
//

import SwiftUI

struct RequiredMark: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .topTrailing) {
                Image(systemName: "staroflife.fill")
                    .font(.system(size: 6))
                    .foregroundColor(.red)
                    .offset(x: 8)
            }
    }
}

extension View {
    func requiredMark() -> some View {
        modifier(RequiredMark())
    }
}
