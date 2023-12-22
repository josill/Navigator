//
//  ContentView.swift
//  gpsmapdemo23f
//
//  Created by Jonathan Sillak on 22.12.2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject var locationVM: LocationViewModel
    
    var body: some View {
        switch locationVM.authorizationStatus {
        case .notDetermined:
            RequestLocationView()
        case .restricted:
            Text("restricted")
        case .denied:
            Text("denied")
        case .authorized, .authorizedAlways, .authorizedWhenInUse:
            TrackingView()
        @unknown default:
            Text("Unknown status")
        }
    }
}

extension CLLocationCoordinate2D {
    static let raekoda = CLLocationCoordinate2D(latitude: 59.436996, longitude: 24.7427928)
    static let itCollege = CLLocationCoordinate2D(latitude: 59.395446, longitude: 24.664294)
}

#Preview {
    ContentView()
        .environmentObject(LocationViewModel())
}
