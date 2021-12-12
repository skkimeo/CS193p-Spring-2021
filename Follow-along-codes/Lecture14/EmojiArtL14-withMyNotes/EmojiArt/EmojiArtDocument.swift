//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/26/21.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI
import Combine
import UniformTypeIdentifiers

// L14 a constant for our EmojiArt document type
// sun
// gonna create our custom UTType
extension UTType {
    static let emojiart = UTType(exportedAs: "edu.stanford.cs193p.emojiart")
}

class EmojiArtDocument: ReferenceFileDocument
{
    // L14
    // implementation of the ReferenceFileDocument protocol
    // this simple protocol is used to read/write EmojiArtDocument from/to a file
    // it replaces all the "autosaving" code we wrote in the past
    // DocumentGroup (in EmojiArtApp) depends on our implementing this protocol here
    // it also requires us to implement Undo (see Undo section below)
    // sun
    // if sth changes snapshot will be called on another thread(that's not main) and then
    // ask u again to give a fileWrapper that it can put the snapshot into
    
    // MARK: - ReferenceFileDocument
    
    static var readableContentTypes = [UTType.emojiart]
    static var writeableContentTypes = [UTType.emojiart]
    
    // sun
    // ReadConfiguration is a specifier that has the file that we wanna open
    required init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            emojiArt = try EmojiArtModel(json: data)
            fetchBackgroundImageDataIfNecessary()
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    // represents EmojiArtDocument as Data
    func snapshot(contentType: UTType) throws -> Data {
        try emojiArt.json()
    }
    
    func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: snapshot)
    }
        
    // MARK: - Model
    
    @Published private(set) var emojiArt: EmojiArtModel {
        didSet {
            if emojiArt.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
            }
        }
    }
    
    init() {
        // we just need to be able to create a blank document essentially 
        emojiArt = EmojiArtModel()
    }
    
    var emojis: [EmojiArtModel.Emoji] { emojiArt.emojis }
    var background: EmojiArtModel.Background { emojiArt.background }
    
    // MARK: - Background
    
    @Published var backgroundImage: UIImage?
    @Published var backgroundImageFetchStatus = BackgroundImageFetchStatus.idle
    
    enum BackgroundImageFetchStatus: Equatable {
        case idle
        case fetching
        case failed(URL)
    }
    
    // self goes away -> cancellable goes away -> subsrciber stops -> Publisher stops
    private var backgroundImageFetchCancellable: AnyCancellable?
    
    // L13 reimplemented this using URLSession's dataTaskPublisher
    
    private func fetchBackgroundImageDataIfNecessary() {
        backgroundImage = nil
        switch emojiArt.background {
        case .url(let url):
            // fetch the url
            backgroundImageFetchStatus = .fetching
            // if there's a fetch in progress, abandon it
            // sun
            // e.g. the previous Url is taking a long time to fetch
            // so the user just drags another file maybe... 
            backgroundImageFetchCancellable?.cancel()
            let session = URLSession.shared
            // get a publisher for this background image url
            let publisher = session.dataTaskPublisher(for: url)
                // change the publisher's output to be UIImage? instead of (Data, URLResponse)
                .map { (data, urlResponse) in UIImage(data: data) }
                // if the publisher fails, just set the UIImage? to nil
                // Sun: this turns the Error to Never for this publisher
                .replaceError(with: nil)
                // be sure to have all subscribers do their work on the main queue
                .receive(on: DispatchQueue.main)
            
//             Lecture 13 Notes: SUN
            // assign whatever the publisher spits out to this var
//            let cancellable = publisher
//                // subsribe
//                .assign(to: \EmojiArtDocument.backgroundImage, on: self)
            
            // subscribe to the (modified) URLSession dataTaskPublisher
            backgroundImageFetchCancellable = publisher
                // execute this closure whenever that publisher publishes
                // (set our background image and fetch status)
                .sink { [weak self] image in
                    // SUN
                    // weak b/c if the fetching took super long and the user already
                    // abandoned this file or whatever,
                    // sinking attempts will be ignored
                    // since we don't want this closure to be in the memory forever,
                    // waiting for some invalid url that may never come back...
                    self?.backgroundImage = image
                    self?.backgroundImageFetchStatus = (image != nil) ? .idle : .failed(url)
                }
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        case .blank:
            break
        }
    }
    
    // MARK: - Intent(s)
    
    // L14 add UndoManager argument to all Intent functions
    
    func setBackground(_ background: EmojiArtModel.Background, undoManager: UndoManager?) {
        undoablyPerform(operation: "Set Background", with: undoManager) {
            emojiArt.background = background
        }
    }
    
    func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat, undoManager: UndoManager?) {
        undoablyPerform(operation: "Add \(emoji)", with: undoManager) {
            emojiArt.addEmoji(emoji, at: location, size: Int(size))
        }
    }
    
    func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize, undoManager: UndoManager?) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            undoablyPerform(operation: "Move", with: undoManager) {
                emojiArt.emojis[index].x += Int(offset.width)
                emojiArt.emojis[index].y += Int(offset.height)
            }
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat, undoManager: UndoManager?) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            undoablyPerform(operation: "Scale", with: undoManager) {
                emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
            }
        }
    }
    
    // L14
    // MARK: - Undo
    
    // a helper function
    // it performs the given closure (doit)
    // but before it does, it grabs our Model into a local variable
    // and then after it performs doit, it registers and undo with UndoManager
    // that registered undo simply goes back to the copy of the Model in the local var
    // (it does that "going back" undoably which then makes redo work)
    
    private func undoablyPerform(operation: String, with undoManager: UndoManager? = nil, doit: () -> Void) {
        let oldEmojiArt = emojiArt
        doit()
        undoManager?.registerUndo(withTarget: self) { myself in
            // made it redo by making undo undoable...
            myself.undoablyPerform(operation: operation, with: undoManager) {
                myself.emojiArt = oldEmojiArt
            }
        }
        undoManager?.setActionName(operation)
    }
}
