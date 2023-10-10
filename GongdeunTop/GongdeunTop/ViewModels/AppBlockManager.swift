//
//  ScreenTimeManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/08/10.
//

import Foundation
import Combine
import FamilyControls
import DeviceActivity
import ManagedSettings

class AppBlockManager: ObservableObject {
    @Published var activitySelection = FamilyActivitySelection()
    @Published var isActivitySelectionPickerOn: Bool = false
    @Published var isAppBlockOn: Bool = UserDefaults.standard.bool(forKey: "isAppBlockOn")
    
    private let center = AuthorizationCenter.shared
    private let deviceActivityCenter = DeviceActivityCenter()
    private let managedSettingsStore = ManagedSettingsStore(named: .concentration)
    
    
    // UserDefaults Keys
    private let screentimeSettingKey: String = "isScreenTimeActivated"
    static private let activitySelectionkey: String = "activitySelection"
    
    private let encoder = PropertyListEncoder()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.activitySelection = AppBlockManager.savedActivitySelection() ?? FamilyActivitySelection(includeEntireCategory: true)
        
        $activitySelection
            .sink { [weak self] selection in
                self?.saveActivitySelection(selection)
            }.store(in: &cancellables)
    }
    
    private func saveActivitySelection(_ selection: FamilyActivitySelection) {
        let defaults = UserDefaults.standard
        defaults.set( try? encoder.encode(selection), forKey: AppBlockManager.activitySelectionkey)
    }
    
    static public func savedActivitySelection() -> FamilyActivitySelection? {
        let decoder = PropertyListDecoder()
        let defaults = UserDefaults.standard
        
        
        guard let data = defaults.data(forKey: AppBlockManager.activitySelectionkey) else {
            return nil
        }

        return try? decoder.decode(
            FamilyActivitySelection.self,
            from: data
        )
    }
    
    @MainActor
    func setFamilyControl(isOn: Bool) {
        setAppBlock(isOn: isOn)
        
        guard isOn else {
            return
        }
        
        if center.authorizationStatus == .notDetermined {
            Task {
                do {
                    try await center.requestAuthorization(for: .individual)
                    isActivitySelectionPickerOn = true
                } catch {
                    print("Failed to enroll")
                }
            }
        }
    }
    
    private func setAppBlock(isOn bool: Bool) {
        UserDefaults.standard.set(bool, forKey: "isAppBlockOn")
    }
    

    func startConcentrationAppShield() {
        guard isAppBlockOn else { return }
        print("Start App Block")
        do {
            
            let schedule = DeviceActivitySchedule(
                intervalStart: DateComponents(hour: 0, minute: 0, second: 0),
                intervalEnd: DateComponents(hour: 23, minute: 59, second: 59),
                repeats: true
            )
            
            let applicationTokens = activitySelection.applicationTokens
            let categoryTokens = activitySelection.categoryTokens
            let webDomainTokens = activitySelection.webDomainTokens
            
            let event = DeviceActivityEvent(applications: applicationTokens,
                                            categories: categoryTokens,
                                            webDomains: webDomainTokens,
                                            threshold: DateComponents(day: 1))
            

            managedSettingsStore.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categoryTokens, except: Set())
            managedSettingsStore.shield.webDomainCategories = ShieldSettings.ActivityCategoryPolicy.specific(categoryTokens, except: Set())
            

            try deviceActivityCenter.startMonitoring(.concentration,
                                                     during: schedule,
                                                     events: [.concentration : event])
            
        } catch {
            if let monitoringError = error as? DeviceActivityCenter.MonitoringError {
                print("Error while monitoring:::\(monitoringError.errorDescription ?? "")")
            }
        }
        
    }
    
    func stopConcentrationAppShield() {
        guard isAppBlockOn else { return }
        managedSettingsStore.clearAllSettings()
        deviceActivityCenter.stopMonitoring([.concentration])
    }
}


extension DeviceActivityName {
    static let concentration = Self("concentration")
}

extension DeviceActivityEvent.Name {
    static let concentration = Self("concentration")
}

extension ManagedSettingsStore.Name {
    static let concentration = Self("concentration")
}
