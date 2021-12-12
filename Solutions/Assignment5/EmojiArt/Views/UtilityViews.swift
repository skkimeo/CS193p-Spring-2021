//
//  UtilityViews.swift
//  EmojiArt
//
//  Created by sun on 2021/11/11.
//

import SwiftUI

struct OptionalImage: View {
    let uiImage: UIImage?
    
    var body: some View {
        if uiImage != nil {
            Image(uiImage: uiImage!)
        }
    }
}
