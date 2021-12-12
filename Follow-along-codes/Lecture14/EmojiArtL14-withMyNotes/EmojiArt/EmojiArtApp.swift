//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/26/21.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    // L14 remove @StateObject var document: EmojiArtDocument
    @StateObject var paletteStore = PaletteStore(named: "Default")
    // sun
    // scene: high level container that contains the top-level View of ur app
    var body: some Scene {
        // L14 changed from WindowGroup to DocumentGroup
        // sun : b/c we want diff VM per Scene
        // L14 newDocument: argument is closure which creates a new, blank document
        // L14 second closure creates a View for a new scene for a given ViewModel
        // Lar (which is loaded up out of a file with ReferenceFileDocument protocol)
        // sun
        // config is a struct that
        // has the VM we're supposed to use and the url of the file in question
        DocumentGroup(newDocument: { EmojiArtDocument() }) { config in
            EmojiArtDocumentView(document: config.document)
                .environmentObject(paletteStore)
        }
    }
}
