//
//  MapView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 13.11.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var locationManager: LocationManager
    @State private var userInitialLocation: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {            
        ZStack {
            if locationManager.userLocation == nil {
                LocationRequestView()
            } else {
                MapReader() { reader in
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
                    .onTapGesture(perform: { screencord in
                        let pinLocation = reader.convert(screencord, from: .local)
                        print(pinLocation)
                        locationManager.addCheckpoint(coordinate: pinLocation!)
                        
                    })
                    .mapControls {
                        MapUserLocationButton()
                        MapScaleView()
                    }
                    .mapStyle(.standard(elevation: .realistic))
                    .navigationBarBackButtonHidden(true)
                    .padding(.top, 40)
                }
                
                Text("Checkpoints count: \(locationManager.checkpoints.count)")
                
                SlideOverCard()
            }
        }
    }
}


#Preview {
    MapView()
}
