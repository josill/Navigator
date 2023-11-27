//
//  RegisterView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 13.11.2023.
//

import SwiftUI

struct RegisterView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var password2 = ""
    
    @State private var firstNameError = false
    @State private var lastNameError = false
    @State private var emailError = false
    @State private var passwordsError = false
    
    @State private var registerSuccessful = false;
    
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
                            .border(.red, width: CGFloat(firstNameError ? 3 : 0))
                        
                        TextField(
                            "Last name",
                            text: $lastName,
                            prompt: Text("Last Name").foregroundColor(.black.opacity(0.6)))
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(lastNameError ? 3 : 0))
                        
                        TextField(
                            "Email",
                            text: $email,
                            prompt: Text("Email").foregroundColor(.black.opacity(0.6)))
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
                            .border(.red, width: CGFloat(passwordsError ? 3 : 0))
                        
                        SecureField(
                            "Password again",
                            text: $password2,
                            prompt: Text("Password again").foregroundColor(.black.opacity(0.6)))
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(passwordsError ? 3 : 0))
                    }
                    
                    Button("Create") {
                        register()
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
                        isPresented: $registerSuccessful) {
                            LoginView()
                        }
                }
            }
        }
    }
    
    func validateNames() -> Bool {
        let firstNameCorrect = firstName.count > 3
        let lastNameCorrect = lastName.count > 3
        
        if firstNameCorrect { firstNameError = false }
        else { firstNameError = true }
        
        if firstNameCorrect { lastNameError = false }
        else { lastNameError = true }
        
        return firstNameCorrect && lastNameCorrect
    }
    
    func validateEmail() -> Bool {
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        let emailCorrect = emailPredicate.evaluate(with: email)
        
        if (emailCorrect) { emailError = false }
        else { emailError = true }
        
        return emailCorrect
    }
    
    func validatePasswords() -> Bool {
        let passwordsCorrect =
        password == password2 &&
        password.count > 3 &&
        password2.count > 3
        
        if (passwordsCorrect) { passwordsError = false }
        else { passwordsError = true }
        
        return passwordsCorrect
    }
    
    func register() {
        let namesCorrect = validateNames()
        let emailCorrect = validateEmail()
        let passwordsMatch = validatePasswords()
        
        if !namesCorrect || !emailCorrect || !passwordsMatch { return }
        registerSuccessful = true
    }
}

#Preview {
    RegisterView()
}
