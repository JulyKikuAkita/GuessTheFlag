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

    // accessbility label for voice over
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]

    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45, opacity: 1.0), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26, opacity: 1.0), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
//            LinearGradient(gradient: Gradient(colors: [.green, .black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of...")
                            .font(.subheadline.weight(.heavy))

                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    .foregroundStyle(.secondary)

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
                                    .accessibilityLabel(labels[countries[number], default: "Unknow flag"])
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
                                    .accessibilityLabel(labels[countries[number], default: "Unknow flag"])
                            }
                            .scaleEffect(showScaleAnimation ? 0.7 : 1.0)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Spacer()
                Spacer()

                Text("Your score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
    //                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
                    .transition(.asymmetric(insertion: .opacity, removal: .scale))
                
                Spacer()
            }
            .padding()
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
