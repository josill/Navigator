//
//  LocationManager.swift
//  Navigator
//
//  Created by Jonathan Sillak on 14.11.2023.
//

import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, @unchecked Sendable {
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus? = nil
    
    let mapView =  MKMapView()
    @Published var mapHelper: MapHelper?
    private var authHelper = AuthenticationHelper.shared
    private var sessionData = SessionData.shared
    
    @Published var userLocation: CLLocation?
    @Published var userLocations: [CLLocationCoordinate2D]?
    @Published var checkpoints: [String: CLLocationCoordinate2D] = [:]
    @Published var waypoint: CLLocationCoordinate2D? = nil
    
    override init() {
        super.init()
        
        manager.allowsBackgroundLocationUpdates = true
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        // manager.distanceFilter = 10.0
        self.setup()
        print("init loc")
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
    
    func startOrStopSession() {
        sessionData.setSessionActive()
        
        if sessionData.sessionActive {
            sessionData.startTimer()
        } else {
            sessionData.stopTimer()
        }
        
        if let userLocation {
            mapHelper = MapHelper(mapView: mapView, userLocation: userLocation)
        }
    }
    
    func addUserLocation(location: CLLocation) {
        if sessionData.sessionActive {
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
        if sessionData.sessionActive {
            let checkpointName = "Checkpoint \(checkpoints.count + 1)"
            checkpoints[checkpointName] = userLocation!.coordinate
            
            Task {
                await authHelper.updateLocation(
                    latitude: userLocation!.coordinate.latitude,
                    longitude: userLocation!.coordinate.longitude,
                    locationType: .checkPoint)
            }
            
            Task { @MainActor in
                sessionData.updateDistance(for: .checkpoint, distance: 0.0)
                sessionData.updateDirectLineDistance(for: .checkpoint, distance: 0.0)
                sessionData.updateSessionDuration(time: sessionData.sessionDurationSec)
            }
        } else {
            print("no user location")
        }
    }
    
    func addWaypoint() {
        if sessionData.sessionActive {
            Task { @MainActor in
                waypoint = userLocation!.coordinate
            }
            
            Task {
                await authHelper.updateLocation(
                    latitude: userLocation!.coordinate.latitude,
                    longitude: userLocation!.coordinate.longitude,
                    locationType: .wayPoint)
            }
            
            Task { @MainActor in
                sessionData.updateDistance(for: .waypoint, distance: 0.0)
                sessionData.updateDirectLineDistance(for: .waypoint, distance: 0.0)
                sessionData.updateSessionDuration(time: sessionData.sessionDurationSec)
            }
        }
    }
    
    func reset() {
        sessionData.sessionActive = false
        userLocations = nil
        checkpoints = [:]
        waypoint = nil
        
        sessionData.reset()
    }
    
    private func calculateDistances() {
        guard let locations = userLocations, locations.count >= 2 else { return }
        
        let lastLocation = CLLocation(latitude: locations.last!.latitude, longitude: locations.last!.longitude)
        let secondToLastLocation = CLLocation(latitude: userLocations![userLocations!.count - 2].latitude, longitude: userLocations![userLocations!.count - 2].longitude)
        
        calculateDistanceCovered(secondToLastLocation: secondToLastLocation, lastLocation: lastLocation)
        calculateDistanceFromCp(secondToLastLocation: secondToLastLocation, lastLocation: lastLocation)
        calculateDistanceFromWp(secondToLastLocation: secondToLastLocation, lastLocation: lastLocation)
    }
    
    private func calculateDistanceCovered(secondToLastLocation: CLLocation, lastLocation: CLLocation) {
        //        distanceCovered += lastLocation.distance(from: secondToLastLocation)
        sessionData.updateDistance(for: .none, distance: lastLocation.distance(from: secondToLastLocation))
    }
    
    private func calculateDistanceFromCp(secondToLastLocation: CLLocation, lastLocation: CLLocation) {
        guard let lastCheckpointKey = checkpoints.keys.sorted().last, let lastCheckpoint = checkpoints[lastCheckpointKey] else { return }
        
        let lastCheckpointLocation = CLLocation(latitude: lastCheckpoint.latitude, longitude: lastCheckpoint.longitude)
        
        sessionData.updateDistance(for: .checkpoint, distance: lastLocation.distance(from: secondToLastLocation))
        sessionData.updateDirectLineDistance(for: .checkpoint, distance: lastLocation.distance(from: lastCheckpointLocation))
    }
    
    private func calculateDistanceFromWp(secondToLastLocation: CLLocation, lastLocation: CLLocation) {
        guard waypoint != nil else { return }
        
        let waypointLocation = CLLocation(latitude: waypoint!.latitude, longitude: waypoint!.longitude)
        
        sessionData.updateDistance(for: .waypoint, distance: lastLocation.distance(from: secondToLastLocation))
        sessionData.updateDirectLineDistance(for: .waypoint, distance: lastLocation.distance(from: waypointLocation))
    }
    
    private func calculateSpeeds() {
        if sessionData.timer != nil {
            let speed = (sessionData.distanceCovered / sessionData.sessionDurationSec) * 3.6
            sessionData.updateSpeed(for: .none,speed: speed)
        }
        
        if checkpoints.count > 0 {
            let speed = (sessionData.distanceFromCp / (sessionData.sessionDurationSec - sessionData.sessionDurationBeforeCp)) * 3.6
            sessionData.updateSpeed(for: .checkpoint, speed: speed)
        }
        
        if waypoint != nil {
            let speed = (sessionData.distanceFromWp / (sessionData.sessionDurationSec - sessionData.sessionDurationBeforeWp)) * 3.6
            sessionData.updateSpeed(for: .waypoint, speed: speed)
        }
    }
}
