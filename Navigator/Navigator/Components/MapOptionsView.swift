//
//  MapOptionsView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 16.11.2023.
//

import SwiftUI

struct MapOptionsView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var notificationManager: NotificationManager

    var body: some View {
        HStack {
            Spacer()
            
            Button {
                locationManager.startSession()
            } label: {
                Image(systemName: "play")
            }
            .padding()
            .cornerRadius(12.0)
            .background(locationManager.trackingEnabled ? .green : .red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .font(.system(size: 24))
            
            Spacer()
            
            Button {
                notificationManager.sendNotification(
                    timeInterval: 5,
                    title: "Hey there!",
                    body: "This is a reminder you set 5 seconds ago"
                )
            } label: {
                Image(systemName: "bell.circle")
            }
            .padding()
            .cornerRadius(12.0)
            .background(notificationManager.authorizationStatus != nil ? .green : .red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .font(.system(size: 24))
            
            Spacer()
            
            Button {
                locationManager.addCheckpoint(coordinate: locationManager.userLocation!.coordinate)
            } label: {
                Image(systemName: "mappin.and.ellipse")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .font(.system(size: 24))
            
            Spacer()
            
            Button {
                locationManager.addWaypoint(coordinate: locationManager.userLocation!.coordinate)
            } label: {
                Image(systemName: "pin")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Circle())
            .font(.system(size: 24))
            
            Spacer()
            
            Button {
                locationManager.reset()
            } label: {
                Image(systemName: "gobackward")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.orange)
            .foregroundColor(.white)
            .clipShape(Circle())
            .font(.system(size: 24))
            
            Spacer()
        }
    }
}

#Preview {
    MapOptionsView()
}
