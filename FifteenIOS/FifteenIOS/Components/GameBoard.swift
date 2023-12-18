//
//  GameBoard.swift
//  FifteenIOS
//
//  Created by Jonathan Sillak on 18.12.2023.
//

import SwiftUI

struct GameBoard: View {
    @StateObject private var gameBrain = GameBrain()
    
    var body: some View {
        ZStack {
            Color
                .black
            
            VStack(spacing: 5) {
                ForEach(0..<4) { row in
                    HStack(spacing: 5) {
                        ForEach(0..<4) { col in
                            let tileValue = gameBrain.tiles[row][col]
                            let correctValue = row * 4 + col + 1
                            
                            Button(action: {
                                withAnimation {
                                    gameBrain.handleTap(
                                        row: row,
                                        col: col
                                    )
                                }
                            }) {
                                if tileValue != 0 {
                                    Text("\(tileValue)")
                                }
                            }
                            .font(.title)
                            .padding()
                            .foregroundColor(.white)
                            .cornerRadius(0)
                            .frame(width: 85, height: 85)
                            .background(tileValue == 0 ? .white : correctValue == tileValue ? .green : .cyan)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    GameBoard()
}
