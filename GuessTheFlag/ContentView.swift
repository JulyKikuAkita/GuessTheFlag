//
//  ContentView.swift
//  https://www.hackingwithswift.com/guide/ios-swiftui/2/3/challenge
//
//  Created by Ifang Lee on 9/14/21.
//

import SwiftUI

struct ContentView: View {
    @State private var collections = ["Rock", "Paper", "Scissors"].shuffled()
    @State private var currentGesture = Int.random(in: 0...2)
    @State private var currentAction = Bool.random()

    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var round = 0

    var playerAction: String {
        if currentAction {
            return "Win"
        }
        return "Lose"
    }

    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.gray, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("You need to")
                    Text("\(playerAction)")
                        .bold()
                        .foregroundColor(.red)
                    Text(collections[currentGesture])
                        .fontWeight(.black)
                }
                .font(.largeTitle)
                .foregroundColor(.white)

                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }){
                        Text("\(collections[number])")
                            .foregroundColor(.white)
                            .padding()
                            .cusomStoke(stokeColor: .white, stokeLineWidth: 5.0, shadowColor: .gray, shadowRadius: 3.0)
                    }
                }
                Text("Your score: \(score)")
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")){
                self.askQuestion()
            })
        }
    }

    func flagTapped( _ number: Int) {
        round += 1
        let correctAnswer = getAnswer()
        if collections[number] == correctAnswer {
            scoreTitle = "Result for 10 questions"
            score += 1
        } else {
            score -= 1
        }
        print("Round \(round): question is to \(playerAction) \(collections[currentGesture])")
        print("Round \(round): answer is \(correctAnswer)")
        print("Round \(round): you chose \(collections[number])")
        askQuestion()
        if round == 10 {
            showingScore = true
            round = 0
        }
    }

    func askQuestion() {
        collections.shuffle()
        currentGesture = Int.random(in: 0...2)
        currentAction = Bool.random()
    }

    func getAnswer() -> String {
        let rules = [
            "Lose": ["Paper":"Rock", "Rock":"Scissors", "Scissors": "Paper"],
            "Win": ["Paper":"Scissors", "Rock":"Paper", "Scissors": "Rock"]
        ]
        return rules[playerAction]?[collections[currentGesture]] ?? ""
    }
}

// custom modifier
struct CustomStroke: ViewModifier {
    var stokeColor: Color
    var stokeLineWidth: CGFloat
    var shadowColor: Color = .white
    var shadowRadius: CGFloat = 2

    func body(content: Content) -> some View {
        content
            .clipShape(Capsule())
            .overlay(Capsule().stroke(stokeColor, lineWidth: stokeLineWidth))
            .shadow(color: shadowColor, radius: shadowRadius)
    }
}

extension View {
    func cusomStoke(stokeColor: Color, stokeLineWidth: CGFloat, shadowColor: Color = .white, shadowRadius: CGFloat = 2) -> some View {
        self.modifier(CustomStroke(stokeColor: stokeColor, stokeLineWidth: stokeLineWidth, shadowColor: shadowColor, shadowRadius: shadowRadius))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
