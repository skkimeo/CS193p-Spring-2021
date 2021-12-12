//
//  ContentView.swift
//  Memorize
//
//  Created by sun on 2021/09/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            //view builder
            //return a bag of legos(Tuple Views) for the ZStack to work on
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .stroke(lineWidth: 3)
            
            Text("Hello World!")
                .foregroundColor(.orange)
        }
        .padding(.horizontal)
        .foregroundColor(.red)
    }
}


















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 12 mini")
    }
}
