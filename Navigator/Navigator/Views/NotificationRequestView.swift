//
//  NotificationRequestView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 26.11.2023.
//

import SwiftUI

struct NotificationRequestView: View {
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var notificationManager: NotificationManager
    
    var body: some View {
        ZStack {
            Color
                .black
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image(systemName: "bell.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 32)
                    .foregroundColor(.white)
                
                Text("Please allow us to send notifications")
                    .font(.title)
                    .padding()
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                VStack {
                    Button {
                        Task {
                            notificationManager.requestNotificationsPermission()
                        }
                    } label: {
                        Text("Allow Notifications")
                            .padding()
                            .foregroundColor(.white.opacity(0.9))
                            .font(.headline)
                    }
                    .cornerRadius(12.0)
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.horizontal, -32)
                    .background(.blue)
                    .clipShape(Capsule())
                    
                    Button {
                        router.backToMenuRoute()
                    } label: {
                        Text("Maybe later")
                            .padding()
                            .foregroundColor(.blue.opacity(0.9))
                            .font(.headline)
                    }
                    .cornerRadius(12.0)
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.horizontal, -32)
                    .background(.white)
                    .clipShape(Capsule())
                }
                .padding(32)
            }
        }
        .onReceive(notificationManager.$authorizationStatus) { newAuthorizationStatus in
            if newAuthorizationStatus == .authorized {
                router.changeRoute(.init(.map))
            }
        }
    }
}

#Preview {
    NotificationRequestView()
}
