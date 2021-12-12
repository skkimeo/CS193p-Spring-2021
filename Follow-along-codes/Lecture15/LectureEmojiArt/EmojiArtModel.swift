//
//  EmojiArtModel.swift
//  LectureEmojiArt
//
//  Created by sun on 2021/10/20.
//

import Foundation

struct EmojiArtModel: Codable {
    var background = Background.blank
    var emojis = [Emoji]()
    
    struct Emoji: Identifiable, Hashable, Codable {
        let text: String
        // NOT CGFloat b/c this is independent w/ the UI
        // x and y are OFFSET FROM THE CENTER b/c
        // 1. we can put our background in the center w/o care
        // 2. kinda universal for all devices
        var x: Int
        var y: Int
        var size: Int
        var id: Int
        
        // so that creating a new Emoji is only possible in the Model
        // now only this custom init is available
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    // this encodes the whole Model into a data block? blob?
    func json() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
    // decode
    init(json: Data) throws {
        self = try JSONDecoder().decode(EmojiArtModel.self, from: json)
    }

    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        self = try EmojiArtModel(json: data)
    }
    
    
    // to make sure that someone DOES NOT think that they can use
    // EmojiArtModel's free init to set background and emojis
    init() {}
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ text: String, at location: (x: Int, y: Int), size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: location.x, y: location.y, size: size, id: uniqueEmojiId))
    }
}
