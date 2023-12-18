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
                    }
                }
                .padding(.horizontal, 80)
                .padding(.bottom, 40)
                
                HStack {
                    Spacer()
                    Text("Time:")
                        .foregroundColor(.white)
                    Spacer()
                    Text("Moves:")
                        .foregroundColor(.white)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        HStack(spacing: 20) {
                            Image(systemName: "arrowshape.turn.up.backward")
                        }
                    }
                    .frame(maxWidth: 50)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white.opacity(0.9))
                    .font(.headline)
                    .cornerRadius(12.0)
                    
                    Spacer()
                    
                    Button(action: {
                        Image(systemName: "play")
                    }) {
                        Text("Undo")
                    }
                    .frame(maxWidth: 50)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white.opacity(0.9))
                    .font(.headline)
                    .cornerRadius(12.0)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    GameControls()
}
