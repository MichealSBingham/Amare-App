//
//  SwiftUIView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/26/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(0..<10) { index in
                        TikTokContentView(index: index)
                            .frame(height: 500)
                            .id(index)
                    }
                }
                .onAppear {
                    proxy.scrollTo(0) // Scroll to the top initially
                }
            }
        }
    }
}

struct TikTokContentView: View {
    let index: Int
    
    var body: some View {
        VStack {
            /*
            Image("your-image-\(index)")
                .resizable()
                .scaledToFill()
                .frame(height: 400)
                .clipped()
             */
            
            // Additional content specific to each TikTok view
            Text("TikTok View \(index)")
                .font(.title)
                .padding()
                .foregroundColor(.white)
                .background(Color.black)
        }
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
