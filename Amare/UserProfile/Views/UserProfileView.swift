//
//  UserProfileView.swift
//  Amare
//
//  Created by Micheal Bingham on 7/26/23.
//

import SwiftUI



struct UserProfileView: View {
	
	@EnvironmentObject var currentUserDataModel: UserProfileModel
	@StateObject  var model: UserProfileModel
	
	fileprivate func winkStatusLabel() -> some View {
		return Text((model.winkedAtMe ?? false) ? "\(model.user?.name ?? "") 😉 at you" : "")
			.fontWeight(.light)
	}
	
	
	fileprivate func nameAndAgeLabel() -> some View {
		return HStack{
			
			Text(model.user?.name ?? "")
				.font(.largeTitle)
				.fontWeight(.bold)
				.padding(.horizontal)
			Spacer()
			Text(model.user?.birthday.approximateAgeText() ?? "")
				.font(.title)
				.fontWeight(.light)
				.padding(.horizontal)
		}
	}
	
	fileprivate func messageButton() -> some View {
		return Button {
			
		} label: {
			
			Image(systemName: "message.fill")
				.resizable()
				.frame(width: 25, height: 25)
				.foregroundColor(.amare)
		}
		.buttonStyle(.plain)
	}
	
	@ViewBuilder
	fileprivate func friendshipStatus() -> some View {
		Button{
			
		
			if model.friendshipStatus == .requested{
				guard let current = currentUserDataModel.user else { print("Can't add friend, no signed in user"); return }
				model.cancelFriendRequest(currentSignedInUser: current)
			}
			
		}
	label: {
			Image(systemName: model.friendshipStatus.imageName)
			.resizable()
			.frame(width: 35, height: 25)
			.foregroundColor(Color.amare)
			.transition(.scale)
	}
	.disabled(model.friendshipStatus == .notFriends)
	}
	
	@ViewBuilder
	fileprivate func addFriend() -> some View {
		
	
			
			Button {
				
				if model.friendshipStatus == .notFriends {
					guard let current = currentUserDataModel.user else { print("Can't add friend, no signed in user"); return }
					model.addFriend(currentSignedInUser: current)
				}
				
				
				
			} label: {
				
				
					
				
						
						Image(systemName: "person.fill.badge.plus")
							.resizable()
							.frame(width: 35, height: 35)
							.foregroundColor(Color.amare)
							.transition(.scale)
							.opacity(model.friendshipStatus == .friends || model.friendshipStatus == .requested ? 0: 1)
							.foregroundColor(model.friendshipStatus == .awaiting ? .green : .amare)
						
					
						
						
						
					
					
						
					
					
				
				
				
				
			}
			.frame(width: 20, height: 50)
		

		
			
	}


	
	var body: some View {
		VStack{
			
			ImageForUserProfileView(profile_image_url: model.user?.profileImageUrl  )
				//.frame(width: 200, height: 200)
			
			winkStatusLabel()
			
			
			nameAndAgeLabel()
			.padding(.top)
			
			NatalChartTabView(natalChart: model.natalChart)
			
			HStack{
				
				messageButton()
					.padding()
					 
				
				friendshipStatus()
					.padding()
					  
				
				addFriend()
					.padding()
					 
				
				

			}
			
			
		}
		.onDisappear{
			print("on disappear user profile view")
			model.unloadUser()
		}
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
		UserProfileView(model: UserProfileModel.previewInstance())
			//.environmentObject(UserProfileModel.previewInstance())
    }
}
