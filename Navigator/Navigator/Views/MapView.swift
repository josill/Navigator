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
            
        ZStack {
            if locationManager.userLocation == nil {
                LocationRequestView()
            } else {
                Map(position: $userInitialLocation) {
                    UserAnnotation()
                    
                    if let locations = locationManager.userLocations {
                        MapPolyline(coordinates: locations)
                            .stroke(Color.blue, lineWidth: 12)
                    }
                    
                    if let waypoint = locationManager.waypoint {
                        Annotation(
                            "Waypoint",
                            coordinate: waypoint,
                            anchor: .bottom) {
                            Image(systemName: "pin")
                                    .padding(4)
                                    .foregroundStyle(.white)
                                    .background(.blue)
                                    .cornerRadius(4)
                        }
                    }
                                        
                    ForEach(locationManager.checkpoints.keys.sorted(), id: \.self) { key in
                        if let checkpoint = locationManager.checkpoints[key] {
                            Annotation(
                                key,
                                coordinate: checkpoint,
                                anchor: .bottom) {
                                Image(systemName: "mappin.and.ellipse")
                                        .padding(4)
                                        .foregroundStyle(.white)
                                        .background(.red)
                                        .cornerRadius(4)
                            }
                        }
                    }
                }
                .onTapGesture { location in
                    let tapCoordinate = CLLocationCoordinate2D(
                        latitude: mapCoordinate(from: location).latitude,
                        longitude: mapCoordinate(from: location).longitude
                    )
                    print(tapCoordinate)
                    locationManager.addCheckpoint(coordinate: tapCoordinate)
                }
                .mapControls {
                    MapUserLocationButton()
                    MapScaleView()
                }
                .mapStyle(.standard(elevation: .realistic))
                .navigationBarBackButtonHidden(true)
                .padding(.top, 40)
                
                SlideOverCard()
            }
        }
    }
    
    private func mapCoordinate(from point: CGPoint) -> CLLocationCoordinate2D {
        let location = self.pointToCoordinate(point, in: .global)
        return location
    }
    
    private func pointToCoordinate(_ point: CGPoint, in coordinateSpace: CoordinateSpace) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: Double(point.y),
            longitude: Double(point.x)
        )
    }
}

#Preview {
    MapView()
}
