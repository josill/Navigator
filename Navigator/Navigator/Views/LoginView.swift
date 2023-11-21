//
//  LoginView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 13.11.2023.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    
    @State private var usernameError: Float = 0
    @State private var passwordError: Float = 0
    
    @State private var loginSuccessful = false;

    var body: some View {
        NavigationStack {
            ZStack {
                Color
                    .black
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    VStack {
                        Text("Login")
                            .font(.title)
                            .padding()
                            .foregroundColor(.white.opacity(0.8))
                        
                        TextField("Username", text: $username)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(usernameError))
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(passwordError))
                    }
                    
                    Button("Login") {
                        loginSuccessful = true
                    }
                        .frame(maxWidth: 265)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white.opacity(0.9))
                        .font(.headline)
                        .cornerRadius(12.0)
                    
                    NavigationLink() {
                        ContentView()
                    } label: {
                        EmptyView()
                    }
                    .hidden()
                    .navigationDestination(
                        isPresented: $loginSuccessful) {
                            MapView()
                        }
 
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
