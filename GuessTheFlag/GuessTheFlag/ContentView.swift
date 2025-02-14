//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Ivan on 30.04.2023.
//

import SwiftUI

struct Flag: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

extension View {
    func flagStyle() -> some View {
        modifier(Flag())
    }
}

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var gameOver = false
    @State private var scoreTitle = ""
    @State private var scoreCounter = 0
    @State private var endOfTheGame = 1
    @State private var animationAmount = 0.0
    @State private var animatedButton = 3
    @State private var opacityOn = 1.0
    @State private var scaledButtonIndex = 3
    
    @State private var countries = ["France", "Estonia", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "US", "Monaco"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            withAnimation{
                                animatedButton = number
                                animationAmount += 360
                                opacityOn -= 0.5
                                flagTapped(number)
                                scaledButtonIndex = number
                            }
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .flagStyle()
                        }
                        .rotation3DEffect(.degrees(scaledButtonIndex == number ? animationAmount : 0),
                                          axis: (x: 1, y: 0, z: 0))
                        .opacity(number == correctAnswer ? 1 : opacityOn)
                        .scaleEffect(scaledButtonIndex == number ? 1.2 : 1)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                
                Spacer()
                Spacer()
                
                Text("Score: \(scoreCounter)/8")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Countinue", action: askQuestion)
        } message: {
            Text("Your score is \(scoreCounter)")
        }
        .alert("Game over, your score is \(scoreCounter) out of 8", isPresented: $gameOver) {
            Button("Start new game", action: happyEnd)
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer && endOfTheGame != 8 {
            scoreTitle = "Correct"
            scoreCounter += 1
            endOfTheGame += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {showingScore = true}
        } else if number != correctAnswer && endOfTheGame != 8 {
            scoreTitle = "Wrong! It`s a flag of \(countries[number])"
            endOfTheGame += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {showingScore = true}
        } else if number == correctAnswer && endOfTheGame == 8 {
            scoreCounter += 1
            scoreTitle = "Your score is \(scoreCounter) out of 8"
            gameOver = true
        } else if number != correctAnswer && endOfTheGame == 8 {
            scoreTitle = "Your score is \(scoreCounter) out of 8"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {gameOver = true}
        }
    }
    
    func happyEnd() {
        withAnimation {
            countries.shuffle()
        }
        correctAnswer = Int.random(in: 0...2)
        endOfTheGame = 1
        scoreCounter = 0
        animationAmount = 0
        opacityOn += 0.5
        scaledButtonIndex = 3
    }
    
    func askQuestion() {
        withAnimation {
            countries.shuffle()
        }
        correctAnswer = Int.random(in: 0...2)
        animationAmount = 0
        opacityOn += 0.5
        scaledButtonIndex = 3
    }
    
    func shuffleflags() {
        countries.shuffle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
