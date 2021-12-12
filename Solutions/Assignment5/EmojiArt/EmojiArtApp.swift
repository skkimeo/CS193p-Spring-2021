//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by sun on 2021/12/12.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    let document = EmojiArtDocument()
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}
