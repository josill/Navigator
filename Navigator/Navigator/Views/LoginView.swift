//
//  LoginView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 13.11.2023.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    @State private var emailError = false
    @State private var passwordError = false
    
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
                            .border(.red, width: CGFloat(emailError ? 3 : 0))
                        
                        SecureField(
                            "Password",
                            text: $password,
                            prompt: Text("Password").foregroundColor(.black.opacity(0.6)))
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(passwordError ? 3 : 0))
                    }
                    
                    Button("Login") {
                        login()
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
    
    func validateEmail() -> Bool {
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        let emailCorrect = emailPredicate.evaluate(with: email)
        
        if (emailCorrect) { emailError = false }
        else { emailError = true }
        
        return emailCorrect
    }
    
    func validatePassword() -> Bool {
        let passwordCorrect = password.count > 3
        
        if passwordCorrect { passwordError = false }
        else { passwordError = true }
        
        return passwordCorrect
    }
    
    func login() {
        let emailCorrect = validateEmail()
        let passwordsMatch = validatePassword()
        
        if !emailCorrect || !passwordsMatch { return }
        loginSuccessful = true
    }
}

#Preview {
    LoginView()
}
