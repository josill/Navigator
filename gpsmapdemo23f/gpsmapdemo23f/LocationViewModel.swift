//
//  LocationViewModel.swift
//  gpsmapdemo23f
//
//  Created by Jonathan Sillak on 22.12.2023.
//

import Foundation
import CoreLocation

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var lastLocation: CLLocation?
    
    @Published var distance: Double = 0
    @Published var track: [CLLocation] = []
    
    private let locationManager = CLLocationManager()
    
    override init() {
        locationManager.allowsBackgroundLocationUpdates = true
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        
        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        // added these
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let curLocation = locations.last {
            if let lastSeenLocation = lastLocation {
                distance = distance + lastSeenLocation.distance(from: curLocation)
            }
            
            lastLocation = locations.last
            track.append(contentsOf: locations)
        }
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
}
