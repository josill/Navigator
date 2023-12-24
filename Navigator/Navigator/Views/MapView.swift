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
    
    @ObservedObject var authHelper = AuthenticationHelper()
    
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var notificationManager: NotificationManager
    
    @State private var userInitialLocation: MapCameraPosition = .userLocation(fallback: .automatic)
    @State var quitSessionPresented = false
    @State var trigger = false
    
    var body: some View {
        ZStack {
            if locationManager.userLocation == nil {
                LocationRequestView()
            }
            //            else if !notificationManager.notificationsAllowed {
            //                NotificationRequestView()
            //            }
            else if authHelper.savedSessionId != nil {
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
                .mapControls {
                    MapUserLocationButton()
                    MapScaleView()
                }
                .mapStyle(.hybrid(elevation: .realistic))
                
//                Button(action: {
//                    trigger.toggle()
//                    quitSessionPresented.toggle()
//                    print(trigger)
//                    print(quitSessionPresented)
////                    authHelper.quitSavedSession()
////                    locationManager.reset()
//                }) {
//                    Text("QUIT")
//                        .font(.title)
//                        .foregroundColor(.red)
//                }
                
                if verticalSizeClass == .compact {
                    SlideUpCardCompact(quitSessionPresented: $quitSessionPresented)
                } else {
                    SlideUpCard(quitSessionPresented: $quitSessionPresented)
                }
            } else {
                MenuView()
            }
        }
        .alert(isPresented: $quitSessionPresented) {
            Alert(
                title: Text("Quit session"),
                message: Text("Are you sure you want to end the session?"),
                primaryButton: .default(Text("Cancel")),
                secondaryButton: .destructive(Text("Quit")) {
                    Task {
                        authHelper.quitSavedSession()
                        locationManager.reset()
                    }
                }
            )
        }
    }
}


#Preview {
    MapView()
}
