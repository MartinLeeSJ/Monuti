//
//  DeviceActivityMonitorExtension.swift
//  AppshieldMonitor
//
//  Created by Martin on 2023/08/11.
//
import Foundation
import DeviceActivity
import ManagedSettings

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ConcentrationMonitorExtension: DeviceActivityMonitor {
//    let store = ManagedSettingsStore()
    
    override func intervalDidStart(for activity: DeviceActivityName) {
//        let model = AppBlockManager()
//        let applicationTokens = model.activitySelection.applicationTokens
//        let webDomainTokens = model.activitySelection.webDomainTokens
//        store.shield.applications = applicationTokens.isEmpty ? nil : applicationTokens
//        store.shield.webDomains = webDomainTokens.isEmpty ? nil : webDomainTokens
//        print("this is working well")
        super.intervalDidStart(for: activity)
        // Handle the start of the interval.
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
//        store.shield.applications = nil
        
        // Handle the end of the interval.
    }
//
//    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
//        super.eventDidReachThreshold(event, activity: activity)
//        print(#function)
//        // Handle the event reaching its threshold.
//    }
//
//    override func intervalWillStartWarning(for activity: DeviceActivityName) {
//        super.intervalWillStartWarning(for: activity)
//        print(#function)
//        // Handle the warning before the interval starts.
//    }
//
//    override func intervalWillEndWarning(for activity: DeviceActivityName) {
//        super.intervalWillEndWarning(for: activity)
//        print(#function)
//        // Handle the warning before the interval ends.
//    }
//
//    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
//        super.eventWillReachThresholdWarning(event, activity: activity)
//        print(#function)
//        // Handle the warning before the event reaches its threshold.
//    }
}
