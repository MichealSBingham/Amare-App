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
	
	/// Called when the `green checkmark` is tapped
	var greenAction: (() -> Void)?
	/// Called when the `red checkmark` is tapped
	var redAction: (() -> Void)?
	
	 func acceptFriendRequestButton() -> some View {
		return Button(action: {
			// Action to perform on tap
			greenAction!()
		}) {
			Image(systemName: "checkmark")
				.foregroundColor(.green)
				.font(.system(size: 20, weight: .bold))
		}
	}
	
	 func declineFriendRequestButton() -> some View {
		return Button(action: {
			// Action to perform on tap
			redAction!()
		}) {
			Image(systemName: "xmark")
				.foregroundColor(.red)
				.font(.system(size: 20, weight: .bold))
		}
	}
	
	var body: some View {
		
		ZStack{
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
			
			if greenAction != nil && redAction != nil {
				
				HStack{
					Spacer()
					
					acceptFriendRequestButton()
						.padding()

				
					
					declineFriendRequestButton()
						.padding()

				}
			}
			
		}
		
		
    }
}

struct UserListRowView_Previews: PreviewProvider {
    static var previews: some View {
		UserListRowView(imageUrl: AppUser.generateMockData().profileImageUrl!, text: AppUser.generateMockData().username, isNotable: AppUser.generateMockData().isNotable)
    }
}


import SwiftUI

