//
//  ThemeChooser.swift
//  Memorize3.0
//
//  Created by sun on 2021/11/21.
//

import SwiftUI

struct ThemeChooser: View {
    @EnvironmentObject var store: ThemeStore
    @State private var games = [Theme: EmojiMemoryGame]()
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
                List {
                    ForEach(store.themes.filter { $0.emojis.count > 1 }) { theme in
                        NavigationLink(destination: getDestination(for: theme)) {
                            themeRow(for: theme)
                        }
                        .gesture(editMode == .active ? tapToOpenThemeEditor(for: theme) : nil)
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { store.removeTheme(at: $0) }
                    }
                    .onMove { fromOffsets, toOffset in
                        store.themes.move(fromOffsets: fromOffsets, toOffset: toOffset)
                    }
                }
                .listStyle(.inset)
                .navigationTitle("Memorize")
                .sheet(item: $themeToEdit) {
                    removeNewThemeOnDismissIfInvalid()
                } content: { theme in
                    ThemeEditor(theme: $store.themes[theme])
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) { addThemeButton }
                    ToolbarItem { EditButton() }
                }
                .environment(\.editMode, $editMode)
        }
        .stackNavigationViewStyleIfiPad()
        .onChange(of: store.themes) { newThemes in
            updateGames(to: newThemes)
        }
    }
    
    private func themeRow(for theme: Theme) -> some View {
        VStack(alignment: .leading) {
            Text(theme.name)
                .foregroundColor(Color(rgbaColor: theme.color))
                .font(.system(size: 25))
                .bold()
            HStack {
                if theme.numberOfPairsOfCards == theme.emojis.count {
                    Text("All of \(theme.emojis)")
                } else {
                    Text("\(String(theme.numberOfPairsOfCards)) pairs from \(theme.emojis)")
                }
            }
            .lineLimit(1)
        }
    }
    
    private func getDestination(for theme: Theme) -> some View{
        if games[theme] == nil {
            let newGame = EmojiMemoryGame(theme: theme)
            games.updateValue(newGame, forKey: theme)
            return EmojiMemoryGameView(game: newGame)
        }
        return EmojiMemoryGameView(game: games[theme]!)
    }
    
    // MARK: - Theme Editing
    
    @State private var themeToEdit: Theme?

    private var addThemeButton: some View {
        Button {
            store.insertTheme(named: "new")
            themeToEdit = store.themes.first
        } label : {
            Image(systemName: "plus")
                .foregroundColor(.blue)
        }
    }
    
    private func removeNewThemeOnDismissIfInvalid() {
        if let newButInvalidTheme = store.themes.first {
            if newButInvalidTheme.emojis.count < 2 {
                store.removeTheme(at: 0)
            }
        }
    }
    
    private func tapToOpenThemeEditor(for theme: Theme) -> some Gesture {
        TapGesture()
            .onEnded {
                themeToEdit = store.themes[theme]
            }
    }
    

    //MARK: - Updating Game

    private func updateGames(to newThemes: [Theme]) {
        store.themes.filter { $0.emojis.count >= 2}.forEach { theme in
            if !newThemes.contains(theme) {
                store.themes.remove(theme)
            }
        }
    }
}









//
//struct ThemeChooser_Previews: PreviewProvider {
//    static var previews: some View {
//        ThemeChooser()
//    }
//}
