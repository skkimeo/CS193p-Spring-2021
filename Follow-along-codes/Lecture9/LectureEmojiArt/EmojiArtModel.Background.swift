//
//  EmojiArtModel.Background.swift
//  LectureEmojiArt
//
//  Created by sun on 2021/10/20.
//

import Foundation

extension EmojiArtModel {
    enum Background {
        case blank
        case url(URL)
        case imageData(Data)
        
        // u can call on these vars to check if the current background has a url or imageData
        var url: URL? {
            switch self {
            case .url(let url): return url
            default: return nil
            }
        }
        
        var imageData: Data? {
            switch self {
            case .imageData(let data): return data
            default: return nil
            }
        }
    }
}
