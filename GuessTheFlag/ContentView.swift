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

    @State private var animationRotateAngles = 0.0
    @State private var showScaleAnimation = false

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
                    if number == correctAnswer {
                        Button(action: {
                            withAnimation() {
                                flagTapped(number)
                            }
                        }) {
                            Image(countries[number].lowercased())
                                .renderingMode(.original)
                                .cusomStoke(stokeColor: .blue, stokeLineWidth: 5.0, shadowColor: .gray, shadowRadius: 3.0)
                        }
                        .rotation3DEffect(.degrees(animationRotateAngles), axis: (x: 0, y: 1, z: 0))
                    } else {
                        Button(action: {
                            withAnimation() {
                                flagTapped(number)
                            }
                        }) {
                            Image(countries[number].lowercased())
                                .renderingMode(.original)
                                .cusomStoke(stokeColor: .blue, stokeLineWidth: 5.0, shadowColor: .gray, shadowRadius: 3.0)
                        }
                        .scaleEffect(showScaleAnimation ? 0.7 : 1.0)
                    }
                }

                if showingScore {
                    Text("Your score: \(score)")
                        .foregroundColor(.white)
//                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
                        .transition(.asymmetric(insertion: .opacity, removal: .scale))
                }

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
            animationRotateAngles = 360
        } else {
            scoreTitle = "Wrong! That’s the flag of \(countries[number])"
            score -= 5
            showScaleAnimation = true
        }
        showingScore = true
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        resetAnimation()
    }

    func resetAnimation() {
        animationRotateAngles = 0
        showScaleAnimation = false
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
