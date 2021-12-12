//
//  LectureEmojiArtApp.swift
//  LectureEmojiArt
//
//  Created by sun on 2021/10/20.
//

import SwiftUI

@main
struct LectureEmojiArtApp: App {
    let document = EmojiArtDocument()
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}
