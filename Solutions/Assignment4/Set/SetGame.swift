//
//  SetGame.swift
//  Set
//
//  Created by sun on 2021/10/07.
//

import Foundation

struct SetGame<CardSymbolShape, CardSymbolColor, CardSymbolPattern, NumberOfShapes> where CardSymbolShape: Hashable, CardSymbolColor: Hashable, CardSymbolPattern: Hashable {
    private(set) var numberOfPlayedCards = 0
    private var chosenCards = [Card]()
    private(set) var isEndOfGame = false
    
    private(set) var totalNumberOfCards: Int
    private var initialNumberOfPlayingCards: Int
    
    private let createCardSymbol: (Int) -> Card.CardContent
    private(set) var playingCards = [Card]()
    private(set) var allCards = [Card]()
    private(set) var deckCards =  [Card]()
    
    
    private(set) var remainingSet: [Card]?
    
    private(set) var score = 0
    
    private(set) var timeLastThreeCardsWereChosen = Date()
    
    
    mutating func resetChosenCards() {
        if playingCards.first(where: {$0 == chosenCards.first})!.isMatched {
            chosenCards.forEach { card in
                if let matchedIndex = playingCards.firstIndex(of: card) {
                    playingCards.remove(at: matchedIndex)
                }
            }
        }
        else {
            chosenCards.forEach { card in
                if let failedMatchIndex = playingCards.firstIndex(of: card) {
                    playingCards[failedMatchIndex].isChosen = false
                    playingCards[failedMatchIndex].isNotMatched = false
                }
            }
        }
        chosenCards = []
    }
    
    mutating func checkEndOfGame(in playingCards: [Card]) -> Bool {
        var cards = playingCards
        
        if chosenCards.count == 3 {
            chosenCards.forEach { card in
                let matchedIndex = cards.firstIndex(of: card)!
                cards.remove(at: matchedIndex)
            }
        }
        
        if getAnyRemainingSet(in: cards) != nil {
            return false
        }
        return true
    }
    
    mutating func choose(_ card: Card) {
        turnOffCheat()
        
        if chosenCards.count == 3 { resetChosenCards() }
        
        if let chosenIndex = playingCards.firstIndex(where: { $0 == card }) {
            if !playingCards[chosenIndex].isChosen {
                playingCards[chosenIndex].isChosen = true
                chosenCards.append(playingCards[chosenIndex])
                
                if chosenCards.count == 3 {
                    let timeNewSetWasFound = Date()
                    let timeSpent = Int(timeNewSetWasFound.timeIntervalSince(timeLastThreeCardsWereChosen))
                    
                    if formSet(by: chosenCards) {
                        score += 2 * max(20 - timeSpent, 1)
                        
                        chosenCards.forEach { card in
                            let index = playingCards.firstIndex(of: card)!
                            playingCards[index].isMatched = true
                            allCards[allCards.firstIndex(of: card)!].isMatched = true
                        }
                        
                        if numberOfPlayedCards == totalNumberOfCards {
                            isEndOfGame = checkEndOfGame(in: playingCards)
                        }
                        
                    } else {
                        score -= 2 * max(20 - timeSpent, 1)
                        chosenCards.forEach { card in
                            let index = playingCards.firstIndex(of: card)!
                            playingCards[index].isNotMatched = true
                        }
                    }
                    timeLastThreeCardsWereChosen = timeNewSetWasFound
                }
            } else { // diselect
                playingCards[chosenIndex].isChosen = false
                chosenCards.remove(at: chosenCards.firstIndex(of: playingCards[chosenIndex])!)
            }
            
        }
        
    }
    
    mutating func getAnyRemainingSet(in cards: [Card]) -> [Card]? {
        
        if cards.isEmpty {
            return nil
        }
        
        for i in 0..<cards.count - 2 {
            for j in (i + 1)..<cards.count - 1 {
                for k in (j + 1)..<cards.count {
                    if formSet(by: [cards[i], cards[j], cards[k]]) {
                        return [cards[i], cards[j], cards[k]]
                    }
                }
            }
        }
        return nil
    }
    
    
    mutating func formSet(by cards: [Card]) -> Bool {
        var shapes = Set<CardSymbolShape>()
        var colors = Set<CardSymbolColor>()
        var patterns = Set<CardSymbolPattern>()
        var numberOfShapes = Set<Int>()
        
        cards.forEach { card in
            shapes.insert(card.symbol.shape)
            colors.insert(card.symbol.color)
            patterns.insert(card.symbol.pattern)
            numberOfShapes.insert(card.symbol.numberOfShapes)
        }
        
        if shapes.count == 2 || colors.count == 2 ||
            patterns.count == 2 || numberOfShapes.count == 2 {
            return false
        }
        return true
    }
    
