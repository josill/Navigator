//
//  LocationManager.swift
//  Navigator
//
//  Created by Jonathan Sillak on 14.11.2023.
//

import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus? = nil
    
    let mapView =  MKMapView()
    @Published var mapHelper: MapHelper?
    private var authHelper = AuthenticationHelper.shared
    private var timer: Timer?
    
    @Published var userLocation: CLLocation?
    @Published var userLocations: [CLLocationCoordinate2D]?
    @Published var trackingEnabled = false
    @Published var checkpoints: [String: CLLocationCoordinate2D] = [:]
    @Published var waypoint: CLLocationCoordinate2D? = nil
    
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
    
    override init() {
        super.init()
        
        manager.allowsBackgroundLocationUpdates = true
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        // manager.distanceFilter = 10.0
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
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
        
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        addUserLocation(location: location)
        calculateSpeeds()
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
        
        if let userLocation {
            mapHelper = MapHelper(mapView: mapView, userLocation: userLocation)
        }
    }
    
    func addUserLocation(location: CLLocation) {
        if trackingEnabled {
            if let previousLocation = userLocations?.last {
                let distance = location.distance(from: CLLocation(latitude: previousLocation.latitude, longitude: previousLocation.longitude))
                
                if distance > 1 && distance <= 5.0 {
                    Task {
                        await authHelper.updateLocation(
                            latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude,
                            locationType: .location)
                    }
                    
                    userLocations!.append(location.coordinate)
                    calculateDistances()
                }
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
            
            Task {
                await authHelper.updateLocation(
                    latitude: userLocation!.coordinate.latitude,
                    longitude: userLocation!.coordinate.longitude,
                    locationType: .checkPoint)
            }
        
            Task { @MainActor in
                distanceFromCp = 0.0
                directLineFromCp = 0.0
                sessionDurationBeforeCp = sessionDurationSec
            }
            
            print("addCheckpoint:")
            print(checkpoints)
        }
    }
    
    func addWaypoint() {
        if trackingEnabled {   
            Task { @MainActor in
                waypoint = userLocation!.coordinate
            }
            
            Task {
                await authHelper.updateLocation(
                    latitude: userLocation!.coordinate.latitude,
                    longitude: userLocation!.coordinate.longitude,
                    locationType: .checkPoint)
            }
            
            Task { @MainActor in
                distanceFromWp = 0.0
                directLineFromWp = 0.0
                sessionDurationBeforeWp = sessionDurationSec
            }
        }
        print("addWaypoint:")
        print(waypoint)
    }
    
    func reset() {
        trackingEnabled = false
        
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
    
    //    private func updateStatistics() {
    //        calculateDistances()
    //        calculateSpeeds()
    //    }
    
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
