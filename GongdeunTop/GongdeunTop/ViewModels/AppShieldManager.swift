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
    @Published var isAppShieldOn: Bool = UserDefaults.standard.bool(forKey: "isAppShieldOn")
    
    private let concentrationStore = ManagedSettingsStore(named: .concentration)
    private let screentimeSettingKey: String = "isScreenTimeActivated"
    
    func setAppShield(newValue bool: Bool) {
        UserDefaults.standard.set(bool, forKey: "isAppShieldOn")
    }
    
    func startConcentrationAppShield() {
        guard isAppShieldOn else { return }
        concentrationStore.shield.applications = activitySelection.applicationTokens
    }
    
    func stopConcentrationAppShield() {
        guard isAppShieldOn else { return }
        concentrationStore.clearAllSettings()
    }
    
}

extension ManagedSettingsStore.Name {
    static let concentration = Self("concentration")
}

