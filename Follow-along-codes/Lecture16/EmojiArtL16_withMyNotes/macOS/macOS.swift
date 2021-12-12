//
//  macOS.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 5/26/21.
//

import SwiftUI

// L16 macOS-specific code

// L16 shared code is written in terms of UIImage
// L16 NSImage is very similar
// L16 so typealias UIImage to NSImage on macOS only
// L16 in cases where they are not the same
// L16 further code is required (see below)
typealias UIImage = NSImage

// L16 no PaletteManager on macOS
// L16 because it uses EditMode (not available on macOS)
typealias PaletteManager = EmptyView

extension Image {
    // L16 on macOS, there is no init(uiImage:)
    // L16 instead, it is init(nsImage:)
    // L16 since we typealias above, we can provide that init
    init(uiImage: UIImage) {
        self.init(nsImage: uiImage)
    }
}

extension UIImage {
    // L16 convenience var to turn a UIImage into a Data
    // L16 on macOS, it converts it to tiff
    var imageData: Data? { tiffRepresentation }
}

// L16 a struct which contains statics to access the Pasteboard
// L16 in a platform-independent way
// sun
// abstraction of the ways the pasteboard is used(getting image/url)
struct Pasteboard {
    static var imageData: Data? {
        NSPasteboard.general.data(forType: .tiff) ?? NSPasteboard.general.data(forType: .png)
    }
    static var imageURL: URL? {
        // sun
        // not as? b/c guranteed conversion b/w NSURL and URL
        (NSURL(from: NSPasteboard.general) as URL?)?.imageURL
    }
}

// L16 extensions to View for platform-specific modifications

extension View {
    // L16 no need to make a macOS sheet/popover dismissable
    // L16 because you can just tap elsewhere to dismiss
    func wrappedInNavigationViewToMakeDismissable(_ dismiss: (() -> Void)?) -> some View {
        self
    }
    
    // L16 on macOS, the palette control button needs a slight different styling
    // L16 it also needs to be a bit bigger so that it is bigger than the emojis in a scroll view
    func paletteControlButtonStyle() -> some View {
        self.buttonStyle(PlainButtonStyle()).foregroundColor(.accentColor).padding(.vertical)
    }
    
    // L16 popovers appear to have no horizontal padding on macOS?
    // L16 so this would have to be applied to all Views presented in a popover
    // L16 (probably this is not right, but works for a demo)
    func popoverPadding() -> some View {
        self.padding(.horizontal)
    }
}

// L16 Camera and PhotoLibrary don't exist on Mac
// L16 so create a "do nothing" View
// L16 so that the code can reference them with #if os(iOS) everywhere
// L16 (doable in this case because of isAvailable returning false)
//     (sun: isAvaiable skips returning an emptyView)
// sun
// this is sub for Camera and PhotoLibrary
// View b/c Camera and PhotoLibrary are Views in essence
struct CantDoItPhotoPicker: View {
    var handlePickedImage: (UIImage?) -> Void
    
    static let isAvailable = false
    
    var body: some View {
        EmptyView()
    }
}

typealias Camera = CantDoItPhotoPicker
typealias PhotoLibrary = CantDoItPhotoPicker
