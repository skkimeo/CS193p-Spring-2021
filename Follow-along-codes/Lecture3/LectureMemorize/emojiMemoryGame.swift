//
//  emojiMemoryGame.swift
//  LectureMemorize
//
//  view model
//
//  Created by sun on 2021/09/28.
//

import Foundation

class EmojiMemoryGame {
    static let emojis = ["🚗", "🛴", "✈️", "🛵", "⛵️", "🚎", "🚐", "🚛", "🛻", "🏎", "🚂", "🚊", "🚀", "🚁", "🚢", "🛶", "🛥", "🚞", "🚟", "🚃"]
    
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame(numberOfPairsOfCards: 4) { pairIndex in emojis[pairIndex] }
    }
    
    // each Model-View creates its own Model
    private(set) var model = createMemoryGame()
    
    // and make public, parts that need to be so
    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }
}
