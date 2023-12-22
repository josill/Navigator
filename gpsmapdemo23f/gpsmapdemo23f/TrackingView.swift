//
//  TrackingView.swift
//  gpsmapdemo23f
//
//  Created by Jonathan Sillak on 22.12.2023.
//

import SwiftUI
import MapKit

struct TrackingView: View {
    @EnvironmentObject var locationVM: LocationViewModel
    
    var lastLocation: CLLocation? {
        locationVM.lastLocation
    }
    
    var lastCoordinate: CLLocationCoordinate2D? {
        lastLocation?.coordinate
    }
    
    var body: some View {
        VStack {
            PairView("Latitude", String(lastCoordinate?.latitude ?? 0))
            PairView("Longitude", String(lastCoordinate?.longitude ?? 0))
            PairView("Altitude", String(lastLocation?.altitude ?? 0))
            PairView("Speed", String(lastLocation?.speed ?? 0))
            PairView("Distance", String(locationVM.distance ))
            PairView("Track point count", String(locationVM.track.count ))
        }
        .padding()
        
        Map()
            .mapControls {
                MapCompass()
                MapPitchToggle()
                MapScaleView()
                MapUserLocationButton()
            }
            .mapControlVisibility(.visible)
            .mapStyle(.hybrid(elevation: .realistic, showsTraffic: true))
    }
}

#Preview {
    TrackingView()
        .environmentObject(LocationViewModel())
}
