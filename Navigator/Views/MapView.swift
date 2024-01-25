//
//  MapView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 13.11.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @EnvironmentObject var notificationManager: NotificationManager

    @StateObject private var authHelper = AuthenticationHelper.shared
    @StateObject private var locationManager = LocationManager.shared
    
    @State private var userInitialLocation: MapCameraPosition = .userLocation(fallback: .automatic)
    @State var quitSessionPresented = false
    
    var session: Session?
    
    var body: some View {
        ZStack {
            Map(position: $userInitialLocation) {
                UserAnnotation()
                
                if let locations = session?.locations {
                    let sortedLocations = locations.sorted { $0.createdAt < $1.createdAt }
                    let coordinates = sortedLocations.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
                    MapPolyline(coordinates: coordinates)
                        .stroke(Color.blue, lineWidth: 12)
                }

                if let locations = locationManager.userLocations {
                    MapPolyline(coordinates: locations)
                        .stroke(Color.blue, lineWidth: 12)
                }

                if let waypointFromLocationManager = locationManager.waypoint {
                    Annotation(
                        "Waypoint",
                        coordinate: waypointFromLocationManager,
                        anchor: .bottom) {
                            Image(systemName: "pin")
                                .padding(4)
                                .foregroundStyle(.white)
                                .background(.blue)
                                .cornerRadius(4)
                        }
                }
                
                if let waypointFromSession = session?.locations.last(where: { $0.locationType == .wayPoint }) {
                    Annotation(
                        "Waypoint",
                        coordinate: CLLocationCoordinate2D(latitude: waypointFromSession.latitude, longitude: waypointFromSession.longitude),
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
            .mapControls {
                MapUserLocationButton()
                MapScaleView()
            }
            .padding(.top, 40)
            .mapStyle(.hybrid(elevation: .realistic))
            
            if verticalSizeClass == .compact {
                SlideUpCardCompact(quitSessionPresented: $quitSessionPresented)
            } else {
                SlideUpCard(quitSessionPresented: $quitSessionPresented)
            }
        }
//        .onChange(of: locationManager.waypoint) { waypoint in
//                
//        }
    }
}


#Preview {
    MapView()
}
