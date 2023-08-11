//
//  ScreenTimeManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/08/10.
//

import Foundation
import Combine
import FamilyControls
import ManagedSettings
import DeviceActivity

class AppShieldManager: ObservableObject {
    @Published var activitySelection = FamilyActivitySelection(includeEntireCategory: true)
    @Published var isAppShieldOn: Bool = UserDefaults.standard.bool(forKey: "isAppShieldOn")
    
    private let deviceActivityCenter = DeviceActivityCenter()
    private let concentrationStore = ManagedSettingsStore(named: .concentration)
    
    // UserDefaults Keys
    private let screentimeSettingKey: String = "isScreenTimeActivated"
    private let activitySelectionkey: String = "activitySelection"
    
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.activitySelection = savedActtivitySelection() ?? FamilyActivitySelection(includeEntireCategory: true)
        
        $activitySelection
            .sink { [weak self] selection in
                self?.saveActtivitySelection(selection)
            }.store(in: &cancellables)
    }
    
    private func saveActtivitySelection(_ selection: FamilyActivitySelection) {
        let defaults = UserDefaults.standard
        defaults.set( try? encoder.encode(selection), forKey: activitySelectionkey)
    }
    
    private func savedActtivitySelection() -> FamilyActivitySelection? {
        let defaults = UserDefaults.standard
        
        
        guard let data = defaults.data(forKey: activitySelectionkey) else {
            return nil
        }

        return try? decoder.decode(
            FamilyActivitySelection.self,
            from: data
        )
    }
    
    func setAppShield(newValue bool: Bool) {
        UserDefaults.standard.set(bool, forKey: "isAppShieldOn")
    }
    
    private func startMonitoring() throws {
        let event = DeviceActivityEvent(applications: activitySelection.applicationTokens,
                                        categories: activitySelection.categoryTokens,
                                        webDomains: activitySelection.webDomainTokens,
                                        threshold: DateComponents(day: 1))
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0, second: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59, second: 59),
            repeats: true
        )
    
        try deviceActivityCenter.startMonitoring(.concentration, during: schedule, events: [.doNotDisturb : event])
    }
    
    private func stopMonitoring() {
        deviceActivityCenter.stopMonitoring()
    }
    
    
    
    func startConcentrationAppShield() {
        guard isAppShieldOn else { return }
        print("::::::Shield is Operating")
        concentrationStore.shield.applications = activitySelection.applicationTokens
        
        do {
           try startMonitoring()
        } catch {
            print("Error while monitoring:::\(error.localizedDescription)")
        }
        
    }
    
    func stopConcentrationAppShield() {
        guard isAppShieldOn else { return }
        print("::::::Stop Sheilding")
        concentrationStore.clearAllSettings()
        stopMonitoring()
    }
    
}

extension ManagedSettingsStore.Name {
    static let concentration = Self("concentration")
}

extension DeviceActivityName {
    static let concentration = Self("concentration")
}

extension DeviceActivityEvent.Name {
    static let doNotDisturb = Self("doNotDisturb")
}
