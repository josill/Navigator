//
//  NotificationRequestView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 26.11.2023.
//

import SwiftUI

struct NotificationRequestView: View {
    @State private var selectedDate = Date()
    @State private var redirectToMenu = false
    let notify = NotificationManager()
    
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
                        notify.requestNotificationsPermission()
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
                        redirectToMenu = true
                        print("notify redirect: \(redirectToMenu)")
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
                    
                    NavigationLink(destination: LoginOrRegisterView(), isActive: $redirectToMenu) {
                        EmptyView()
                    }
                    .hidden()
                }
                .padding(32)
            }
        }
    }
}

#Preview {
    NotificationRequestView()
}
