//
//  HapticManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/05.
//

import Foundation
import CoreHaptics

/// Manage Haptic
///
/// - ToDo:  Refactor가 필요해보임
final class HapticManager: ObservableObject {
    @Published private var engine: CHHapticEngine?
    private var events = [CHHapticEvent]()
    
    init() {
        prepareHaptics()
    }
    
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    
    private func startHaptic() {
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
            
            emptyEvents()
        } catch {
            print("Failed to play pattern: \(error.localizedDescription)")
        }
    }
    
    private func emptyEvents() {
        self.events.removeAll()
    }
    
    func handleStartHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        let intensityValue: Float = 1
        let sharpnessValue: Float = 1
        let firstEventTime: TimeInterval = 0.6
        let secondEventTime: TimeInterval = 0.7
    
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity,
                                               value: intensityValue)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness,
                                               value: sharpnessValue)
        
        let firstEvent = CHHapticEvent(eventType: .hapticTransient,
                                       parameters: [intensity, sharpness],
                                       relativeTime: firstEventTime)
        let secondEvent = CHHapticEvent(eventType: .hapticTransient,
                                        parameters: [intensity, sharpness],
                                        relativeTime: secondEventTime)
        
        events.append(firstEvent)
        events.append(secondEvent)
        
        startHaptic()
    }

}
