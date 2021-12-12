//
//  SetApp.swift
//  Set
//
//  Created by sun on 2021/10/07.
//

import SwiftUI

@main
struct SetApp: App {
    let game = SunSetGame()
    var body: some Scene {
        WindowGroup {
            SunSetGameView(game: game)
        }
    }
}
