//
//  UserListRow.swift
//  Amare
//
//  Created by Micheal Bingham on 7/27/23.
//

import SwiftUI

struct UserListRowView: View {
	var imageUrl: String
	var text: String
	var isNotable: Bool? = false
	
    var body: some View {
		HStack{
			CircularProfileImageView(profileImageUrl: imageUrl)
				.frame(width: 40, height: 40)
				.padding()
			
			Text(text)
				.lineLimit(1)
				.font(.subheadline)
				//.padding()
			
			Text("✨")
				.opacity(isNotable == true ? 1: 0 )
			
			Spacer()
		}
		
    }
}

struct UserListRowView_Previews: PreviewProvider {
    static var previews: some View {
		UserListRowView(imageUrl: AppUser.generateMockData().profileImageUrl, text: AppUser.generateMockData().username, isNotable: AppUser.generateMockData().isNotable)
    }
}


import SwiftUI

