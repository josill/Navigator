//
//  LoginOrRegisterView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 13.11.2023.
//

import SwiftUI

struct LoginOrRegisterView: View {
    var currentUser = DatabaseService.shared.currentUser
    
    var body: some View {
        if currentUser != nil {
            SessionsView()
        } else {
            NavigationStack {
                ZStack {
                    Color
                        .black
                        .ignoresSafeArea()
                    
                    
                    VStack(spacing: 15) {
                        Text("Navigator")
                            .font(.largeTitle)
                            .bold()
                            .padding()
                            .foregroundColor(.blue)
                        
                        Text("Sign in or Create account:")
                            .font(.title)
                            .padding()
                            .foregroundColor(.white.opacity(0.8))
                        
                        NavigationLink (destination: LoginView()) {
                            Text("Sign in")
                                .frame(maxWidth: 300)
                                .padding()
                                .background(.blue)
                                .foregroundColor(.white.opacity(0.9))
                                .font(.headline)
                                .cornerRadius(12.0)
                        }
                        
                        NavigationLink {
                            RegisterView()
                        } label: {
                            Text("Create account")
                                .frame(maxWidth: 300)
                                .padding()
                                .background(.blue)
                                .foregroundColor(.white.opacity(0.9))
                                .font(.headline)
                                .cornerRadius(12.0)
                        }
                    }
                }
            }
        }
      
    }
}

#Preview {
    LoginOrRegisterView()
}
