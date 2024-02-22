//
//  ContentView.swift
//  test
//
//  Created by Arnas Šimaitis on 21/02/2024.
//

import SwiftUI

struct gameNumbers {
    var correct: Int
    var incorrect: Int
}

struct ContentView: View {
    var body: some View {
        NavigationView{
            List{
                NavigationLink(destination: View1()){
                    Text("Guess the number")
                }
                NavigationLink(destination: View2()){
                    Text("Minesweeper")
                }
            }
        }
        
    }
}

struct View1: View {
    var body: some View {
        guessTheNumberGame()
    }
}

struct View2: View {
    var body: some View {
        minesweeper()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
