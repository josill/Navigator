//
//  GameControls.swift
//  FifteenIOS
//
//  Created by Jonathan Sillak on 18.12.2023.
//

import SwiftUI

struct GameControls: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @StateObject var gameBrain: GameBrain
    
    var body: some View {
        ZStack {
            Color.background
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        isDarkMode.toggle()
                    }) {
                        Image(systemName: "circle.lefthalf.filled")
                            .foregroundColor(.text)
                            .font(.title2)
                    }
                }
                .padding(.horizontal, 80)
                .padding(.bottom, 40)
                
                HStack {
                    Spacer()
                    VStack {
                        Text("Time:")
                            .foregroundColor(.text)
                            .font(.title2)
                        Text(gameBrain.elapsedTimeString)
                    }
                    Spacer()
                    VStack {
                        Text("Moves:")
                            .foregroundColor(.text)
                            .font(.title2)
                        Text("\(gameBrain.movesMade)")
                    }
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        gameBrain.undo()
                    }) {
                        Image(systemName: "arrowshape.turn.up.backward")
                    }
                    .frame(maxWidth: 50)
                    .padding()
                    .background(.button)
                    .foregroundColor(.text)
                    .font(.headline)
                    .cornerRadius(12.0)
                    .disabled(gameBrain.undoDisabled)
                    
                    Spacer()
                    
                    Button(action: {
                        gameBrain.restart()
                    }) {
                        Image(systemName: "play")
                    }
                    .frame(maxWidth: 50)
                    .padding()
                    .background(.button)
                    .foregroundColor(.text)
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
    GameControls(gameBrain: GameBrain())
}
