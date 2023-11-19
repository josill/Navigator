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
        updateStatistics()
        
        calculateDistances()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        CompassManager.shared.degrees = -1 * newHeading.magneticHeading
    }
    
    func startSession() {
        trackingEnabled = !trackingEnabled
        // TODO: implement Timer class
        // TODO: implement average speed calculation
    }
    
    func addUserLocation(location: CLLocation) {
        if trackingEnabled {
            if let previousLocation = userLocations?.last {
                let distance = location.distance(from: CLLocation(latitude: previousLocation.latitude, longitude: previousLocation.longitude))
                
                if distance > 0 && distance <= 3.0 { userLocations!.append(location.coordinate) }
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
            
            distanceFromCp = 0.0
            directLineFromCp = 0.0
        }
    }
    
    func addWaypoint() {
        if trackingEnabled {
            waypoint = userLocation!.coordinate
            
            distanceFromWp = 0.0
            directLineFromWp = 0.0
        }
    }
    
    func reset() {
        userLocations = nil
        checkpoints = [:]
        waypoint = nil
        
        distanceFromCp = 0.0
        directLineFromCp = 0.0
        distanceFromWp = 0.0
        directLineFromWp = 0.0
    }
    
    private func updateStatistics() {
        calculateDistances()
        // TODO other methods
    }
    
    private func calculateDistances() {
        guard let locations = userLocations, locations.count >= 2 else { return }
        
        let lastLocation = CLLocation(latitude: locations.last!.latitude, longitude: locations.last!.longitude)
        let secondToLastLocation = CLLocation(latitude: userLocations![userLocations!.count - 2].latitude, longitude: userLocations![userLocations!.count - 2].longitude)
        
        calculateDistanceCovered(secondToLastLocation: secondToLastLocation, lastLocation: lastLocation)
        // TODO: disatance covered, from checkpoint and waypoint increases too rapidly
        calculateDistanceFromCp(secondToLastLocation: secondToLastLocation, lastLocation: lastLocation)
        calculateDistanceFromWp(secondToLastLocation: secondToLastLocation, lastLocation: lastLocation)
    }
    
    private func calculateDistanceCovered(secondToLastLocation: CLLocation, lastLocation: CLLocation) {
        if distanceCovered != nil { distanceCovered! += lastLocation.distance(from: secondToLastLocation) }
        else { distanceCovered = lastLocation.distance(from: secondToLastLocation) }
    }

    private func calculateDistanceFromCp(secondToLastLocation: CLLocation, lastLocation: CLLocation) {
        guard let lastCheckpointKey = checkpoints.keys.sorted().last, let lastCheckpoint = checkpoints[lastCheckpointKey] else { return }

        let lastCheckpointLocation = CLLocation(latitude: lastCheckpoint.latitude, longitude: lastCheckpoint.longitude)

        if let currentDistance = distanceFromCp { distanceFromCp! += lastLocation.distance(from: secondToLastLocation) }
        else { distanceFromCp = lastLocation.distance(from: secondToLastLocation) }

        directLineFromCp = lastLocation.distance(from: lastCheckpointLocation)
    }

    private func calculateDistanceFromWp(secondToLastLocation: CLLocation, lastLocation: CLLocation) {
        guard waypoint != nil else { return }
        
        let waypointLocation = CLLocation(latitude: waypoint!.latitude, longitude: waypoint!.longitude)
        
        if distanceFromWp != nil { distanceFromWp! += lastLocation.distance(from: secondToLastLocation) }
        else { distanceFromWp = lastLocation.distance(from: secondToLastLocation) }
        
        directLineFromWp = lastLocation.distance(from: waypointLocation)
    }
}