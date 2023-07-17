//
//  SetTimeSlider.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/11.
//

import SwiftUI

struct SetTimeSlider<Label>: View where Label : View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var value: Int
    let bound: ClosedRange<Int>
    @State private var draggedOffset: CGFloat
    @ViewBuilder let valueLabel: (Int) -> Label
    @ViewBuilder let lowerBoundLabel: (Int) -> Label
    @ViewBuilder let upperBoundLabel: (Int) -> Label
    
    init(value: Binding<Int>,
         bound: ClosedRange<Int>,
         @ViewBuilder valueLabel: @escaping (Int) -> Label,
         @ViewBuilder lowerBoundLabel: @escaping (Int) -> Label,
         @ViewBuilder upperBoundLabel: @escaping (Int) -> Label
    ) {
        self._value = value
        self.bound = bound
        self.draggedOffset = CGFloat(value.wrappedValue - bound.lowerBound)
        self.valueLabel = valueLabel
        self.lowerBoundLabel = lowerBoundLabel
        self.upperBoundLabel = upperBoundLabel
    }

    private var dragGestureCorrectionFactor: CGFloat {
        CGFloat(bound.upperBound - bound.lowerBound) / CGFloat(300)
    }
    
    private func minus() {
        guard value > bound.lowerBound else {
            value = bound.lowerBound
            draggedOffset = CGFloat(0)
            return
        }
        value -= 1
        draggedOffset = CGFloat(value - bound.lowerBound)
    }
    
    private func plus() {
        guard value < bound.upperBound else {
            value = bound.upperBound
            draggedOffset = CGFloat(value - bound.lowerBound)
            return
        }
        value += 1
        draggedOffset = CGFloat(value - bound.lowerBound)
    }
    
    var body: some View {
        
        VStack(spacing: 4) {
            valueLabel(Int(draggedOffset) + bound.lowerBound)
                .animation(.none, value: draggedOffset)
            
            HStack(alignment: .top, spacing: 16) {
                    Button {
                        minus()
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title3)
                            .foregroundColor(Color("basicFontColor"))
                    }
                    .frame(height: 36)
                    
                    VStack(spacing: 4) {
                        Rectangle()
                            .foregroundStyle(.thinMaterial)
                            .frame(height: 36)
                            .overlay {
                                GeometryReader { geo in
                                    let width = geo.size.width
                                    let upperRectangleWidth: CGFloat = width * draggedOffset / CGFloat(bound.upperBound - bound.lowerBound)
                                    Rectangle()
                                        .foregroundColor(themeManager.getColorInPriority(of: .solid))
                                        .frame(width: upperRectangleWidth)
                                }
                            }
                            .cornerRadius(10)
                            .gesture(dragGesture)
                        HStack {
                            lowerBoundLabel(bound.lowerBound)
                            Spacer()
                            upperBoundLabel(bound.upperBound)
                        }
                        .font(.footnote)
                    }
                        
                    Button {
                        plus()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(Color("basicFontColor"))
                    }
                    .frame(height: 36)
            }
        }
        
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                withAnimation(.easeOut) {
                    let maxOffset = bound.upperBound - bound.lowerBound
                    let newDraggedOffset = CGFloat(value - bound.lowerBound) + ceil(gesture.translation.width * dragGestureCorrectionFactor)
                    guard newDraggedOffset <= CGFloat(maxOffset) else {
                        draggedOffset = CGFloat(maxOffset)
                        return
                    }
                    guard newDraggedOffset >= 0 else {
                        draggedOffset = 0
                        return
                    }
                    draggedOffset = newDraggedOffset
                }
            }
            .onEnded { gesture in
                value = Int(draggedOffset) + bound.lowerBound
            }
    }
}
