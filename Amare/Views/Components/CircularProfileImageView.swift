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

enum ProfileOverlayIcon: String {
    case famousIndicator = "star.fill"
   
}

/**
 `CircularProfileImageView` is a SwiftUI view that displays a circular profile image with optional features such as a winking emoji and a notable/famous indicator.
 
 - Parameters:
   - profileImageUrl: The URL as a `String` for the profile image. Defaults to a placeholder image if the URL is nil.
   - isNotable: A `Bool` that indicates if the user is notable or famous. If true, a star indicator will be displayed above the profile image.
   - winked: A `Bool` that indicates if a winking emoji should be displayed on the profile image. If true, a wink emoji appears at the upper right corner of the profile image.
   - offsetFamousIndicator: An `Int` used to offset the notable/famous indicator vertically. Modify this value to move the indicator higher or lower relative to the profile image.
 
 - Environment Variables:
   - colorScheme: Detects the device's current color scheme (dark or light mode) to adjust the color of the notable/famous indicator.
 
 Example usage:
 ```swift
 CircularProfileImageView(profileImageUrl: "https://example.com/profile.jpg", isNotable: true, winked: false)```
**/
struct CircularProfileImageView: View {
    
    var profileImageUrl: String?
    
    /// If the user is a celebrity / notable / famous
    var isNotable: Bool?
    
    /// If the user winked there will be a wink emoji at the top corner
    var winked: Bool?
    
    /// Sometimes if the image is too small/large, you will need to experiment with changing this paramter to make the famous/notable indicator higher or lower
    var offsetFamousIndicator: Int = 20
    
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                
                    // Profile Image
                    WebImage(url: URL(string: profileImageUrl ?? "https://via.placeholder.com/150"))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .shadow(radius: 15)
                        
                    
                    // Wink Emoji
                    if winked ?? false{
                        Text("😉")
                            .font(.system(size: geometry.size.width * 0.2))
                            .offset(x: geometry.size.width * 0.35, y: -geometry.size.height * 0.35)
                    }
                
                if isNotable ?? false{
                    Image(systemName: ProfileOverlayIcon.famousIndicator.rawValue)
                        .resizable()
                        .foregroundColor(colorScheme == .dark ? Color(red: 249/255, green: 239/255, blue: 0/255) : Color.amare)
                .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.25)
                .offset(CGSize(width: 0, height: Int(-geometry.size.height)/2 - offsetFamousIndicator))
                }
                
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}



struct CircularProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProfileImageView(profileImageUrl: AppUser.generateMockData().profileImageUrl, isNotable: true, winked: true)
            .frame(width: 100, height: 100)
        /*
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
        */
    }
}

/*
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
*/
