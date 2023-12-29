//
//  MapOptionsView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 16.11.2023.
//

import SwiftUI
import ActivityKit

struct SessionControls: View {
    @StateObject private var authHelper = AuthenticationHelper.shared
    @StateObject private var sessionManager = SessionManager.shared
    @StateObject private var locationManager = LocationManager.shared
    
    @EnvironmentObject private var router: Router
    @EnvironmentObject var notificationManager: NotificationManager
    
    @Binding var quitSessionPresented: Bool
    @State var  activities = Activity<SessionAttributes>.activities

    var body: some View {
        HStack {
            Spacer()
            
            Button {
                locationManager.startOrStopSession()
                
                if locationManager.trackingEnabled {
                    sessionManager.startActivity()
                    listAllActivities()
                }
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
                locationManager.addCheckpoint()
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
                locationManager.addWaypoint()
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
                quitSessionPresented.toggle()
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
        
        ScrollView {
            ForEach(activities, id: \.id) { activity in
                let courierName = activity.content.state.sessionDuration
                let deliveryTime = activity.content.state.sessionSpeed
                HStack(alignment: .center) {
                    Text(courierName)
                    Text("\(deliveryTime)")
                }
            }
        }
        
        .alert(isPresented: $quitSessionPresented) {
            Alert(
                title: Text("Quit session"),
                message: Text("Are you sure you want to end the session?"),
                primaryButton: .default(Text("Cancel")),
                secondaryButton: .destructive(Text("Quit")) {
                    Task {
                        router.backToMenuRoute()
//                        authHelper.quitSavedSession()
//                        locationManager.reset()
                    }
                }
            )
        }
    }
        func listAllActivities() {
            var activities = Activity<SessionAttributes>.activities
            activities.sort { $0.id > $1.id }
            self.activities = activities
        }
}

#Preview {
    SessionControls(quitSessionPresented: .constant(false))
}
