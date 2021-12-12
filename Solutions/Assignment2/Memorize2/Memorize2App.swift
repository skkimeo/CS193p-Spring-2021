//
//  Memorize2App.swift
//  Memorize2
//
//  Created by sun on 2021/10/03.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
