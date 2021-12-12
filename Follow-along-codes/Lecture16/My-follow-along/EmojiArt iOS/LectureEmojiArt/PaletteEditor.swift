//
//  PaletteEditer.swift
//  LectureEmojiArt
//
//  Created by sun on 2021/11/19.
//

import SwiftUI

struct PaletteEditor: View {
    @Binding var palette: Palette
    private let emojiFontSize: CGFloat = 40
    
    var body: some View {
        Form {
            nameSection
            addEmojiSection
            removeEmojiSection
        }
        .navigationTitle("Edit \(palette.name)")
        .frame(minWidth: 300, minHeight: 350)
    }
    
    private var nameSection: some View {
        Section(header: Text("NAME")) {
            TextField("name", text: $palette.name)
        }
    }
    
    @State private var emojisToAdd: String = ""
    
    private var addEmojiSection: some View {
        Section(header: Text("ADD EMOJIS")) {
            TextField("name", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis)
                }
        }
    }
    
    func addEmojis(_ emojis: String) {
        withAnimation {
            palette.emojis = (emojis + palette.emojis)
                .filter { $0.isEmoji }
                .removingDuplicateCharacters
        }
    }
    
    private var removeEmojiSection: some View {
        let emojis = palette.emojis.map { String($0) }
        
        return Section(header: Text("REMOVE EMOJIS")) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: emojiFontSize))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                palette.emojis.removeAll(where: { String($0) == emoji })
                            }
                        }
                }
            }
            .font(.system(size: emojiFontSize))
        }
    }
}

struct PaletteEditer_Previews: PreviewProvider {
    
    static var previews: some View {
        PaletteEditor(palette: .constant(PaletteStore(named: "previews").palette(at: 0)))
    }
}
