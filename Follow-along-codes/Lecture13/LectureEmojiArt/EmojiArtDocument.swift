//
//  EmojiArtDocument.swift
//  LectureEmojiArt
//
//  Created by sun on 2021/10/20.
//

import SwiftUI
import Combine

class EmojiArtDocument: ObservableObject {
    
    @Published private(set) var emojiArt: EmojiArtModel {
        didSet {
            scheduledAutosave()
            if emojiArt.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
            }
        }
    }
    
    private var autosaveTimer: Timer?
    
    private func scheduledAutosave() {
        autosaveTimer?.invalidate()
        autosaveTimer = Timer.scheduledTimer(withTimeInterval: Autosave.coalescingInterval, repeats: false) { _ in
            // don't do weak self here b/c you want this to live in the memory
            // until it can actually autosave
            self.autosave()
        }
    }
    
    // going to have this shared thruout the file
    private struct Autosave {
        static let filename = "Autosaved.emojiart"
        static var url: URL? {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            return documentDirectory?.appendingPathComponent(filename)
        }
        static let coalescingInterval = 5.0
    }
    
    private func autosave() {
        if let url = Autosave.url {
            save(to: url)
        }
    }
    
    private func save(to url: URL) {
        // you save to some url to the File System
        // 1. encode data
        // 2. save it to the url
        let thisfunction = "\(String(describing: self)).\(#function)"
        do {
            let data: Data = try emojiArt.json()
            print("\(thisfunction) json = \(String(data: data, encoding: .utf8) ?? "nil")")
            try data.write(to: url)
        } catch let encodingError where encodingError is EncodingError {
            print("\(thisfunction) couldn't encode EmojiArt as JSON because \(encodingError.localizedDescription)")
        } catch {
            print("\(thisfunction) error = \(error)")
        }
    }
    
    
    init() {
        // check if there's some saved data
        if let url = Autosave.url, let autosavedEmojiArt = try? EmojiArtModel(url: url) {
            emojiArt = autosavedEmojiArt
            fetchBackgroundImageDataIfNecessary()
        } else {
            // create a new empty emojiArt
            emojiArt = EmojiArtModel()
        }
        //        emojiArt.addEmoji("😀", at: (-200, -100), size: 80)
        //        emojiArt.addEmoji("☀️", at: (50, 100), size: 40)
    }
    
    //syntatic sugar
    var emojis: [EmojiArtModel.Emoji] { emojiArt.emojis }
    var background: EmojiArtModel.Background { emojiArt.background }
    
    
    // MARK: - Background
    
    // prof says this can't be computed var b/c could take too long
    // but why do we have to watch on didSet for this?
    // I guess the first line is literally the answer
    @Published var backgroundImage: UIImage?
    // var to tell the user about the current fetching status
    @Published var backgroundImageFetchStatus = BackgroundImageFetchStatus.idle
    
    enum BackgroundImageFetchStatus: Equatable {
        case idle
        case fetching
        case failed(URL)
    }
    
    @Published var backgroundImageFetchCancellable: AnyCancellable?
    
    private func fetchBackgroundImageDataIfNecessary() {
        // why do I have to set this to nil...?
        backgroundImage = nil
        backgroundImageFetchCancellable?.cancel()
        switch emojiArt.background {
        case .url(let url):
            // fetch the url
            backgroundImageFetchStatus = .fetching
            // 1. get a publisher
            let session = URLSession.shared
            let publisher = session.dataTaskPublisher(for: url)
                // 2. fetch data using the publisher and modify it
                .map { (data, urlResponse) in UIImage(data: data)}
                // 3. make error Never
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
            
            backgroundImageFetchCancellable = publisher
                // 4. subsrcibe to the publisher
                .sink { [weak self] image in
                    // 5. do action on what the subscriber recieved
                    self?.backgroundImage = image
                    self?.backgroundImageFetchStatus = image != nil ? .idle : .failed(url)
                }
            
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        case .blank:
            break
        }
        
    }
    
    // MARK: - Intent(s)
    
    func setBackground(_ background: EmojiArtModel.Background ) {
        emojiArt.background = background
    }
    
    func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat) {
        emojiArt.addEmoji(emoji, at: location, size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
        }
    }
}
