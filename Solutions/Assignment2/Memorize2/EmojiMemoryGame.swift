//
//  EmojiMemoryGame.swift
//  Memorize2
//
//  Created by sun on 2021/10/03.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    static private var vehicleEmojis = ["🚗", "🛴", "✈️", "🛵", "⛵️", "🚎", "🚐", "🚛", "🛻", "🏎", "🚂", "🚊", "🚀", "🚁", "🚢", "🛶", "🛥", "🚞", "🚟", "🚃"]
    static private var animalEmojis = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐮", "🐷", "🐵"]
    static private var foodEmojis = ["🍔", "🥐", "🍕", "🥗", "🥟", "🍣", "🍪", "🍚", "🍝", "🥙", "🍭", "🍤", "🥞", "🍦", "🍛", "🍗"]
    static private var heartEmojis = ["❤️", "🧡", "💛", "💚", "💙", "💜"]
    static private var sportsEmojis = ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏉", "🥏", "🏐", "🎱", "🏓", "🏸", "🏒", "🥊", "🚴‍♂️", "🏊", "🧗‍♀️", "🤺", "🏇", "🏋️‍♀️", "⛸", "⛷", "🏄", "🤼"]
    static private var weatherEmojis = ["☀️", "🌪", "☁️", "☔️", "❄️"]
    
    static private let colors = ["black", "gray", "red", "green", "blue", "orange",
    "yellow", "pink", "purple", "fushia", "beige", "gold"]
    
    static func getColor(_ chosenColor: String) -> Color {
        switch chosenColor {
        case "black":
            return .black
        case "gray":
            return .gray
        case "red":
            return .red
        case "green":
            return .green
        case "blue":
            return .blue
        case "orange":
            return .orange
        case "yellow":
            return .yellow
        case "pink":
            return .pink
        case "purple":
            return .purple
        default:
            return .red
        }
    }
    static func createTheme(_ name: String, _ emojis: [String], _ defaultPairsOfCards: Int) -> Theme {
        let color = colors.randomElement()!
        var numberOfParisOfCards = defaultPairsOfCards
        
        if emojis.count < defaultPairsOfCards {
            numberOfParisOfCards = emojis.count
        }
        return Theme(name: name, emojis: emojis.shuffled(), numberOfPairsOfCards: numberOfParisOfCards, cardColor: color)
    }
    
    static var themes: [Theme] = {
        var themes = [Theme]()
        let defaultPairsOfCards = 8
        themes.append(createTheme("Vehicles", vehicleEmojis, defaultPairsOfCards))
        themes.append(createTheme("Animals", animalEmojis, defaultPairsOfCards))
        themes.append(createTheme("Food", foodEmojis, defaultPairsOfCards))
        themes.append(createTheme("Hearts", heartEmojis, defaultPairsOfCards))
        themes.append(createTheme("Sports", sportsEmojis, defaultPairsOfCards))
        themes.append(createTheme("Weather", weatherEmojis, defaultPairsOfCards))
        return themes
    }()
    
    static func createMemoryGame(of chosenTheme: Theme) -> MemoryGame<String> {
        var numberOfPairsOfCards = chosenTheme.numberOfPairsOfCards
        if chosenTheme.name == "Vehicles" || chosenTheme.name == "Animals" {
            numberOfPairsOfCards = Int.random(in: 2...chosenTheme.emojis.count)
        }
        return MemoryGame(numberOfPairsOfCards: numberOfPairsOfCards) { chosenTheme.emojis[$0] }
    }
    
    private(set) var chosenTheme: Theme
    private(set) var chosenColor: Color?
    @Published private var model: MemoryGame<String>
    
    static func choseTheme() -> Theme {
        EmojiMemoryGame.themes.randomElement()!
    }
    
    init() {
        chosenTheme = EmojiMemoryGame.choseTheme()
        model = EmojiMemoryGame.createMemoryGame(of: chosenTheme)
        chosenColor = EmojiMemoryGame.getColor(chosenTheme.cardColor)
    }
    
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    // MARK: - Intent(s)
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func startNewGame() {
        chosenTheme = EmojiMemoryGame.choseTheme()
        chosenColor = EmojiMemoryGame.getColor(chosenTheme.cardColor)
        model = EmojiMemoryGame.createMemoryGame(of: chosenTheme )
    }
}
