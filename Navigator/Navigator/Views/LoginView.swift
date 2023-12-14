//
//  LoginView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 13.11.2023.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var authHelper = AuthenticationHelper()
    
    @State private var email = ""
    @State private var password = ""

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
                        
                        TextField(
                            "Email",
                            text: $email,
                            prompt: Text("Email")
                                .foregroundColor(.black.opacity(0.6)))
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(authHelper.emailError ? 3 : 0))
                        
                        SecureField(
                            "Password",
                            text: $password,
                            prompt: Text("Password").foregroundColor(.black.opacity(0.6)))
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(authHelper.passwordError ? 3 : 0))
                    }
                    
                    Button(action: {
                        Task {
                            await authHelper.login(
                                email: email,
                                password: password
                            )
                        }
                    }, label: {
                        if authHelper.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Login")
                        }
                    })
                    .disabled(authHelper.isLoading)
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
                        isPresented: $authHelper.loginSuccessful) {
                            MenuView()
                        }
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
