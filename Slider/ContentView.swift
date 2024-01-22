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
            
            if isSolved() {
                Text("Congratulations! You solved the puzzle!")
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
    }
    
    func moveTile(at index: Int) {
        let offsets = [-4, 4, -1, 1]
        for offset in offsets {
            let neighborIndex = index + offset
            if neighborIndex >= 0 && neighborIndex < 16 && abs(tiles[index] - tiles[neighborIndex]) > 1 {
                if tiles[neighborIndex] == 0 {
                    tiles.swapAt(index, neighborIndex)
                    return
                }
            }
        }
    }
    
    func isSolved() -> Bool {
        let targetTiles = Array(1...15)
        return Array(tiles.prefix(15)) == targetTiles
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
