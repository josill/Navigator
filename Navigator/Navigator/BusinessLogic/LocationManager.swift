//
//  LocationManager.swift
//  Navigator
//
//  Created by Jonathan Sillak on 14.11.2023.
//

import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    private var timer: Timer?
    
    @Published var userLocation: CLLocation?
    @Published var userLocations: [CLLocationCoordinate2D]?
    @Published var trackingEnabled = false
    @Published var checkpoints: [String: CLLocationCoordinate2D] = [:]
    @Published var waypoint: CLLocationCoordinate2D?
    
    @Published var distanceCovered = 0.0
    @Published var distanceFromCp = 0.0
    @Published var distanceFromWp = 0.0
    @Published var directLineFromCp = 0.0
    @Published var directLineFromWp = 0.0
    
    @Published var sessionDurationSec = 0.0
    @Published var sessionDuration = "00:00:00"
    @Published var sessionDurationBeforeCp = 0.0
    @Published var sessionDurationBeforeWp = 0.0
    @Published var averageSpeed = 0.0
    @Published var averageSpeedFromCp = 0.0
    @Published var averageSpeedFromWp = 0.0
    
    static let shared = LocationManager() // access LocationManager from anywhere in the project
    
    override init() {
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 1.0
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

        if trackingEnabled {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                self?.updateElapsedTime()
            }
        } else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func addUserLocation(location: CLLocation) {
        if trackingEnabled {
            if let previousLocation = userLocations?.last {
                let distance = location.distance(from: CLLocation(latitude: previousLocation.latitude, longitude: previousLocation.longitude))
                
                if distance > 0 && distance <= 2.0 { userLocations!.append(location.coordinate)
                }
            } else {
                userLocations = [location.coordinate]
            }
        }
        
        self.userLocation = location
    }
    
    
    func addCheckpoint(coordinate: CLLocationCoordinate2D) {
        if trackingEnabled {
            let checkpointName = "Checkpoint \(checkpoints.count + 1)"
            checkpoints[checkpointName] = coordinate
            print(checkpoints)
            
            distanceFromCp = 0.0
            directLineFromCp = 0.0
            sessionDurationBeforeCp = sessionDurationSec
        }
    }
    
    func addWaypoint(coordinate: CLLocationCoordinate2D) {
        if trackingEnabled {
            waypoint = coordinate
            
            distanceFromWp = 0.0
            directLineFromWp = 0.0
            sessionDurationBeforeWp = sessionDurationSec
        }
    }
    
    func reset() {
        timer?.invalidate()
        timer = nil
        
        userLocations = nil
        checkpoints = [:]
        waypoint = nil
        
        distanceCovered = 0.0
        sessionDuration = "00:00:00"
        sessionDurationSec = 0.0
        distanceFromCp = 0.0
        directLineFromCp = 0.0
        distanceFromWp = 0.0
        directLineFromWp = 0.0
    }
    
    private func updateStatistics() {
        calculateDistances()
        calculateSpeeds()
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
        distanceCovered += lastLocation.distance(from: secondToLastLocation)
    }

    private func calculateDistanceFromCp(secondToLastLocation: CLLocation, lastLocation: CLLocation) {
        guard let lastCheckpointKey = checkpoints.keys.sorted().last, let lastCheckpoint = checkpoints[lastCheckpointKey] else { return }

        let lastCheckpointLocation = CLLocation(latitude: lastCheckpoint.latitude, longitude: lastCheckpoint.longitude)

        distanceFromCp += lastLocation.distance(from: secondToLastLocation)

        directLineFromCp = lastLocation.distance(from: lastCheckpointLocation)
    }

    private func calculateDistanceFromWp(secondToLastLocation: CLLocation, lastLocation: CLLocation) {
        guard waypoint != nil else { return }
        
        let waypointLocation = CLLocation(latitude: waypoint!.latitude, longitude: waypoint!.longitude)
        
        distanceFromWp += lastLocation.distance(from: secondToLastLocation)
        
        directLineFromWp = lastLocation.distance(from: waypointLocation)
    }
    
    private func calculateSpeeds() {
        if timer != nil {
            averageSpeed = (distanceCovered / sessionDurationSec) * 3.6
        }
        
        
        if checkpoints.count > 0 {
            averageSpeedFromCp = (distanceFromCp / (sessionDurationSec - sessionDurationBeforeCp)) * 3.6
        }
        
        if waypoint != nil {
            averageSpeedFromWp = (distanceFromWp / (sessionDurationSec - sessionDurationBeforeWp)) * 3.6
        }
    }
    
    private func updateElapsedTime() {
        sessionDurationSec += 1.0

        let hours = Int(sessionDurationSec) / 3600
        let minutes = (Int(sessionDurationSec) % 3600) / 60
        let seconds = Int(sessionDurationSec) % 60

        sessionDuration = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
