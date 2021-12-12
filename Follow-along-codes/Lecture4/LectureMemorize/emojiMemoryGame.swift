//
//  emojiMemoryGame.swift
//  LectureMemorize
//
//  view model
//
//  Created by sun on 2021/09/28.
//

import SwiftUI

// MVVM Step 1
// ObservableObject protocol lets the object(viewnModel in this case) publish
// to the world that its Model has changed
class EmojiMemoryGame: ObservableObject {
    static let emojis = ["🚗", "🛴", "✈️", "🛵", "⛵️", "🚎", "🚐", "🚛", "🛻", "🏎", "🚂", "🚊", "🚀", "🚁", "🚢", "🛶", "🛥", "🚞", "🚟", "🚃"]
    
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame(numberOfPairsOfCards: 4) { pairIndex in emojis[pairIndex] }
    }
    
    // each Model-View creates its own Model
    @Published private var model = createMemoryGame()
    
    // and declare its own var for parts that need to be available
    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }
    
    // put functions that show user intent in the viewModel
    // MARK: - Intent(s)
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}
