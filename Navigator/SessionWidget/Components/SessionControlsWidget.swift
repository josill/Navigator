//
//  SessionControlsWidget.swift
//  Navigator
//
//  Created by Jonathan Sillak on 29.12.2023.
//

import SwiftUI
import ActivityKit

struct SessionControlsWidget: View {
    var locationManager = LocationManager()
    var notificationManager = NotificationManager()
    
    var body: some View {
        HStack {
            Spacer()
            
            Button {
                locationManager.startSession()
                startActivity()
//                listAllActivities()
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
                notificationManager.changeNotificationsEnabled()
            } label: {
                Image(systemName: "bell.circle")
            }
            .padding()
            .cornerRadius(12.0)
            .background(notificationManager.notificationsEnabled ? .green : .red)
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
                //                        quitSessionPresented.toggle()
            } label: {
                Image(systemName: "power")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .font(.system(size: 24))
            
            Spacer()
        }
    }
    
    func startActivity() {
        let session = SessionAttributes()
        let initialState = SessionAttributes.ContentState(
            sessionDistance: 0.0,
            sessionDuration: "00:00:00",
            sessionSpeed: 0.0
        )
        
        let content = ActivityContent(state: initialState, staleDate: nil)
        
        let _ = try? Activity.request(
            attributes: session,
            content: content,
            pushType: nil
        )
    }
}

#Preview {    
    SessionControlsWidget()
        .environmentObject(LocationManager())
        .environmentObject(NotificationManager())
}
