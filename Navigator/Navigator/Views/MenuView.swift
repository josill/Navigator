//
//  MenuView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 12.12.2023.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var authHelper = AuthenticationHelper.shared
    @EnvironmentObject private var router: Router
    
    @State private var isLogoutAlertPresented = false
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(spacing: 20) {
                    HStack {
                        Image(systemName: "hand.wave")
                            .foregroundColor(.white)
                        
                        Text("Welcome back")
                    }
                    
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.white)
                        
                        Text("User!")
                    }
                }
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.top, 20)
                
                Spacer()
                
                VStack(spacing: 20) {
                    Button {
                        router.changeRoute(.init(.viewSessions))
                    } label: {
                        Text("Your sessions")
                    }
                    .frame(maxWidth: 265)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(Color.black.opacity(0.9))
                    .font(.headline)
                    .cornerRadius(12.0)
                    
                    Button {
                        router.changeRoute(.init(.createSession))
                    } label: {
                        Text("Create session")
                    }
                    .frame(maxWidth: 265)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(Color.white.opacity(0.9))
                    .font(.headline)
                    .cornerRadius(12.0)
                    
                    Button(action: {
                        isLogoutAlertPresented = true
                    }) {
                        Text("Log out")
                            .frame(maxWidth: 265)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(Color.blue.opacity(0.9))
                            .font(.headline)
                            .cornerRadius(12.0)
                    }
                }
                .background(.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .alert(isPresented: $isLogoutAlertPresented) {
            Alert(
                title: Text("Logout"),
                message: Text("Are you sure you want to log out?"),
                primaryButton: .default(Text("Cancel")),
                secondaryButton: .destructive(Text("Log Out")) {
                    authHelper.logOut {
                        router.reset()
                    }
                }
            )
        }
    }
}

#Preview {
    MenuView()
}
