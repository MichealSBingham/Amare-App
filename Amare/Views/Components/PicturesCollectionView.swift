//
//  PicturesCollectionView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/17/23.
//

import SwiftUI
import SDWebImageSwiftUI


struct IdentifiableImage: Identifiable {
    let id = UUID() // Unique identifier
    let imageUrl: String
}


struct PicturesCollectionView: View {
    var images: [String] = []
    @State var selectedImage: IdentifiableImage?

    var body: some View {
        GeometryReader { geometry in
            let width = floor(geometry.size.width / 3) // Use floor to round down


            ScrollView {
                LazyVGrid(columns: [GridItem(.fixed(width), spacing: 0), GridItem(.fixed(width), spacing: 0), GridItem(.fixed(width))], spacing: 0) {
                    ForEach(images, id: \.self) { imageUrl in
                        WebImage(url: URL(string: imageUrl))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: width, height: width) // Use dynamic width
                            .clipped()
                            .overlay(Rectangle().stroke(Color.black, lineWidth: 0.5))
                            .onTapGesture {
                                selectedImage = IdentifiableImage(imageUrl: imageUrl)
                            }
                    }
                    
                    
                }
            }
            .padding(0)
        }
        .sheet(item: $selectedImage) { imageUrl in
            FullScreenImageView(imageUrl: imageUrl.imageUrl)
        }
    }
}



struct FullScreenImageView: View {
    let imageUrl: String

    var body: some View {
        WebImage(url: URL(string: imageUrl))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .edgesIgnoringSafeArea(.all)
    }
}






#Preview {
    PicturesCollectionView(images: peopleImages)
}
