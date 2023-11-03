//
//  ContentView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 03.11.2023.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    static let university = CLLocationCoordinate2D(latitude: 59.395464, longitude: 24.664184)
}

let track: [CLLocationCoordinate2D] = [
    CLLocationCoordinate2D(latitude: 59.295464, longitude: 24.564184),
    CLLocationCoordinate2D(latitude: 59.395464, longitude: 24.664184),
    CLLocationCoordinate2D(latitude: 59.495464, longitude: 24.764184)
]

struct ContentView: View {
    var body: some View {
        Map {
            Marker("TalTech", coordinate: .university)
            MapPolyline(coordinates: track).stroke(.blue, lineWidth: 13)
        }
    }
}

#Preview {
    ContentView()
}
