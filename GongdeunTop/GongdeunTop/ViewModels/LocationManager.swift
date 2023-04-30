//
//  LocationManager.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/28.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var lastSeenLocation: CLLocation?
    @Published var currentPlacemark: CLPlacemark?
    
    private let coreLocationManager: CLLocationManager
    
    override init() {
        coreLocationManager = CLLocationManager()
        authorizationStatus = coreLocationManager.authorizationStatus
        
        super.init()
        coreLocationManager.delegate = self
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        coreLocationManager.startUpdatingLocation()
    }
    
    
    func requestPermission() {
        coreLocationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    private func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) async {
        lastSeenLocation = locations.first
        await fetchCountryAndCity(for: locations.first)
    }

    func fetchCountryAndCity(for location: CLLocation?) async {
        guard let location = location else { return }
        do {
            let geocoder = CLGeocoder()
            self.currentPlacemark = try await geocoder.reverseGeocodeLocation(location).first
        } catch {
            print(error.localizedDescription)
        }
    }
}
