//
//  CreateSessionView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 12.12.2023.
//

import SwiftUI

struct CreateSessionView: View {
    @StateObject private var authHelper = AuthenticationHelper.shared
    @StateObject private var locationManager = LocationManager.shared

    @EnvironmentObject private var router: Router
    @EnvironmentObject var notificationManager: NotificationManager
    
    @State private var sessionName = ""
    @State private var sessionDescription = ""
    
    @State private var selectedValue = 0
    let values = ["figure.walk", "figure.run"]
    
    var body: some View {
        ZStack {
            Color
                .black
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                VStack {
                    HStack {
                        Image(systemName: "figure.hiking")
                            .foregroundColor(.white)
                        
                        Text("Create session")
                            .font(.title)
                            .padding()
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    TextField(
                        "Session name",
                        text: $sessionName,
                        prompt: Text("Session name").foregroundColor(.black.opacity(0.6))
                    )
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(.white)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .border(.red, width: CGFloat(authHelper.sessionNameError ? 3 : 0))
                    
                    TextField(
                        "Session description",
                        text: $sessionDescription,
                        prompt: Text("Session description").foregroundColor(.black.opacity(0.6)),
                        axis: .vertical
                    )
                    .lineLimit(4)
                    .padding()
                    .frame(width: 300, height: 120)
                    .background(.white)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .border(.red, width: CGFloat(authHelper.sessionDescriptionError ? 3 : 0))
                    
                    Picker("Select an option", selection: $selectedValue) {
                        ForEach(0 ..< values.count) {
                            Image(systemName: self.values[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 300, height: 120)
                    
                }
                
                Button(action: {
                    Task {
                        await authHelper.createSession(
                            name: sessionName,
                            description: sessionDescription,
                            mode: selectedValue == 0 ? .walking : .running
                        )
                        
                        if authHelper.createSessionSuccess {
                            let locAllowed = locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse
                            let notifAllowed = notificationManager.authorizationStatus == .authorized
                            
                            if locAllowed && notifAllowed {
                                router.changeRoute(.init(.map))
                            } else if locAllowed {
                                router.changeRoute(.init(.notificationsAllowed))
                            } else {
                                router.changeRoute(.init(.locationAllowed))
                            }
                        }
                    }
                }, label: {
                    if authHelper.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Create")
                    }
                })
                .disabled(authHelper.isLoading)
                .frame(maxWidth: 265)
                .padding()
                .background(.blue)
                .foregroundColor(.white.opacity(0.9))
                .font(.headline)
                .cornerRadius(12.0)
            }
        }
    }
}

#Preview {
    CreateSessionView()
}
