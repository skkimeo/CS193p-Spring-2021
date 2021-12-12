//
//  Camera.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 5/24/21.
//

import SwiftUI

// L15 UIKit's UIImagePickerController adapted to SwiftUI
// L16 Moved to iOS-only on multiplatform version
// sun
// Camera is some type of View with camera and buttons in it!

struct Camera: UIViewControllerRepresentable {
    // sun
    // when the camera takes a pictue it'll call this function
    // with whatever the image from the camera
    // in other words, it tells whether a new image was picked
    var handlePickedImage: (UIImage?) -> Void
    
    static var isAvailable: Bool {
        // the UIKit object that puts the camera up and takes a picture
        // a controller
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(handlePickedImage: handlePickedImage)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        // sun
        // as ur taking the picture u can kinda pinch w/ ur finger and zoom
        picker.allowsEditing = true
        // sun
        // this is the object that receives a message when a photo is taken
        // with the camera or when u hit the cancel button
        // this is the coordinator created by func makeCoordinator()
        picker.delegate = context.coordinator
        return picker
    }
    
    // sun
    // required b/c updating(invalidating and redrawing body) is
    // the essence of SwiftUI
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // nothing to do
        // sun
        // b/c we're just gonna be putting this up in a sheet
        // so SwiftUI doesn't really change
    }
    
    // sun
    // always name the delegate(class) as coordinator when using it as part of
    // implementing UIViewControlRepresentables by convention
    // UIImagePickerControlDelegate has things saying that
    // "I canceled picking it" and "I did pick it"
    // this coordinator will receive messages from the controller and
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        // we're gonna have to communicate that back out to the SwiftUI world
        // using handlePickedImage
        var handlePickedImage: (UIImage?) -> Void
        
        // need to init this b/c Coordinator is a class
        init(handlePickedImage: @escaping (UIImage?) -> Void) {
            self.handlePickedImage = handlePickedImage
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            handlePickedImage(nil)
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Sun
            // infoKeys have originalImage and editedImage
            handlePickedImage((info[.editedImage] ?? info[.originalImage]) as? UIImage)
        }
    }
}
