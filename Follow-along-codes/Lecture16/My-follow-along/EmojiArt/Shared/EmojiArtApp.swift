//
//  EmojiArtApp.swift
//  Shared
//
//  Created by sun on 2021/11/28.
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
