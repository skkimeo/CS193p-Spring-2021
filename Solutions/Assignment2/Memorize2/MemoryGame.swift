//
//  MemoryGame.swift
//  Memorize2
//
//  Created by sun on 2021/10/03.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    private var IndexOfTheOneAndOnlyFaceUpCard: Int?
    
    private(set) var score = 0
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            let chosenTime = Date()
            if let potentialMatchIndex = IndexOfTheOneAndOnlyFaceUpCard {
                let usedTime = Int(chosenTime.timeIntervalSince(cards[potentialMatchIndex].chosenTime!))
                if cards[chosenIndex].content == cards[potentialMatchIndex].content
                {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2 * max(10 - usedTime, 1)
                } else {
                    if cards[potentialMatchIndex].isAlreadySeen {
                        score -= 1 * max(10 - usedTime, 1)
                    }
                    if cards[chosenIndex].isAlreadySeen {
                        score -= 1 * max(10 - usedTime, 1)
                    }
                }
                cards[chosenIndex].isAlreadySeen = true
                cards[potentialMatchIndex].isAlreadySeen = true
                IndexOfTheOneAndOnlyFaceUpCard = nil
            } else {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                cards[chosenIndex].chosenTime = chosenTime
                IndexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp = true
        }
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        var isAlreadySeen = false
        let content: CardContent
        var chosenTime: Date?
        var id: Int
    }
}

struct Theme {
    let name: String
    let emojis: [String]
    var numberOfPairsOfCards: Int
    let cardColor: String // type of color?
}
