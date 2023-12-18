//
//  CreateSessionView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 12.12.2023.
//

import SwiftUI

struct CreateSessionView: View {
    @ObservedObject var authHelper = AuthenticationHelper()
    
    @State private var sessionName = ""
    @State private var sessionDescription = ""
    
    var body: some View {
        NavigationStack {
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
                    }
                    
                    Button(action: {
                        Task {
                            await authHelper.createSession(
                                name: sessionName,
                                description: sessionDescription
                            )
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
                    
                    NavigationLink {
                        ContentView()
                    } label: {
                        EmptyView()
                    }
                    .hidden()
                    .navigationDestination(
                        isPresented: $authHelper.createSessionSuccessful) {
                            MapView()
                        }
                }
            }
        }
    }
}

#Preview {
    CreateSessionView()
}
