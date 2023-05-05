//
//  Countdown.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/26.
//

import SwiftUI
import CoreHaptics

struct FirstCountdown: View {
    @StateObject private var hapticManger = HapticManager()
    @Binding var isEnded: Bool
    
    
    @State private var timeCount: Int = 3
    @State private var timeRemain: Double = 8.0
    @State private var timer: Timer? = nil

    
    private enum AnimationState {
        case up, down, disappear
        var physicalValue: (offset: Double, opacity: Double) {
            switch self {
            case .up: return (-40.0, 1.0)
            case .down: return (0.0, 0.2)
            case .disappear: return (0.0, 0.0)
            }
        }
    }
    
    @State private var animation: AnimationState = .disappear
    

       var body: some View {
           Color(.black)
               .opacity(0.9)
               .ignoresSafeArea()
               .overlay {
                   Text(timeCount == 0 ? "START!" : String(timeCount))
                       .font(.system(size: timeCount == 0 ? 32 : 64, weight: .heavy))
                       .foregroundColor(.white)
                       .background {
                           Circle()
                               .fill(Color.GTPastelBlue.opacity(0.3))
                               .frame(width: 150, height: 150)
                       }
                       .offset(y: animation.physicalValue.offset)
                       .opacity(animation.physicalValue.opacity)
               }
               .overlay(alignment: .bottomTrailing) {
                   Button {
                       skipTime()
                   } label: {
                       Label("Skip", systemImage: "chevron.forward.2")
                   }
                   .tint(.white)
                   .offset(x: -20, y: -20)
               }
               .onAppear {
                   complexAnimation()
               }
               .onChange(of: timeCount) { count in
                   if count == 0 {
                       hapticManger.handleStartHaptic()
                   }
               }
       }
    
    private func complexAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
            if timeRemain > 0.0 {
                timeRemain -= 0.2
                timeCount = Int(timeRemain / 2)
                
                withAnimation(.linear) {
                    switch timeRemain - floor(timeRemain) {
                    case 0.8..<1.0 where Int(timeRemain) % 2 == 1:
                        animation = .down
                    case 0.0..<0.8 where Int(timeRemain) % 2 == 1 :
                        animation = .up
                        
                    case 0.0..<1.0 where timeCount == 0 :
                        animation = .up
                    default:
                        animation = .disappear
                    }
                }

            } else {
                timer.invalidate()
                isEnded = true
            }
        }
    }
    
    private func skipTime() {
        timeCount = 0
        timeRemain = 0.9
    }
    
    
}

struct Countdown_Previews: PreviewProvider {
    static var previews: some View {
        FirstCountdown(isEnded: .constant(false))
    }
}
