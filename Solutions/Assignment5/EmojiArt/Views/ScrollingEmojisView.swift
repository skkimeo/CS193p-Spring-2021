//
//  ScrollingEmojisView.swift
//  EmojiArt
//
//  Created by sun on 2021/11/09.
//

import SwiftUI

struct ScrollingEmojisView: View {
    let emojis: String
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onDrag {NSItemProvider(object: emoji as NSString)}
                }
            }
        }
    }
}


















//struct ScrollingEmojisView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScrollingEmojisView()
//    }
//}
