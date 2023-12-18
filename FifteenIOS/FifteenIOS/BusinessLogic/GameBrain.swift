//
//  GameBrain.swift
//  FifteenIOS
//
//  Created by Jonathan Sillak on 18.12.2023.
//

import Foundation

class GameBrain: ObservableObject {
    @Published var tiles: [[Int]]
    private var gameActive = true
    
    enum Position {
        case top, left, right, bottom
    }
    
    init() {
        self.tiles = Self.createShuffledMatrix()
    }
    
    private static func createShuffledMatrix() -> [[Int]] {
        var matrix: [[Int]] = []
        for row in 0..<4 {
            var rowArray: [Int] = []
            for column in 0..<4 {
                let number = row * 4 + column
                rowArray.append(number)
            }
            matrix.append(rowArray)
        }
        return matrix.shuffled()
    }
    
    func handleTap(row: Int, col: Int) {
        guard gameActive else {
            return
        }
        
        guard allowClick(row, col) else {
            return
        }
        
        guard let zeroPos = getZeroPos() else {
            return
        }
        
        swapTiles(row, col, zeroPos)
    }
    
    func allowClick(_ row: Int, _ col: Int) -> Bool {
        let positionChecks = [
            Position.top: row > 0 && tiles[row - 1][col] == 0,
            Position.left: col > 0 && tiles[row][col - 1] == 0,
            Position.right: col < tiles[row].count - 1 && tiles[row][col + 1] == 0,
            Position.bottom: row < tiles.count - 1 && tiles[row + 1][col] == 0
        ]
        
        var positions = locateValidPositions(row, col)
        
        for p in positions {
            if positionChecks[p]! {
                return true
            }
        }
        
        return false
    }
    

    func locateValidPositions(_ row: Int, _ col: Int) -> [Position] {
        switch (row, col) {
        case (0, 0):
            return [.right, .bottom]
        case (0, tiles[row].count - 1):
            return [.left, .bottom]
        case (tiles.count - 1, tiles[row].count - 1):
            return [.top, .left]
        case (tiles.count - 1, 0):
            return [.top, .right]
        case (_, 0):
            return [.top, .right, .bottom]
        case (_, tiles[row].count - 1):
            return [.top, .left, .bottom]
        default:
            return [.top, .left, .right, .bottom]
        }
    }
    
    private func getZeroPos() -> (row: Int, col: Int)? {
        for row in 0..<tiles.count {
            for col in 0..<tiles[row].count {
                if tiles[row][col] == 0 {
                    return (row, col)
                }
            }
        }
        
        return nil
    }
    
    func swapTiles(_ row: Int, _ col: Int, _ zeroPos: (row: Int, col: Int)) {
        let temp = tiles[row][col]
        tiles[row][col] = tiles[zeroPos.row][zeroPos.col]
        tiles[zeroPos.row][zeroPos.col] = temp
    }
}
