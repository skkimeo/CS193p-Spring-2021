//
//  ContentView.swift
//  Memorize
//
//  Created by sun on 2021/09/26.
//

import SwiftUI

struct ContentView: View {
    let vehicleEmojis = ["🚙", "🛴", "✈️", "🛵", "⛵️", "🚎", "🚐", "🚛",
                      "🛻", "🏎", "🚂", "🚊", "🚀", "🚁", "🚢", "🛶",
                      "🛥", "🚞", "🚤", "🚲", "🚡", "🚕", "🚟", "🚃"]
    
    var animalEmojis = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼"]
    
    var foodEmojis = ["🍔", "🥐", "🍕", "🥗", "🥟", "🍣", "🍪", "🍚",
                      "🍝", "🥙", "🍭", "🍤", "🥞", "🍦", "🍛", "🍗"]
    
    @State var emojis = ["🚙", "🛴", "✈️", "🛵", "⛵️", "🚎", "🚐", "🚛",
                         "🛻", "🏎", "🚂", "🚊", "🚀", "🚁", "🚢", "🛶",
                         "🛥", "🚞", "🚤", "🚲", "🚡", "🚕", "🚟", "🚃"]
    
    @State var emojiCount = 17
    
    var body: some View {
        NavigationView {
            VStack{
                ScrollView {
                    let bestWidth = widthThatBestFits(cardCount: emojiCount)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: bestWidth))]) {
                        ForEach(emojis[0..<emojiCount], id: \.self) {
                            CardView(content: $0).aspectRatio(2/3, contentMode: .fit)
                        }
                    }
                }
                .foregroundColor(.red)
                Spacer()
                HStack {
                    Spacer()
                    vehicleButton
                    Spacer()
                    foodButton // fork.knife
                    Spacer()
                    animalButton // pawprint.fill
                    Spacer()
                }
                .padding(.top)
            }
            .padding(.horizontal)
            .navigationTitle("Memorize!")
        }
    }
    
    var vehicleButton: some View {
        VStack {
            Button {
                emojis = vehicleEmojis.shuffled()
                emojiCount = Int.random(in: 4...emojis.count)
            } label: {
                VStack {
                    Image(systemName: "car.fill").font(.largeTitle)
                    Text("Vehicles").font(.footnote)
                }
            }
        }
    }
    
    var foodButton: some View {
        VStack {
            Button {
                emojis = foodEmojis.shuffled()
                emojiCount = Int.random(in: 4...emojis.count)
            } label: {
                VStack {
                    Image(systemName: "bag.fill").font(.largeTitle)
                    Text("Food").font(.footnote)
                }
            }
        }
    }
    
    var animalButton: some View {
        VStack {
            Button {
                emojis = animalEmojis.shuffled()
                emojiCount = Int.random(in: 4...emojis.count)
            } label: {
                VStack {
                    Image(systemName: "hare.fill").font(.largeTitle)
                    Text("Animals").font(.footnote)
                }
            }
        }
    }
    
}

func widthThatBestFits(cardCount: Int) -> CGFloat {
    switch cardCount {
    case 4:
        return 110
    case 5...9:
        return 80
    case 10...16:
        return 63
    default:
        return 62
    }
}

struct CardView: View {
    var content: String
    @State var isFaceUp: Bool = true
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}






















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.light)
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
