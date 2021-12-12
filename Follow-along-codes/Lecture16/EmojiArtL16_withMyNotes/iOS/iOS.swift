//
//  iOS.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 5/26/21.
//

import SwiftUI

// L16 iOS-specific code

extension UIImage {
    // L16 convenience var to turn a UIImage into a Data
    // L16 on iOS, it converts it to jpeg
    var imageData: Data? { jpegData(compressionQuality: 1.0) }
}

// L16 a struct which contains statics to access the Pasteboard
// L16 in a platform-independent way
struct Pasteboard {
    static var imageData: Data? {
        UIPasteboard.general.image?.imageData
    }
    static var imageURL: URL? {
        UIPasteboard.general.url?.imageURL
    }
}

// L16 extensions to View for platform-specific modifications

extension View {
    // L16 palette control button uses the default style on iOS
    func paletteControlButtonStyle() -> some View {
        self
    }
    
    // L16 no extra padding required on iOS in a popover
    func popoverPadding() -> some View {
        self
    }

    // L15 convenience function to make an iPhone sheet or popover dismissable
    // L15 wraps it in a NavigationView to put the Close button at the top of the screen
    // L15 does nothing on iPad
    // L16 made platform-specific
    // sun
    // any time we have a function that's returning some View that
    // can be 2 different kinds, we need it to be a ViewBuilder
    @ViewBuilder
    func wrappedInNavigationViewToMakeDismissable(_ dismiss: (() -> Void)?) -> some View {
        if UIDevice.current.userInterfaceIdiom != .pad, let dismiss = dismiss {
            NavigationView {
                self
                    .navigationBarTitleDisplayMode(.inline)
                    .dismissable(dismiss)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        } else {
            self
        }
    }
    
    // L15 convenience function to make an iPhone sheet or popover dismissable
    // L15 assumes there is a toolbar available to hold the Close button
    // L16 made platform-specific
    @ViewBuilder
    func dismissable(_ dismiss: (() -> Void)?) -> some View {
        if UIDevice.current.userInterfaceIdiom != .pad, let dismiss = dismiss {
            self.toolbar {
                // L15 note .cancellationAction placement of the Close button
                // sun : prof called it semantic placement
                // L15 SwiftUI will put it in the appropriate spot in some toolbar somewhere
                // L15 (might depend on what toolbars exist and on the platform we're on)
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        } else {
            self
        }
    }
}
