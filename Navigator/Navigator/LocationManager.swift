//
//  LocationManager.swift
//  Navigator
//
//  Created by Jonathan Sillak on 14.11.2023.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    static let shared = LocationManager() // access LocationManager from anywhere in the project
    
    override init() {
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .notDetermined:
//            print("DEBUG: Not Determined")
//        case .restricted:
//            print("DEBUG: Restricted")
//        case .denied:
//            print("DEBUG: Not Determined")
//        case .authorizedAlways:
//            print("DEBUG: Not Determined")
//        case .authorizedWhenInUse:
//            print("DEBUG: Not Determined")
//        @unknown default:
//            break
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }
}
