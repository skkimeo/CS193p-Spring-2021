//
//  Memorize3_0App.swift
//  Memorize3.0
//
//  Created by sun on 2021/11/21.
//

import SwiftUI

@main
struct Memorize3_0App: App {
    @StateObject var themeStore = ThemeStore(named: "default")
    
    var body: some Scene {
        WindowGroup {
//            ThemeChooser(store: themeStore)
            ThemeChooser()
                .environmentObject(themeStore)
        }
    }
}
