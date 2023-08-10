//
//  ScreenTimeManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/08/10.
//

import Foundation
import FamilyControls
import ManagedSettings

class AppShieldManager: ObservableObject {
    @Published var activitySelection = FamilyActivitySelection(includeEntireCategory: true)
    
    private let concentrationStore = ManagedSettingsStore(named: .concentration)
    private let screentimeSettingKey: String = "isScreenTimeActivated"
    
    

    
    func startConcentrationAppShield() {
        concentrationStore.shield.applications = activitySelection.applicationTokens
    }
    
    func stopConcentrationAppShield() {
        concentrationStore.clearAllSettings()
    }
    
}

extension ManagedSettingsStore.Name {
    static let concentration = Self("concentration")
}

