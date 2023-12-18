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
                    Text("Welcome to Fifteen")
                    Image(systemName: "figure")
                }
                .font(.title)
                
                NavigationLink(destination: PlayView()) {
                    Text("Play")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
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
