//
//  GameBoard.swift
//  FifteenIOS
//
//  Created by Jonathan Sillak on 18.12.2023.
//

import SwiftUI

struct GameBoard: View {
    @StateObject var gameBrain: GameBrain

    var body: some View {
        ZStack {
            Color
                .background
            
            VStack(spacing: 5) {
                ForEach(0..<4, id: \.self) { row in
                    HStack(spacing: 5) {
                        ForEach(0..<4, id: \.self) { col in
                            let tileValue = gameBrain.tiles[row][col]
                            let correctValue = row * 4 + col + 1
                            
                            Button(action: {
                                withAnimation {
                                    gameBrain.handleTap(
                                        row,
                                        col
                                    )
                                }
                            }) {
                                if tileValue != 0 {
                                    Text("\(tileValue)")
                                        .foregroundColor(.text)
                                }
                            }
                            .font(.title)
                            .padding()
                            .foregroundColor(.white)
                            .cornerRadius(0)
                            .frame(width: 85, height: 85)
                            .background(tileValue == 0 ? .tileSecondary : correctValue == tileValue ? .tileTertiary : .tileMain)
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    GameBoard()
//}
