//
//  GameControls.swift
//  FifteenIOS
//
//  Created by Jonathan Sillak on 18.12.2023.
//

import SwiftUI

struct GameControls: View {
    var body: some View {
        ZStack {
            Color.black
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "circle.lefthalf.filled")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                }
                .padding(.horizontal, 80)
                .padding(.bottom, 40)
                
                HStack {
                    Spacer()
                    Text("Time:")
                        .foregroundColor(.white)
                        .font(.title2)
                    Spacer()
                    Text("Moves:")
                        .foregroundColor(.white)
                        .font(.title2)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "arrowshape.turn.up.backward")
                    }
                    .frame(maxWidth: 50)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white.opacity(0.9))
                    .font(.headline)
                    .cornerRadius(12.0)
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "play")
                    }
                    .frame(maxWidth: 50)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white.opacity(0.9))
                    .font(.headline)
                    .cornerRadius(12.0)
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
            .padding(.top, 80)
        }
    }
}

#Preview {
    GameControls()
}
