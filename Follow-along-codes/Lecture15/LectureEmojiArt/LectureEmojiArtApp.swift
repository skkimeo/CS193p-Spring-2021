//
//  LectureEmojiArtApp.swift
//  LectureEmojiArt
//
//  Created by sun on 2021/10/20.
//

import SwiftUI

@main
struct LectureEmojiArtApp: App {
    @StateObject var paletteStore = PaletteStore(named: "Default")
    
    var body: some Scene {
        DocumentGroup(newDocument: { EmojiArtDocument() }) { config in
            EmojiArtDocumentView(document: config.document)
                .environmentObject(paletteStore)
        }
    }
}
