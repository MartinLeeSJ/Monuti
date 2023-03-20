//
//  HAllignment.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/20.
//

import Foundation
import SwiftUI


/// 위치를 잡아주는 HStack
/// - Parameter :
///     - alignment: HAlignmentMode (.leading, .trailling, .center)
///     - content: View
struct HAlignment<Content>: View where Content: View {
    enum HAlignmentMode {
        case leading
        case trailling
        case center
    }
    
    let alignment: HAlignmentMode
    let content: () -> Content
    
    init(alignment: HAlignmentMode,
         @ViewBuilder content: @escaping () -> Content) {
        
        self.alignment = alignment
        self.content = content
    }
    
    var body: some View {
        HStack(alignment: .center) {
            switch alignment {
            case .leading:
                Spacer()
                content()
                
            case.trailling:
                content()
                Spacer()
                
            case.center:
                Spacer()
                content()
                Spacer()
            }
        }
    }
    
}
