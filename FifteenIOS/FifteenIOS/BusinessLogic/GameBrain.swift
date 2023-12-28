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
    
    private var gameActive = false
    private var stack = [(Int, Int)]()
    
    private var timer = Timer()
    private var elapsedTime = 0
    
    @Published var elapsedTimeString = "00:00:00"
    @Published var movesMade = 0
    
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
        var zeroRow: Int? = nil
        
        for i in 0..<arr.count {
            if arr[i] == 0 {
                zeroRow = {
                    (0...3).contains(i) ? 1
                    : (4...7).contains(i) ? 2
                    : (8...11).contains(i) ? 3
                    : 4
                }()
                continue
            }
            
            for j in i+1..<arr.count {
                if arr[i] != 0 && arr[j] != 0 && arr[i] > arr[j] {
                    invCount += 1
                }
            }
        }
        
        if let zeroRow = zeroRow {
            invCount += zeroRow
        }
        
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
            movesMade += 1
        } else {
            movesMade -= 1
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
        
        let positions = locateValidPositions(row, col)
        
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
        resetTimer()
        movesMade = 0
    }
    
    func undo() {
        if !undoDisabled {
            if let (row, col) = stack.popLast() {
                handleTap(row, col, countUndo: false)
            }
        }
        
        undoDisabled = stack.isEmpty
    }

    func resetTimer() {
        timer.invalidate()
        elapsedTime = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }
    
    func updateElapsedTime() {
        elapsedTime += 1
        
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) % 3600) / 60
        let seconds = Int(elapsedTime) % 60
        
        elapsedTimeString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        
    }
}
