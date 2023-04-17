//
//  Countdown.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/26.
//

import SwiftUI
import CoreHaptics

struct FirstCountdown: View {
    @State private var timeCount: Int = 3
    @State private var timeRemain: Double = 8.0
    @State private var timer: Timer? = nil
    
    @State private var engine: CHHapticEngine?

    
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
               .onAppear {
                   complexAnimation()
                   prepareHaptics()
               }
               .onChange(of: timeCount) { count in
                   if count == 0 {
                       complexStartHaptic()
                   }
               }
       }
    
    private func complexAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
            if timeRemain > 0.0 {
                timeRemain -= 0.2
                timeCount = Int(timeRemain / 2)
                
                withAnimation(.linear){
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
            }
        }
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func complexStartHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        
        let firstEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0.6)
        let secondEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0.7)
        
        events.append(firstEvent)
        events.append(secondEvent)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription)")
        }
    }
    
    
}

struct Countdown_Previews: PreviewProvider {
    static var previews: some View {
        FirstCountdown()
    }
}
