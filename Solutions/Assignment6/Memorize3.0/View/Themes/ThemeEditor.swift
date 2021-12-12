//
//  ThemeEditor.swift
//  Memorize3.0
//
//  Created by sun on 2021/11/21.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                nameSection
                removeEmojiSection
                addEmojiSection
//                emojiHistorySection
                cardPairSection
                colorSection
            }
            .navigationTitle("\(name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    cancelButton
                }
                ToolbarItem { doneButton }
            }
        }
    }
    
//    @State private var removedEmojis: String
//
//    private var emojiHistorySection: some View {
//        Section(header: Text("Removed Emojis")) {
//            LazyVGrid(columns: [GridItem(.adaptive(minimum: 20))]) {
//                ForEach(removedEmojis.map {String($0)}, id: \.self) { emoji in
//                    Text(emoji)
//                        .onTapGesture {
//                            addToCandidateEmojis(emoji)
//                            withAnimation {
//                                removedEmojis.removeAll { String($0) == emoji }
//                            }
//                        }
//                }
//            }
//        }
//    }
    
    private var doneButton: some View {
        Button("Done") {
            if presentationMode.wrappedValue.isPresented && candidateEmojis.count >= 2 {
                saveAllEdits()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func saveAllEdits() {
//        theme.removedEmojis = getRemovedEmojis(from: theme.emojis)
        theme.name = name
        theme.emojis = candidateEmojis
        theme.numberOfPairsOfCards = min(numberOfPairs, candidateEmojis.count)
        theme.color = RGBAColor(color: chosenColor)
    }
    
//    private func getRemovedEmojis(from oldEmojis: String) -> String {
//        (oldEmojis.filter { !candidateEmojis.contains($0) } + removedEmojis)
//        return removedEmojis
//
//    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            if presentationMode.wrappedValue.isPresented {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    init(theme: Binding<Theme>) {
        self._theme = theme
        self._name = State(initialValue: theme.wrappedValue.name)
        self._candidateEmojis = State(initialValue: theme.wrappedValue.emojis)
//        self._removedEmojis = State(initialValue: theme.wrappedValue.removedEmojis)
        self._numberOfPairs = State(initialValue: theme.wrappedValue.numberOfPairsOfCards)
        self._chosenColor = State(initialValue: Color(rgbaColor: theme.wrappedValue.color))
    }
    
    // MARK: - Name Section
    
    @State private var name: String
    
    private var nameSection: some View {
        Section(header: Text("theme name")) {
            TextField("Theme name", text: $name)
        }
    }
    
    // MARK: - Remove Emojis Section
    
    @State private var candidateEmojis: String
    
    private var removeEmojiSection: some View {
        let header = HStack {
            Text("Emojis")
            Spacer()
            Text("Tap To Remove")
        }
        
        return Section(header: header) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 20))]) {
                ForEach(candidateEmojis.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                if candidateEmojis.count > 2 {
                                    candidateEmojis.removeAll { String($0) == emoji}
                                }
                            }
                        }
                }
            }
        }
    }
    
    // MARK: - Add Emojis Section
    
    @State private var emojisToAdd = ""
    
    private var addEmojiSection: some View {
        Section(header: Text("add Emojis")) {
            TextField("Emojis", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emoji in
                    addToCandidateEmojis(emoji)
                }
        }
    }
    
    private func addToCandidateEmojis(_ emojis: String) {
        withAnimation {
            candidateEmojis = (emojis + candidateEmojis)
                .filter { $0.isEmoji }
                .removingDuplicateCharacters
        }
    }
    
    // MARK: - Number of Card Pairs Section
    
    @State var numberOfPairs: Int
    
    private var cardPairSection: some View {
        Section(header: Text("Card Count")) {
            Stepper("\(numberOfPairs) Pairs", value: $numberOfPairs, in: candidateEmojis.count < 2 ?  2...2 : 2...candidateEmojis.count)
                .onChange(of: candidateEmojis) { _ in
                    numberOfPairs = max(2, min(numberOfPairs, candidateEmojis.count))
                }
        }
    }
    
    // MARK: - Color Section
    
    @State var chosenColor: Color = .red
    
    private var colorSection: some View {
        if #available(iOS 15.0, *) {
            return Section("COLOR") {
                ColorPicker("Current color is", selection: $chosenColor, supportsOpacity: false)
                    .foregroundColor(chosenColor)
            }
        } else {
            return Section(header: Text("Current color is")) {
                ColorPicker("", selection: $chosenColor, supportsOpacity: false)
                    .foregroundColor(chosenColor)
            }
        }
    }
}








//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        ThemeEditor(theme: .constant(ThemeStore(named: "preview").themes[1]))
//    }
//}