    mutating func dealOneCard(at index: Int) {
        if numberOfPlayedCards < totalNumberOfCards {
            let symbol = createCardSymbol(numberOfPlayedCards)
            playingCards.insert(Card(symbol: symbol, id: numberOfPlayedCards), at: index)
            numberOfPlayedCards += 1
        }
    }
    
    mutating func dealThreeCards() {
        cheat() // should change this..not clear to others
        if remainingSet != nil { score -= 3 }
        turnOffCheat()
        
        switch chosenCards.count {
        case 3:
            if playingCards.first(where: {$0 == chosenCards.first})!.isMatched {
                chosenCards.forEach { card in
                    if let matchedIndex = playingCards.firstIndex(of: card) {
                        playingCards.remove(at: matchedIndex)
                        dealOneCard(at: matchedIndex)
                    }
                }
                chosenCards = []
            }
            else {
                chosenCards.forEach { card in
                    if let failedMatchIndex = playingCards.firstIndex(of: card) {
                        playingCards[failedMatchIndex].isChosen = false
                        playingCards[failedMatchIndex].isNotMatched = false
                    }
                }
                chosenCards = []
                fallthrough
            }
        default:
            for _ in 0..<3 {
                dealOneCard(at: playingCards.endIndex)
            }
        }
        if numberOfPlayedCards == totalNumberOfCards {
            isEndOfGame = checkEndOfGame(in: playingCards)
        }
    }
    
    mutating func turnOffCheat() {
        if remainingSet != nil {
            for remainingIndex in 0..<2 {
                if let index = playingCards.firstIndex(of: remainingSet![remainingIndex]) {
                    playingCards[index].isHint = false
                }
            }
            remainingSet = nil
        }
    }
    
    mutating func cheat() {
        score -= 3
        var dupPlayingCards = playingCards
        if chosenCards.count == 3 {
            chosenCards.forEach { card in
                let matchedIndex = dupPlayingCards.firstIndex(of: card)!
                dupPlayingCards.remove(at: matchedIndex)
            }
            
        }
        
        if let remainingSet = getAnyRemainingSet(in: dupPlayingCards) {
            self.remainingSet = remainingSet
            
            for index in 0..<2 {
                playingCards[playingCards.firstIndex(of: remainingSet[index])!].isHint = true
            }
            
        } else {
            self.remainingSet = nil
        }
    }
    
    init(initialNumberOfPlayingCards: Int, totalNumberOfCards: Int, createCardContent: @escaping (Int) -> Card.CardContent) {
        self.initialNumberOfPlayingCards = initialNumberOfPlayingCards
        self.totalNumberOfCards = totalNumberOfCards
        self.createCardSymbol = createCardContent
        
        for index in 0..<totalNumberOfCards {
            let content = createCardContent(index)
            if index < initialNumberOfPlayingCards {
                playingCards.append(Card(symbol: content, id: index))
            }
            allCards.append(Card(symbol: content, id: index))
        }
        numberOfPlayedCards = initialNumberOfPlayingCards
    }
    
    struct Card: Identifiable, Equatable {
        
        let symbol: CardContent
        var isChosen: Bool = false
        var isMatched = false
        var isNotMatched = false
        var isHint = false
        let id: Int
        
        struct CardContent {
            let shape: CardSymbolShape
            let color: CardSymbolColor
            let pattern: CardSymbolPattern
            let numberOfShapes: Int
        }
        
        static func == (lhs: SetGame<CardSymbolShape, CardSymbolColor, CardSymbolPattern, NumberOfShapes>.Card, rhs: SetGame<CardSymbolShape, CardSymbolColor, CardSymbolPattern, NumberOfShapes>.Card) -> Bool {
            lhs.id == rhs.id
        }
    }
}




