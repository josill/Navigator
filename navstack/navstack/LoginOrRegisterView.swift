//
//  LoginOrRegisterView.swift
//  navstack
//
//  Created by Jonathan Sillak on 26.12.2023.
//

import SwiftUI

struct LoginOrRegisterView: View {
    var body: some View {
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
                    
                    Button {
                        Router.shared.changeRoute(RoutePath(.login))
                    } label: {
                        Text("Sign in")
                            .frame(maxWidth: 300)
                            .padding()
                            .background(.blue)
                            .foregroundColor(.white.opacity(0.9))
                            .font(.headline)
                            .cornerRadius(12.0)
                    }
                    
                    Button {
                        Router.shared.changeRoute(RoutePath(.register))
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

#Preview {
    LoginOrRegisterView()
}

#Preview {
    LoginOrRegisterView()
}
