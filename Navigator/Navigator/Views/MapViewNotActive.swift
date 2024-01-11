//
//  MapView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 13.11.2023.
//

import SwiftUI
import MapKit

struct MapViewNotActive: View {    
    var session: Session
    
    var body: some View {
        ZStack {
            Map() {
                let coordinates = session.locations
                    .filter { $0.locationType == .location }
                    .sorted { $0.createdAt < $1.createdAt }
                    .map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
                
                MapPolyline(coordinates: coordinates)
                    .stroke(Color.blue, lineWidth: 5)
                
                if let waypoint = session.locations.last(where: { $0.locationType == .wayPoint }) {
                    Annotation(
                        "Waypoint",
                        coordinate: CLLocationCoordinate2D(latitude: waypoint.latitude, longitude: waypoint.longitude),
                        anchor: .bottom) {
                            Image(systemName: "pin")
                                .padding(4)
                                .foregroundStyle(.white)
                                .background(.blue)
                                .cornerRadius(4)
                        }
                }
                
                let checkpoints = session.locations
                    .filter { $0.locationType == .checkPoint }
                    .sorted { $0.createdAt < $1.createdAt }

                ForEach(Array(zip(checkpoints.indices, checkpoints)), id: \.0) { i, cp in
                    Annotation(
                        "Checkpoint \(i+1)",
                        coordinate: CLLocationCoordinate2D(latitude: cp.latitude, longitude: cp.longitude),
                        anchor: .bottom) {
                            Image(systemName: "mappin.and.ellipse")
                                .padding(4)
                                .foregroundStyle(.white)
                                .background(.red)
                                .cornerRadius(4)
                        }
                }
                
            }
            .mapControls {
                MapScaleView()
            }
            .mapStyle(.hybrid(elevation: .realistic))
            
//            if verticalSizeClass == .compact {
//                SlideUpCardCompact(quitSessionPresented: $quitSessionPresented)
//            } else {
//                SlideUpCard(quitSessionPresented: $quitSessionPresented)
//            }
        }
//        .onChange(of: locationManager.waypoint) { waypoint in
//
//        }
    }
}


#Preview {
    MapView()
}
