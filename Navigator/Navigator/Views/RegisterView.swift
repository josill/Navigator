//
//  RegisterView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 13.11.2023.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var authHelper = AuthenticationHelper()
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password1 = ""
    @State private var password2 = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color
                    .black
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    VStack {
                        Text("Create account")
                            .font(.title)
                            .padding()
                            .foregroundColor(.white.opacity(0.8))
                        
                        TextField(
                            "First name",
                            text: $firstName,
                            prompt: Text("First name").foregroundColor(.black.opacity(0.6)))
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(authHelper.firstNameError ? 3 : 0))
                        
                        TextField(
                            "Last name",
                            text: $lastName,
                            prompt: Text("Last Name").foregroundColor(.black.opacity(0.6)))
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(authHelper.lastNameError ? 3 : 0))
                        
                        TextField(
                            "Email",
                            text: $email,
                            prompt: Text("Email").foregroundColor(.black.opacity(0.6)))
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(authHelper.emailError ? 3 : 0))
                        
                        SecureField(
                            "Password",
                            text: $password1,
                            prompt: Text("Password").foregroundColor(.black.opacity(0.6)))
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(authHelper.passwordsError ? 3 : 0))
                        
                        SecureField(
                            "Password again",
                            text: $password2,
                            prompt: Text("Password again").foregroundColor(.black.opacity(0.6)))
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(authHelper.passwordsError ? 3 : 0))
                    }
                    
                    Button("Create") {
                        authHelper.register(
                            firstName: firstName,
                            lastName: lastName,
                            email: email,
                            password1: password1,
                            password2: password2
                        )
                    }
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
                        isPresented: $authHelper.registerSuccessful) {
                            LoginView()
                        }
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}
