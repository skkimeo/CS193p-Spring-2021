//
//  SunSetGameView.swift
//  Set
//
//  Created by sun on 2021/10/07.
//

import SwiftUI

struct SunSetGameView: View {
    @ObservedObject var game: SunSetGame
    
    @Namespace var discardSpace
    @Namespace var deckSpace
    
    
    @State var initialCards = [SunSetGame.Card]()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Score: \(game.score)")
                    .bold().foregroundColor(.black).padding(.bottom)
                
                if !game.isEndOfGame {
                    AspectVGrid(items: game.playingCards, aspectRatio: 2/3) { card in
                        CardView(card: card, isUndealt: false)
                            .matchedGeometryEffect(id: card.id, in: discardSpace)
                            .matchedGeometryEffect(id: card.id * 100, in: deckSpace)
                            .padding(5)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    getPiledCards()
                                    game.choose(card)
                                }
                            }
                    }
                } else {
                    Text("Game Over").foregroundColor(.green).font(.largeTitle)
                }
                
                HStack {
                    Spacer()
                    deckBody
                    Spacer()
                    discardPileBody
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    restart
                    Spacer()
                    if !game.isEndOfGame {
                        cheat
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
    
    private func isUndealt(_ card: SunSetGame.Card) -> Bool {
        return !game.playingCards.contains(card) && !card.isMatched
    }
    
    private func zIndex(of card: SunSetGame.Card) -> Double {
        -Double(game.allCards.firstIndex(of: card) ?? 0)
    }
    
    var deckBody: some View {
        ZStack {
            
            ForEach(game.allCards.filter(isUndealt)) { card in
                CardView(card: card, isUndealt: true)
                    .matchedGeometryEffect(id: card.id * 100, in: deckSpace)
                    .zIndex(zIndex(of: card))
                
            }
        }
        .frame(width: 60, height: 90)
        .onTapGesture {
            withAnimation {
                getPiledCards()
            }
            withAnimation(.linear(duration: 0.3).delay(0.25)) {
                game.dealThreeCards()
            }
        }
    }
    
    @State var matchedCards = [SunSetGame.Card]()
    
    private func getPiledCards() {
        for card in game.allCards.filter({ $0.isMatched }) {
            var dup = card
            dup.isMatched = false
            if !matchedCards.contains(dup) {
                matchedCards.append(dup)
            }
        }
    }
    
    var discardPileBody: some View {
        return ZStack {
            Color.clear
            ForEach(matchedCards) { card in
                CardView(card: card, isUndealt: false)
                    .matchedGeometryEffect(id: card.id, in: discardSpace)
            }
        }
        .frame(width: 60, height: 90)
    }
    
    var restart: some View {
        Button("Restart") {
            matchedCards = []
            game.newGame()
        }
    }
    
    var cheat: some View {
        Button("Cheat") { game.cheat() }
    }
    
}













struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SunSetGame()
        SunSetGameView(game: game)
    }
}
