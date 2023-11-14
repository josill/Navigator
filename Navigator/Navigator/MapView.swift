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
    @State private var userPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
        // TODO think if displaying your own request view is wise
        // it should come automatically, check other tutorial
        
        Group {
            if locationManager.userLocation == nil {
                LocationRequestView()
            } else {
                Text("\(locationManager.userLocation!)")
                Map(position: $userPosition) {
                    
                }
                .mapStyle(.standard(elevation: .realistic))
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    MapView()
}
