//
//  EmojiMemoryGameView.swift
//  LectureMemorize
//
//  Created by sun on 2021/09/21.
//

import SwiftUI

// MVVM step 2:
// make our Views redraw when sth changed in their viewModel(var game underneath)
struct EmojiMemoryGameView: View {
    // @ObservedObject: when viewModel says sth changed, plz rebuild my entire body
    @ObservedObject var game: EmojiMemoryGame
    
    //shows what's in the model
    var body: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if card.isMatched && !card.isFaceUp {
                Rectangle().opacity(0)
            }
            else {
                CardView(card: card)
                    .padding(4)
                    .onTapGesture {
                        game.choose(card)
                    }
            }
        }
        .foregroundColor(.red)
        .padding(.horizontal)
    }
    
}

// View that shows what the card looks like
struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    Pie(startAngle: Angle(degrees: 0 - 90), endAngle: Angle(degrees: 110 - 90))
                        .padding(DrawingConstants.circlePadding)
                        .opacity(0.4)
                    Text(card.content).font(font(in: geometry.size))
                        .padding(DrawingConstants.circlePadding)
                } else if card.isMatched {
                    shape.opacity(0)
                } else {
                    shape.fill()
                }
            }
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 2.5
        static let fontScale: CGFloat = 0.65
        static let circlePadding: CGFloat = 5
    }
}


















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
            .preferredColorScheme(.dark)
    }
}
