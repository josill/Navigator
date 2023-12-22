//
//  GameBrain.swift
//  FifteenIOS
//
//  Created by Jonathan Sillak on 18.12.2023.
//

import Foundation

class GameBrain: ObservableObject {
    @Published var tiles: [[Int]]
    @Published var undoDisabled = true
    
    private var gameActive = true
    private var stack = [(Int, Int)]()
    
    enum Position {
        case top, left, right, bottom
    }
    
    init() {
        var shuffledMatrix: [[Int]] = []
        while true {
            shuffledMatrix = Self.createShuffledMatrix()
            if Self.isSolveable(shuffledMatrix) {
                break
            }
        }
        self.tiles = shuffledMatrix
        print(self.tiles)
    }
    
    private static func createShuffledMatrix() -> [[Int]] {
        var array: [Int] = Array(0..<16)
        array.shuffle()

        var matrix: [[Int]] = []
        for row in 0..<4 {
            let startIndex = row * 4
            let endIndex = startIndex + 4
            matrix.append(Array(array[startIndex..<endIndex]))
        }

        return matrix
    }
    
    private static func isSolveable(_ matrix: [[Int]]) -> Bool {
        let arr = Array(matrix.joined())
        var invCount = 0
        
        for i in 0..<arr.count {
                for j in i+1..<arr.count {
                    if arr[i] != 0 && arr[j] != 0 && arr[i] > arr[j] {
                        invCount += 1
                    }
                }
            }
        
        print("inv \(invCount)")
        return invCount % 2 == 0
    }
    
    func handleTap(_ row: Int, _ col: Int, countUndo: Bool = true) {
        guard gameActive else {
            return
        }
        
        guard allowClick(row, col) else {
            return
        }
        
        guard let zeroPos = getZeroPos() else {
            return
        }
        
        if countUndo {
            stack.append(zeroPos)
            undoDisabled = false
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
    
    func restart() {
        gameActive = true
        var shuffledMatrix: [[Int]] = []
        while true {
            shuffledMatrix = Self.createShuffledMatrix()
            if Self.isSolveable(shuffledMatrix) {
                break
            }
        }
        self.tiles = shuffledMatrix

        stack = []
    }
    
    func undo() {
        print("undo")
        
        if !undoDisabled {
            if let (row, col) = stack.popLast() {
                handleTap(row, col, countUndo: false)
                
                print(tiles)
            }
        }
        
        undoDisabled = stack.isEmpty
    }
}
