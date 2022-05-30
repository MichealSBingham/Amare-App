//
//  TitleRowForMessagingView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/29/22.
//

import SwiftUI

let mockProfileImageURL = "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1287&q=80"

struct TitleRowForMessagingView: View {
	
	
	
	@Binding var user: AmareUser

    var body: some View {
		VStack{
			
			ProfileImageView(profile_image_url: user.profile_image_url ?? mockProfileImageURL)
				.padding([.top, .bottom], -20)
				
			
			Text(user.name)
				.font(.body)
				//.padding(-5)
		}
		.frame(maxWidth: .infinity)
		.background(.ultraThinMaterial)
		.foregroundColor(Color.primary.opacity(0.35))
		.foregroundStyle(.ultraThinMaterial)
		.cornerRadius(20)
		
	
		//.padding()
		
		
		
    }
}

struct TitleRowForMessagingView_Previews: PreviewProvider {
    static var previews: some View {
		TitleRowForMessagingView(user: .constant(AmareUser(name: "Iris Louis", profile_image_url: mockProfileImageURL)))
			.preferredColorScheme(.dark)
			
    }
}
