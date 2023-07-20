//
//  SetTimeStepper.swift
//  GongdeunTop
//
//  Created by Martin on 2023/07/10.
//

import SwiftUI

struct SetTimeStepper<Label>: View where Label : View {
    @Binding var stepValue: Int
    let bound: Range<Int>
    let step: Int.Stride
    let onEditingChanged: (Bool) -> Void
    @ViewBuilder let label: () -> Label

    
    init(stepValue: Binding<Int>, bound: Range<Int>, step: Int.Stride, _ onEditingChanged: @escaping (Bool) -> Void = { _ in }, @ViewBuilder label: @escaping () -> Label) {
        self._stepValue = stepValue
        self.bound = bound
        self.step = step
        self.onEditingChanged = onEditingChanged
        self.label = label
    }
    
    
    var isLowerBound: Bool {
        stepValue == bound.lowerBound || !(bound ~= stepValue - step)
    }
    
    var isUpperBound: Bool {
        stepValue == (bound.upperBound - 1) || !(bound ~= stepValue + step)
    }
    
    func countUp() {
        guard bound ~= stepValue + step else { return }
        stepValue += step
    }
    
    func countDown() {
        guard bound ~= stepValue - step else { return }
        stepValue -= step
    }
 
    var body: some View {
        HStack(spacing: 8) {
            Button {
                countDown()
                onEditingChanged(true)
            } label: {
                Image(systemName: "minus")
                    .frame(minWidth: 33, minHeight: 25)
            }
            .disabled(isLowerBound)
            .contentShape(Rectangle())
            
            Divider()
                .padding(.vertical, 8)
            
            label()
                .frame(minWidth: 33, maxWidth: 33)
            
            Divider()
                .padding(.vertical, 8)
            Button {
                countUp()
                onEditingChanged(true)
            } label: {
                Image(systemName: "plus")
                    .frame(minWidth: 33, minHeight: 25)
            }
            .disabled(isUpperBound)
            .contentShape(Rectangle())
        }
        .tint(Color("basicFontColor"))
        .padding(.horizontal, 8)
        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 10))
        .frame(minHeight: 33, maxHeight: 33)
    }
}
