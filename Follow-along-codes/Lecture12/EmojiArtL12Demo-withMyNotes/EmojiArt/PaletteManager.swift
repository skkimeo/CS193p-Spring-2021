//
//  PaletteManager.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 5/5/21.
//

import SwiftUI

// L12 a View which manages all the Palettes in a PaletteStore

struct PaletteManager: View {
    @EnvironmentObject var store: PaletteStore
    
    // a Binding to a PresentationMode
    // which lets us dismiss() ourselves if we are isPresented(i.e. popover or sheet)
    @Environment(\.presentationMode) var presentationMode
    
    
    // we inject a Binding to this in the environment for the List and EditButton
    // using the \.editMode in EnvironmentValues
    // sun: u can get and set Environment variables for a certain View
    //      this is the Enviroonment in which a certain View is working
    //      we're binging the EditMode to a local variable in our View
    //      and then for all the editing that's going on in our View
    //      we own that variable(i.e. @State var editMode)
    //      binding enables shared looking, becomes like a singleton?
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.palettes) { palette in
                    // tapping on this row in the List will navigate to a PaletteEditor
                    // (not subscripting by the Identifiable)
                    // (see the subscript added to RangeReplaceableCollection in UtilityExtensiosn)
                    // sun: since this is a binding, the actual Model is being modified!
                    NavigationLink(destination: PaletteEditor(palette: $store.palettes[palette])) {
                        VStack(alignment: .leading) {
                            Text(palette.name)
                            Text(palette.emojis)
                        }
                        // tapping when NOT in editMode will follow the NavigationLink
                        // (that's why gesture is set to nil in that case)
                        .gesture(editMode == .active ? tap : nil)
                    }
                }
                // teach the ForEach how to delete items
                // at the indices in indexSet from its array
                .onDelete { indexSet in
                    store.palettes.remove(atOffsets: indexSet)
                }
                // teach the ForEach how to move items
                // at the indices in indexSet to a newOffset in its array
                .onMove { indexSet, newOffset in
                    store.palettes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
            }
            .navigationTitle("Manage Palettes")
            .navigationBarTitleDisplayMode(.inline)
            // add an EditButton on the trailing side of our NavigationView
            // and a Close button on the leading side
            // notice we are adding this .toolbar to the List
            // (not to the NavigationView)
            // (NavigationView looks at the View it is currently showing for toolbar info)
            // (ditto title and titledisplaymode above)
            .toolbar {
                // List and EditButton are Looking at the same EditMode
                // b/c in the same Environment
                ToolbarItem { EditButton() }
                ToolbarItem(placement: .navigationBarLeading) {
                    // need to access wrappedValue
                    // b/c presentataionMode is a binding
                    if presentationMode.wrappedValue.isPresented,
                       UIDevice.current.userInterfaceIdiom != .pad {
                        Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            // see comment for editMode @State above
            .environment(\.editMode, $editMode)
        }
    }
    
    // sun : this is required b/c u can't do just onTapGesture under NaviagtionLink
    // since then the tapGesture will override navigation link
    var tap: some Gesture {
        TapGesture().onEnded { }
    }
}

//struct PaletteManager_Previews: PreviewProvider {
//    static var previews: some View {
//        PaletteManager()
//            .previewDevice("iPhone 8")
//            .environmentObject(PaletteStore(named: "Preview"))
//            .preferredColorScheme(.light)
//    }
//}
