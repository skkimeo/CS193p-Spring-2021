//
//  LectureEmojiArtApp.swift
//  LectureEmojiArt
//
//  Created by sun on 2021/10/20.
//

import SwiftUI

@main
struct LectureEmojiArtApp: App {
    @StateObject var document = EmojiArtDocument()
    @StateObject var paletteStore = PaletteStore(named: "Default")
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
                .environmentObject(paletteStore)
        }
    }
}
