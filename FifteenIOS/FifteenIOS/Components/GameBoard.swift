//
//  GameBoard.swift
//  FifteenIOS
//
//  Created by Jonathan Sillak on 18.12.2023.
//

import SwiftUI

struct GameBoard: View {
    var matrix: [[Int]] = {
            var matrix: [[Int]] = []
            for row in 0..<4 {
                var rowArray: [Int] = []
                for column in 0..<4 {
                    let number = row * 4 + column
                    rowArray.append(number)
                }
                matrix.append(rowArray)
            }
            return matrix
        }()
    
    var body: some View {
        ZStack {
            Color
                .black
            
            VStack(spacing: 1) {
                ForEach(0..<4) { row in
                    HStack(spacing: 1) {
                        ForEach(0..<4) { tile in
                            Button(action: {
                                print("tapped \(matrix[row][tile])")
                            }) {
                                Text("\(matrix[row][tile])")
                            }
                            .font(.title)
                            .padding()
                            .foregroundColor(.white)
                            .cornerRadius(0)
                            .frame(width: 85, height: 85)
                        }
                        .background(.cyan)
                    }
                }
            }
        }
    }
}

#Preview {
    GameBoard()
}
