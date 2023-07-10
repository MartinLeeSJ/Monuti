//
//  MonutiSlider.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/11.
//

import SwiftUI

struct MonutiSlide: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var value: Int
    let bound: ClosedRange<Int>
    @State private var draggedOffset: CGFloat = 0

    private var dragGestureCorrectionFactor: CGFloat {
        CGFloat(bound.upperBound) / CGFloat(300)
    }
    
    private func minus() {
        guard value > bound.lowerBound else {
            value = bound.lowerBound
            draggedOffset = CGFloat(value)
            return
        }
        value -= 1
        draggedOffset = CGFloat(value)
    }
    
    private func plus() {
        guard value < bound.upperBound else {
            value = bound.upperBound
            draggedOffset = CGFloat(value)
            return
        }
        value += 1
        draggedOffset = CGFloat(value)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value.formatted())
                .animation(.none)
            HStack(alignment: .top, spacing: 16) {
                Button {
                    minus()
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title3)
                }
                .frame(height: 36)
                
                VStack(spacing: 4) {
                    Rectangle()
                        .foregroundStyle(.thinMaterial)
                        .frame(height: 36)
                        .overlay {
                            GeometryReader { geo in
                                let width = geo.size.width
                                let height = geo.size.height
                                let upperRectangleWidth: CGFloat = width * draggedOffset / CGFloat(bound.upperBound)
                                Rectangle()
                                    .foregroundColor(themeManager.getColorInPriority(of: .solid))
                                    .frame(width: upperRectangleWidth)
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 30, height: 20)
                                    .foregroundColor(.white)
                                    .shadow(radius: 1)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(themeManager.getColorInPriority(of: .accent), lineWidth: 1)
                                    }
                                    .overlay {
                                        Image(systemName: "arrowtriangle.left.and.line.vertical.and.arrowtriangle.right.fill")
                                            .font(.caption)
                                            .foregroundColor(themeManager.getColorInPriority(of: .accent))
                                    }
                                    .offset(x: upperRectangleWidth - 15, y: height / 2 - 10)
                            }
                        }
                        .cornerRadius(10)
                        .gesture(dragGesture)
                    HStack {
                        Text("\(Int(bound.lowerBound))")
                        Spacer()
                        Text("\(Int(bound.upperBound))")
                    }
                    .font(.footnote)
                }
                    
                Button {
                    plus()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                }
                .frame(height: 36)
                
            }
        }
        .padding()
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                withAnimation(.easeOut) {
                    let newDraggedOffset = CGFloat(value) + ceil(gesture.translation.width * dragGestureCorrectionFactor)
                    guard newDraggedOffset <= CGFloat(bound.upperBound) else {
                        draggedOffset = CGFloat(bound.upperBound)
                        return
                    }
                    guard newDraggedOffset >= CGFloat(bound.lowerBound) else {
                        draggedOffset = CGFloat(bound.lowerBound)
                        return
                    }
                    draggedOffset = newDraggedOffset
                }
            }
            .onEnded { gesture in
                value = Int(draggedOffset)
            }
    }
}
