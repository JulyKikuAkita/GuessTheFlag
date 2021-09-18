//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Ifang Lee on 9/14/21.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0

    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.green, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag...")
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                .foregroundColor(.white)

                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }){
                        Image(self.countries[number].lowercased())
                            .renderingMode(.original)
                            .cusomStoke(stokeColor: .blue, stokeLineWidth: 5.0, shadowColor: .gray, shadowRadius: 3.0)
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
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 5
        } else {
            scoreTitle = "Wrong! That’s the flag of \(countries[number])"
            score -= 5
        }
        showingScore = true
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
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
