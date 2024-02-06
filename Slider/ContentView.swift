//
//  ContentView.swift
//  Slider
//
//  Created by Caden Christesen on 1/17/24.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @State private var tiles = (1...15).map { $0 }.shuffled() + [0]
    let columns = Array(repeating: GridItem(.flexible()), count: 4)
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns) {
                ForEach(0..<16) { index in
                    if tiles[index] != 0 {
                        Text("\(tiles[index])")
                            .frame(width: 50, height: 50)
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
                shuffleTiles()
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
        let offsets = [-4, 4, -1, 1]  // Only allow horizontal and vertical movement
        for offset in offsets {
            let neighborIndex = index + offset
            if neighborIndex >= 0 && neighborIndex < 16 && tiles[neighborIndex] == 0 {
                tiles.swapAt(index, neighborIndex)
                return
            }
        }
    }
    
    func isSolved() -> Bool {
        let targetTiles = Array(1...15)
        return Array(tiles.prefix(15)) == targetTiles
    }
    private func isSolvable(tiles: [Int]) -> Bool {
        let inversions = countInversions(tiles: tiles)
        let blankOnEvenRowFromBottom = (tiles.firstIndex(of: 0)! / 4) % 2 == 0
        return (inversions % 2 == 0) == blankOnEvenRowFromBottom
    }

        
    private func countInversions(tiles: [Int]) -> Int {
        var inversions = 0
        for i in 0..<tiles.count {
            for j in (i + 1)..<tiles.count {
                if tiles[i] != 0 && tiles[j] != 0 && tiles[i] > tiles[j] {
                    inversions += 1
                }
            }
        }
        return inversions
    }
    private func shuffleTiles() {
        repeat {
            tiles.shuffle()
        } while !isSolvable(tiles: tiles) && isLastTwoTilesSwapped(tiles: tiles)
    }
    private func isLastTwoTilesSwapped(tiles: [Int]) -> Bool {
        for i in stride(from: 2, to: 16, by: 4) {
            if tiles[i] < tiles[i-1] {
                return true
            }
        }
        return false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
