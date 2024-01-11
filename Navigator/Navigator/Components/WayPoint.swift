//
//  WayPoint.swift
//  Navigator
//
//  Created by Jonathan Sillak on 11.01.2024.
//

import SwiftUI
import MapKit

struct WayPoint: View {
    let coordinate: CLLocationCoordinate2D
    
    var body: some View {
        Annotation(
            "Waypoint",
            coordinate: coordinate,
            anchor: .bottom) {
                Image(systemName: "pin")
                    .padding(4)
                    .foregroundStyle(.white)
                    .background(.blue)
                    .cornerRadius(4)
            }
    }
}
