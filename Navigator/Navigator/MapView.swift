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
    @State private var isMapOptionsVisible = false
    
    var body: some View {
        // TODO think if displaying your own request view is wise
        // it should come automatically, check other tutorial
            
        ZStack(alignment: .top) {
            if locationManager.userLocation == nil {
                LocationRequestView()
            } else {
                Map(position: $userInitialLocation) {
                    UserAnnotation()
                    if let locations = locationManager.userLocations {
                        MapPolyline(coordinates: locations)
                            .stroke(Color.blue, lineWidth: 12)
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .navigationBarBackButtonHidden(true)
                .onTapGesture {
                    isMapOptionsVisible.toggle()
                }
                
//                VStack {                    
//                    if isMapOptionsVisible {
//                        MapOptionsView()
//                            .cornerRadius(16)
//                            .padding()
//                    }
//                    
//                    Spacer()
//                    
//                    MapStatisticsView()
//                        .background(.white)
//                        .frame(height: 200)
//                        .padding()
//                }
//                .onTapGesture {
//                    isMapOptionsVisible.toggle()
//                }
                SlideOverCard()
            }
        }
    }
}

#Preview {
    MapView()
}
