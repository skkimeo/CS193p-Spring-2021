//
//  LectureMemorizeApp.swift
//  LectureMemorize
//
//  Created by sun on 2021/09/21.
//

import SwiftUI

@main
struct LectureMemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
