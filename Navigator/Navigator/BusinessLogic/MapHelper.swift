//
//  MapHelper.swift
//  Navigator
//
//  Created by Jonathan Sillak on 21.11.2023.
//

import Foundation
import MapKit

class MapHelper {
    
    init(mapView: MKMapView, userLocation: CLLocation) {
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: false)
    }

    func convertLocationToRegion(location: CLLocation?, mapView: MKMapView) {
        guard let coordinate = location?.coordinate else {
            return
        }
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: false)
    }
}
