//
//  ContentView.swift
//  Slider
//
//  Created by Caden Christesen on 1/17/24.
//

import SwiftUI

struct ContentView: View {
    
    // Start with blank in center (thats the "0")
    @State private var tiles = [1, 2, 3, 4, 0, 5, 7, 8, 6]
    
    // Defines the layout of the tiles (3 columns)
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        VStack {
            
            // LazyVGrid arranges the tiles in a grid with 3 columns
            LazyVGrid(columns: columns) {
                
                // Loop through each tile index (0 to 8), if the tile is not blank (0) display the tile.
                ForEach(0..<9) { index in
                    if tiles[index] != 0 {
                        Text("\(tiles[index])")
                            .frame(width: 100, height: 100)
                            .background(Color.orange)
                            .cornerRadius(10)
                        //following two lines allow tiles to move around where you click
                            .onTapGesture {
                                moveTile(at: index)
                            }
                        
                    // Else it handles the blank space. if the puzzle isnt solved keep the tile blank (0), otherwise show the 9 the same as the other numbered tiles
                    } else {
                        if (!isSolved()){
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 100, height: 100)
                        }
                        else {
                            Text("9")
                                .frame(width: 100, height: 100)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .padding()
            
            // Button to run the function that shuffles the tiles
            Button("Shuffle") {
                shuffleBoardUntilSolvable()
            }
            
            // chucks if the puzzle is solved, and if so it
            if isSolved() {
                Text("Congratulations! You solved the puzzle!")
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
    }
    
    // This is how the tiles actually move.
    // Sets an array of the moves it will make on the board. Basically, to move the tile up it sets the tile move in the array via the offset (moving by a -3 offset moves it up one row visually but 3 indecies backwards in the array.
    func moveTile(at index: Int) {
        let offsets = [-3, 3, -1, 1]
        for offset in offsets {
            let neighborIndex = index + offset
            if neighborIndex >= 0 && neighborIndex < 9 && tiles[neighborIndex] == 0 {
                tiles.swapAt(index, neighborIndex)
                return
            }
        }
    }
    
    func shuffleBoardUntilSolvable() {
        // Repeat the shuffle until solveable
        repeat {
            // Ensure center tile stays blank while shuffling
            var shuffledTiles = (1...8).shuffled()
            shuffledTiles.insert(0, at: 4)
            tiles = shuffledTiles
        } while !isSolvable(board: tiles)
    }
    
    // Checks the inversion count. if the blank (0) tile is on an even row it is solveable if an even number of inversions is required, otherwise and odd number of inversions is required.
    // While my current version keeps the blank tile on the same row always, there is no need to change the function as it still works perfectly fine.
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
    
    // Checks if the puzzle is solved by checking fi the first 8 inidcies are in order, with the blank (0) tile at the end.
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
