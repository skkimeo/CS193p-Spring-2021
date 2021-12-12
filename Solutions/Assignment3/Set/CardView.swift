//
//  CardView.swift
//  Set
//
//  Created by sun on 2021/10/07.
//

import SwiftUI

struct CardView: View {
    let card: SunSetGame.Card
    
    var body: some View {
        ZStack {
            let cardShape = RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius)
            if card.isMatched {
                cardShape.foregroundColor(.green).opacity(DrawingConstants.effectOpacity)
                cardShape.strokeBorder(lineWidth: DrawingConstants.effectLineWidth).foregroundColor(.green)
                
            } else {
                cardShape.fill().foregroundColor(.white)
                cardShape.strokeBorder(lineWidth: DrawingConstants.defaultLineWidth)
                if card.isChosen {
                    cardShape.strokeBorder(lineWidth: DrawingConstants.effectLineWidth).foregroundColor(.orange)
                }
                VStack {
                    ForEach(0..<card.symbol.numberOfShapes, id: \.self) { _ in
                        createSymbol(for: card)
                    }
                }
                .padding()
                
                if card.isNotMatched {
                    cardShape.foregroundColor(.gray).opacity(DrawingConstants.effectOpacity)
                    cardShape.strokeBorder(lineWidth: DrawingConstants.effectLineWidth).foregroundColor(.gray)
                }
                
                if card.isHint {
                    cardShape.foregroundColor(.green).opacity(DrawingConstants.effectOpacity)
                    cardShape.strokeBorder(lineWidth: DrawingConstants.effectLineWidth).foregroundColor(.green)
                }
            }
        }
    }
    
    @ViewBuilder
    func createSymbol(for card: SunSetGame.Card) -> some View {
        switch card.symbol.shape {
        case .roundedRectangle:
            createSymbolView(of: card.symbol, shape: RoundedRectangle(cornerRadius: DrawingConstants.symbolCornerRadius))
        case .squiggle:
            createSymbolView(of: card.symbol, shape: Squiggle())
        case .diamond:
            createSymbolView(of: card.symbol, shape: Diamond())
        }
    }
    
    @ViewBuilder
    private func createSymbolView<SymbolShape>(of symbol: SunSetGame.Card.CardContent, shape: SymbolShape) -> some View where SymbolShape: Shape {
        
        switch symbol.pattern {
        case .filled:
            shape.fill().foregroundColor(symbol.color.getColor())
                .aspectRatio(DrawingConstants.symbolAspectRatio, contentMode: .fit).opacity(DrawingConstants.symbolOpacity)
            
        case .shaded:
            StripeView(shape: shape, color: symbol.color.getColor())
                .aspectRatio(DrawingConstants.symbolAspectRatio, contentMode: .fit).opacity(DrawingConstants.symbolOpacity)
            
        case .stroked:
            shape.stroke(lineWidth: DrawingConstants.defaultLineWidth).foregroundColor(symbol.color.getColor())
                .aspectRatio(DrawingConstants.symbolAspectRatio, contentMode: .fit).opacity(DrawingConstants.symbolOpacity)
        }
    }
    
    struct DrawingConstants {
        static let symbolAspectRatio: CGFloat = 2/1
        static let symbolOpacity: Double = 0.7
        static let symbolCornerRadius: CGFloat = 50
        
        static let defaultLineWidth: CGFloat = 2
        static let effectLineWidth: CGFloat = 3
        static let cardCornerRadius: CGFloat = 10
        static let effectOpacity: Double = 0.1
    }
}

//
//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        let
//        CardView()
//    }
//}
