//
//  HAlignmentModifier.swift
//  GongdeunTop
//
//  Created by Martin on 2023/09/05.
//

import SwiftUI

struct HAlignmentModifier: ViewModifier {
    enum Alignment {
        case leading
        case center
        case trailing
    }
    
    private var alignment: Alignment = .leading
    
    init(alignment: Alignment) {
        self.alignment = alignment
    }
    
    func body(content: Content) -> some View {
        switch alignment {
        case .leading:
            return HAlignment(alignment: .leading) {
                content
            }
        case .center:
            return HAlignment(alignment: .center) {
                content
            }
        case .trailing:
            return HAlignment(alignment: .trailling) {
                content
            }
        }
    }
}

extension View {
    func horizontalSelfAlignment(_ alignment: HAlignmentModifier.Alignment) -> some View {
        modifier(HAlignmentModifier(alignment: alignment))
    }
}
