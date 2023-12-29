//
//  LocationRequestView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 14.11.2023.
//

import SwiftUI
import CoreLocation

struct LocationRequestView: View {
    @StateObject private var locationManager = LocationManager.shared
    
    @EnvironmentObject private var router: Router
    @EnvironmentObject var notificationManager: NotificationManager
        
    var body: some View {
        ZStack {
            Color
                .black
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 32)
                    .foregroundColor(.white)
                
                Text("Please share your location with us")
                    .font(.title)
                    .padding()
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                VStack {
                    Button {
                        locationManager.requestLocation()
                    } label: {
                        Text("Allow location")
                            .padding()
                            .foregroundColor(.white.opacity(0.9))
                            .font(.headline)
                    }
                    .cornerRadius(12.0)
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.horizontal, -32)
                    .background(.blue)
                    .clipShape(Capsule())
                }
                .padding(32)
            }
        }
        .onReceive(locationManager.$authorizationStatus) { newAuthorizationStatus in
            if newAuthorizationStatus == .authorizedWhenInUse || newAuthorizationStatus == .authorizedAlways {
                if notificationManager.authorizationStatus == .authorized {
                    router.changeRoute(.init(.map))
                } else {
                    router.changeRoute(.init(.notificationsAllowed))
                }
            }
        }
    }
}

#Preview {
    LocationRequestView()
}
