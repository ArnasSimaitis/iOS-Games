//
//  guessTheNumber.swift
//  test
//
//  Created by Arnas Šimaitis on 21/02/2024.
//

import SwiftUI

func generateRandom() -> Int {
    return Int.random(in: 1...100)
}

func generateTwoNumbers() -> gameNumbers {
    let firstNumber = generateRandom()
    var secondNumber = generateRandom()
    while (firstNumber == secondNumber) {
        secondNumber = generateRandom()
    }
    return gameNumbers(correct: firstNumber, incorrect: secondNumber)
}

func verifyUserChoice(value: Int, correct: Int) -> String {
    if (value == correct){
        return "Correct"
    }
    return "Incorrect"
}

struct guessTheNumberGame: View {
   
    @State var gameNumbers = generateTwoNumbers()
    @State var text = "Guess which is correct"

    var body: some View {
        let displayNumbers = [gameNumbers.correct, gameNumbers.incorrect].shuffled()
        var textColor: Color {
                switch text {
                case "Correct":
                    return Color.green
                case "Incorrect":
                    return Color.red
                default:
                    return Color.white
                }
            }
        Text(text)
            .foregroundColor(textColor)
        HStack{
            ForEach(displayNumbers, id: \.self){ number in
                Button(action: {
                    text = verifyUserChoice(value: number, correct: gameNumbers.correct)
                    gameNumbers = generateTwoNumbers()
                }) {
                    Text(String(number))
                        .frame(width:50, height:50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(Color.white)
                }
            }
        }
    }
}
