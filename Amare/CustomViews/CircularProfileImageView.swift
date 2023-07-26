//
//  CircularProfileImageView.swift
//  Amare
//
//  Created by Micheal Bingham on 7/17/23.
//

import SwiftUI
import URLImage

import SwiftUI
import SDWebImageSwiftUI

import SwiftUI
import SDWebImageSwiftUI

struct CircularProfileImageView: View {
    var profileImageUrl: String
    
    var body: some View {
        WebImage(url: URL(string: profileImageUrl) ?? URL(string: "https://via.placeholder.com/150")) // a default placeholder image URL
            .resizable()
        
            .placeholder {
                // Placeholder Image
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .clipShape(Circle())
            }
           
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .shadow(radius: 15)
    }
}


/*
struct CircularProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProfileImageView(profileImageUrl: "")
            .frame(width: 150, height: 150) // Use frame modifier for size
            .preferredColorScheme(.dark)
    }
}
*/

#Preview {
    
    HStack{
        CircularProfileImageView(profileImageUrl: FriendRequest.random().profileImageURL)
            .frame(width: 75, height: 75)
            .padding()
        
        Text(FriendRequest.random().name)
            .lineLimit(1)
            .font(.title)
            .padding()
            
        
        Spacer()
    }
    .background(.ultraThinMaterial)
                    .cornerRadius(14)
    
    .preferredColorScheme(.dark)
    
}
