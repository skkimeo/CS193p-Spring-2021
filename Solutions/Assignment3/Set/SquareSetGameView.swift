//
//  ContentView.swift
//  Set
//
//  Created by sun on 2021/10/07.
//

import SwiftUI

struct SunSetGameView: View {
    @ObservedObject var game: SunSetGame
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Score: \(game.score)")
                    .bold().foregroundColor(.black).padding(.bottom)
                
                if !game.isEndOfGame {
                    AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                        CardView(card: card)
                            .padding(5)
                            .onTapGesture {
                                game.choose(card)
                            }
                    }
                } else {
                    Text("Game Over").foregroundColor(.green).font(.largeTitle)
                }
                
                HStack {
                    Spacer()
                    Button { game.newGame() } label: { Text("New Game") }
                    Spacer()
                    if !game.isEndOfGame {
                        Button { game.cheat() } label: { Text("Cheat") }
                        Spacer()
                        if game.numberOfPlayedCards < game.totalNumberOfCards {
                            Button { game.dealThreeCards() } label: { Text("Deal 3 Cards") }
                        } else {
                            Text("Deal 3 Cards").foregroundColor(.gray)
                        }
                        Spacer()
                    }
                }
                .padding(.bottom)
            }
            .padding()
            .foregroundColor(.blue)
            .navigationBarTitle("Sun-Set!")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SunSetGame()
        SunSetGameView(game: game)
    }
}
