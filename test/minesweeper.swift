//
//  minesweeper.swift
//  test
//
//  Created by Arnas Šimaitis on 21/02/2024.
//

import SwiftUI

struct touchingBlocks {
    var north: msBlock?
    var south: msBlock?
    var east: msBlock?
    var west: msBlock?
    var northWest: msBlock?
    var northEast: msBlock?
    var southWest: msBlock?
    var southEast: msBlock?
    
    func allBlocks() -> [msBlock?] {
        return [north, south, east, west, northWest, northEast, southWest, southEast]
    }
}

class msBlock: Identifiable, ObservableObject{
    var id = UUID()
    var bomb = -1
    @Published var text = ""
    @Published var background = Color.blue
    @Published var marked = false
    private var display = false
    
    var neighbors: touchingBlocks? = nil
    
    var btn: msBlockButton {
        msBlockButton(block: self)
    }
    
    func onClick(){
        if self.marked {
            self.mark()
            return
        }
        self.display = true
        if self.bomb == 0 {
            self.text = "💣"
            self.background = Color.brown
        } else if self.bomb > 0 {
            self.text = String(self.bomb)
            self.background = Color.green
        } else if self.bomb == -1 {
            self.background = Color.gray
        }
    }
    
    func mark() {
        if self.display {
            return
        }
        self.marked = !self.marked
        self.text = self.text == "🚩" ? "" : "🚩"
        self.background = self.background == Color.red ? Color.blue : Color.red
    }
    
    func addBomb() {
        if self.bomb == -1 {
            self.bomb = 1
        } else if self.bomb == 0 {
            return
        } else {
            self.bomb += 1
        }
    }
    
    func makeBomb(){
        self.bomb = 0
        if self.neighbors != nil{
            if let allBlocks = self.neighbors?.allBlocks() {
                for block in allBlocks{
                    block?.addBomb()
                }
            }
        }
    }
}

struct msBlockButton: View {
    
    @ObservedObject var block: msBlock
    
    @State var longPress = false
    
    init(block: msBlock) {
        self.block = block
    }
    
    var body: some View {
        Button(action: {
            if self.longPress{
                self.longPress = false
            } else {
                self.block.onClick()
            }
        }){
            Text(self.block.text)
                .frame(width:50,height:50)
                .background(self.block.background)
                .foregroundColor(Color.white)
                .cornerRadius(10)
        }
        .simultaneousGesture(LongPressGesture(minimumDuration: 0.3).onEnded({ _ in
            self.longPress = true
            self.block.mark()
        }))
    }
}

class msTable: ObservableObject{
    @Published var layout: Array<msBlock>
    
    init(width: Int, height: Int, bombs: Int){
        let totalBlocks = width * height
        
        self.layout = (0..<totalBlocks).map { _ in msBlock() }
        
        for (index, block) in self.layout.enumerated() {
            block.neighbors = touchingBlocks(
                north: index - width >= 0 ? self.layout[index-width] : nil,
                south: index + width < totalBlocks ? self.layout[index+width] : nil,
                east: (index+1) % width != 0 ? self.layout[index+1] : nil,
                west: index % width != 0 ? self.layout[index-1] : nil,
                northWest: index - width >= 0 && index % width != 0 ? self.layout[index-1-width] : nil,
                northEast: index - width >= 0 && (index+1) % width != 0 ? self.layout[index+1-width] : nil,
                southWest: index + width < totalBlocks && index % width != 0 ? self.layout[index-1+width] : nil,
                southEast: index + width < totalBlocks && (index+1) % width != 0 ? self.layout[index+1+width] : nil
            )
        }
        
        var usedIndexes: [Int] = []
        for _ in (1...bombs) {
            var bombIndex = Int.random(in:0...totalBlocks-1)
            while usedIndexes.contains(bombIndex) || self.layout[bombIndex].bomb == 0{
                bombIndex = Int.random(in:0...totalBlocks-1)
            }
            usedIndexes.append(bombIndex)
            
            self.layout[bombIndex].makeBomb()
        }
    }
}

struct minesweeper: View {
    @StateObject private var layout = msTable(width: 7, height: 7, bombs: 10)
    var body: some View {
        let rows: [GridItem] = Array(repeating: .init(.fixed(50), spacing: 0), count: 7)
        VStack(alignment:.center){
            LazyVGrid(columns: rows, alignment: .center, spacing: 0){
                ForEach(layout.layout) { bomb in
                    bomb.btn
                }
            }
        }
    }
}
