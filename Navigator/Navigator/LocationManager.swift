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
    @Published var userLocations: [CLLocationCoordinate2D]?
    @Published var trackingEnabled = false
    @Published var checkpoints: [String: CLLocationCoordinate2D] = [:]
    @Published var waypoint: CLLocationCoordinate2D?
    
    @Published var distanceCovered: Double?
    @Published var distanceFromCp: Double?
    @Published var distanceFromWp: Double?
    @Published var directLineFromCp: Double?
    @Published var directLineFromWp: Double?
    
    @Published var sessionDuration: Double?
    @Published var averageSpeed: Double?
    @Published var averageSpeedFromCp: Double?
    @Published var averageSpeedFromWp: Double?
    
    static let shared = LocationManager() // access LocationManager from anywhere in the project
    
    override init() {
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        self.setup()
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
    }
    
    private func setup() {
        if CLLocationManager.headingAvailable() {
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
        }
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
        
        addUserLocation(location: location)
        
        calculateDistance()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        CompassManager.shared.degrees = -1 * newHeading.magneticHeading
    }
    
    func addUserLocation(location: CLLocation) {
        if trackingEnabled {
            if let previousLocation = userLocations?.last {
                let distance = location.distance(from: CLLocation(latitude: previousLocation.latitude, longitude: previousLocation.longitude))
                
                if distance > 0 && distance <= 10.0 { userLocations!.append(location.coordinate) }
            } else {
                userLocations = [location.coordinate]
            }
        }
        
        self.userLocation = location
    }
    
    func addCheckpoint() {
        if trackingEnabled {
            let checkpointName = "Checkpoint \(checkpoints.count + 1)"
            checkpoints[checkpointName] = userLocation!.coordinate
        }
    }
    
    func addWaypoint() {
        if trackingEnabled {
            waypoint = userLocation!.coordinate
        }
    }
    
    func reset() {
        userLocations = nil
        checkpoints = [:]
        waypoint = nil
    }
    
    private func calculateDistance() {
        guard let locations = userLocations, locations.count >= 2 else { return }

        let firstLocation = CLLocation(latitude: locations.first!.latitude, longitude: locations.first!.longitude)
        let lastLocation = CLLocation(latitude: locations.last!.latitude, longitude: locations.last!.longitude)

        distanceCovered = firstLocation.distance(from: lastLocation)

        print("Distance from the first to the last point: \(distanceCovered) meters")
    }

}
