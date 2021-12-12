//
//  EmojiArtModel.swift
//  EmojiArt
//
//  Created by sun on 2021/11/09.
//

import Foundation

struct EmojiArtModel {
    var background: Background = .blank
    var emojis = [Emoji]()
    
    init() {}
    
    // MARK: - Emojis
    struct Emoji: Identifiable, Hashable {
        let text: String
        var x: Int
        var y: Int
        var size: Int
        var id: Int
        
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
        
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ text: String, at location: (x: Int, y: Int), size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: location.x, y: location.y, size: size, id: uniqueEmojiId))
    }
}
