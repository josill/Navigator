//
//  MapView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 13.11.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
//    @Environment(\.verticalSizeClass) var verticalSizeClass
//    
//    @StateObject private var authHelper = AuthenticationHelper.shared
//
//    @EnvironmentObject var locationManager: LocationManager
//    @EnvironmentObject var notificationManager: NotificationManager
//    
//    @State private var userInitialLocation: MapCameraPosition = .userLocation(fallback: .automatic)
//    @State var quitSessionPresented = false
    
    var body: some View {
        ZStack {
            Text("Hello world")
        }
//        .alert(isPresented: $quitSessionPresented) {
//            Alert(
//                title: Text("Quit session"),
//                message: Text("Are you sure you want to end the session?"),
//                primaryButton: .default(Text("Cancel")),
//                secondaryButton: .destructive(Text("Quit")) {
//                    Task {
//                        authHelper.quitSavedSession()
//                        locationManager.reset()
//                    }
//                }
//            )
//        }
    }
}


#Preview {
    MapView()
}
