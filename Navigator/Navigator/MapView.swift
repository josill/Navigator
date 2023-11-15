//
//  MapView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 13.11.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    // TODO do this without shared?
    @ObservedObject var locationManager = LocationManager.shared
    @State private var userInitialLocation: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
        // TODO think if displaying your own request view is wise
        // it should come automatically, check other tutorial
        
        Group {
            if locationManager.userLocation == nil {
                LocationRequestView()
            } else {
                Text("\(locationManager.userLocation!)")
                Map(position: $userInitialLocation) {
                    UserAnnotation()
                    if let locations = locationManager.userLocations {
                        MapPolyline(coordinates: locations)
                            .stroke(Color.blue, lineWidth: 12)
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

extension CLLocationCoordinate2D {
    static let bigBen = CLLocationCoordinate2D(latitude: 51.500685, longitude: -0.124570)
    static let towerBridge = CLLocationCoordinate2D(latitude: 51.505507, longitude: -0.075402)
}

#Preview {
    MapView()
}
