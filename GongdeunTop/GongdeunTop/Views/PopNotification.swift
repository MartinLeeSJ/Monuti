//
//  PopNotification.swift
//  GongdeunTop
//
//  Created by Martin on 2023/08/17.
//

import SwiftUI

struct PopNotification: ViewModifier {
    enum LastTime: TimeInterval {
        case veryShort = 1.0
        case short = 1.5
        case middle = 2.0
        case long = 3.0
        case veryLong = 3.5
        
        var fixingTime: TimeInterval { self.rawValue / 2 }
        var movingTime: TimeInterval { self.rawValue / 5 }
        var disappearingTime: TimeInterval { self.rawValue / 3 }
        
    }
    
    @Binding var hasTriggered: Bool
    @State private var offset: CGFloat = -20
    @State private var opacity: Double = 0.0
    var text: LocalizedStringKey
    var lasts: LastTime
    
    init(hasTriggered: Binding<Bool>, text: LocalizedStringKey, lasts: LastTime = .middle) {
        self._hasTriggered = hasTriggered
        self.text = text
        self.lasts = lasts
    }
    
    
    
    private func trigger() async {
        do {
            opacity = 1.0
            offset -= 20
            try await Task.sleep(for: Duration(secondsComponent: Int64(lasts.fixingTime), attosecondsComponent: 0))
            opacity = 0.0
            offset += 20
            try await Task.sleep(for: Duration(secondsComponent: Int64(lasts.disappearingTime), attosecondsComponent: 0))
            hasTriggered.toggle()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if hasTriggered {
                    Text(text)
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(.regularMaterial, in: Capsule())
                        .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                        .offset(y: offset)
                        .opacity(opacity)
                        .animation(.easeInOut(duration: lasts.movingTime), value: offset)
                        .animation(.easeInOut(duration: lasts.movingTime), value: opacity)
                        .task {
                            await trigger()
                        }
                }
            }
    }
}

extension View {
    func popNotification(hasTriggered: Binding<Bool>, text: LocalizedStringKey, lasts: PopNotification.LastTime) -> some View {
        modifier(PopNotification(hasTriggered: hasTriggered, text: text, lasts: lasts))
    }
}
