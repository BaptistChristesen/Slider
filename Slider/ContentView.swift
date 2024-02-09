//
//  ContentView.swift
//  Slider
//
//  Created by Caden Christesen on 1/17/24.
//

import SwiftUI

struct ContentView: View {
    @State private var tiles = [1, 2, 3, 4, 0, 5, 7, 8, 6] // Start with blank in center
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns) {
                ForEach(0..<9) { index in
                    if tiles[index] != 0 {
                        Text("\(tiles[index])")
                            .frame(width: 100, height: 100)
                            .background(Color.orange)
                            .cornerRadius(10)
                            .onTapGesture {
                                moveTile(at: index)
                            }
                    } else {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 50, height: 50)
                    }
                }
            }
            .padding()
            Button("Shuffle") {
                shuffleBoardUntilSolvable()
            }
            if isSolved() {
                Text("Congratulations! You solved the puzzle!")
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
    }
    
    func moveTile(at index: Int) {
        let offsets = [-3, 3, -1, 1] // Only allow horizontal and vertical movement
        for offset in offsets {
            let neighborIndex = index + offset
            if neighborIndex >= 0 && neighborIndex < 9 && tiles[neighborIndex] == 0 {
                tiles.swapAt(index, neighborIndex)
                return
            }
        }
    }
    
    func shuffleBoardUntilSolvable() {
        repeat {
            // Ensure center tile stays blank while shuffling
            var shuffledTiles = (1...8).shuffled()
            shuffledTiles.insert(0, at: 4)
            tiles = shuffledTiles
        } while !isSolvable(board: tiles)
    }
    
    func isSolvable(board: [Int]) -> Bool {
        // Calculate inversion count
        var inversionCount = 0
        for i in 0..<board.count - 1 {
            for j in i + 1..<board.count {
                if board[i] > board[j] && board[j] == 0 {
                    inversionCount += 1
                }
            }
        }
        
        // Solvable if on an even numbered row or inversion count is even
        let blankRow = board.firstIndex(of: 0)! / 3
        return blankRow % 2 == 0 || inversionCount % 2 == 0
    }
    
    func isSolved() -> Bool {
        let targetTiles = Array(1...8) + [0]
        return Array(tiles.prefix(9)) == targetTiles
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
