//
//  ProfileImagesStack.swift
//  Amare
//
//  Created by Micheal Bingham on 10/29/23.
//

import SwiftUI

struct ProfileImagesStack: View {
    var images: [String]
    var stackLimit: Int
    var extraOffset: CGFloat
    
    init(images: [String], stackLimit: Int = 5, extraOffset: CGFloat = 10) {
        self.images = images
        self.stackLimit = stackLimit
        self.extraOffset = extraOffset
    }
    
    var body: some View {
        ZStack {
            ForEach(Array(images.prefix(stackLimit).enumerated()), id: \.offset) { index, imageUrl in
                createStackedImage(imageUrl: imageUrl, index: index)
            }
        }
    }
    
    private func createStackedImage(imageUrl: String, index: Int) -> some View {
        let offset = extraOffset * CGFloat(index)
        
        return CircularProfileImageView(profileImageUrl: imageUrl, isNotable: false)
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .shadow(radius: 15)
            .padding([.leading, .trailing])
            .offset(x: offset)
    }
}


#Preview {
    ProfileImagesStack(images: peopleImages, stackLimit: 3, extraOffset: 50)
        .frame(width: 200)
}


