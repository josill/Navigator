//
//  MenuView.swift
//  FifteenIOS
//
//  Created by Jonathan Sillak on 18.12.2023.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Spacer()
                
                HStack(spacing: 10) {
                    Image(systemName: "figure")
                        .foregroundColor(.text)
                    Text("Welcome to Fifteen")
                        .foregroundColor(.text)
                    Image(systemName: "figure")
                        .foregroundColor(.text)
                }
                .font(.title)
                
                NavigationLink(destination: PlayView().navigationBarBackButtonHidden()) {
                    Text("Play")
                        .padding()
                        .foregroundColor(.text)
                        .background(.button)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    MenuView()
}
