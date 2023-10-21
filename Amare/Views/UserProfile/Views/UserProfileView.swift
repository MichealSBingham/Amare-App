//
//  UserProfileView.swift
//  Amare
//
//  Created by Micheal Bingham on 7/26/23.
//

import SwiftUI



struct UserProfileView: View {
	
	@EnvironmentObject var currentUserDataModel: UserProfileModel
	@ObservedObject  var model: UserProfileModel // was @ObservedObject but it makes it lag changes .. TODO: optimize this because theoretically  we need to be using @ObservedObject but it makes it lag when you switch between profile changes because it show sold data, maybe we can change to environment object or something
    
    @State var showNearbyInteraction: Bool = false
	
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
    fileprivate func nearbyConnectionButton() -> some View {
        Button {
            withAnimation{ showNearbyInteraction.toggle() }
        } label: {
            
            Image(systemName: "person.line.dotted.person.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50)
                .foregroundColor(.green)
        }
        .buttonStyle(.plain)
    }
    
	
	@ViewBuilder
	fileprivate func friendshipStatus() -> some View {
		Button{
			
		print("did tap friendship status")
			if model.friendshipStatus == .requested{
				guard let current = currentUserDataModel.user else { print("Can't add friend, no signed in user"); return }
				model.cancelFriendRequest()
			}
            
            if model.friendshipStatus == .notFriends {
                guard let current = currentUserDataModel.user else { print("Can't add friend, no signed in user"); return }
                model.addFriend(currentSignedInUser: current)
            }
            
            if model.friendshipStatus == .awaiting{
                guard let current = currentUserDataModel.user else { print("Can't add friend, no signed in user"); return }
                model.acceptFriendRequest()
        
            }
            
			
		}
	label: {
        
        
        FriendshipStatusView(friendshipStatus: model.friendshipStatus)
            .frame(width: 35)
            .transition(.scale)
	}
    .disabled( model.friendshipStatus == .friends)
	}
	
	@ViewBuilder
	fileprivate func addFriend() -> some View {
		
	
			Button {
				
				if model.friendshipStatus == .notFriends {
					guard let current = currentUserDataModel.user else { print("Can't add friend, no signed in user"); return }
					model.addFriend(currentSignedInUser: current)
				}
                
                if model.friendshipStatus == .awaiting{
                    guard let current = currentUserDataModel.user else { print("Can't add friend, no signed in user"); return }
                    model.acceptFriendRequest()
            
                }
				
				
				
			} label: {
				

						
						Image(systemName: "person.fill.badge.plus")
							.resizable()
							.frame(width: 35, height: 35)
							.foregroundColor(model.friendshipStatus == .awaiting ? .green : .amare)
							.transition(.scale)
							.opacity(model.friendshipStatus == .friends || model.friendshipStatus == .requested ? 0: 1)
							
						

				
				
			}
			.frame(width: 20, height: 50)
		

		
			
	}

    @ViewBuilder
    fileprivate func rejectFriend() -> some View {
        
        Button {
            
            if model.friendshipStatus == .awaiting{
                guard let current = currentUserDataModel.user else { print("Can't add friend, no signed in user"); return }
                model.rejectFriendRequest()
            }
            
        } label: {
            Image(systemName: UserFriendshipStatus.notFriends.imageName)
            .resizable()
            .frame(width: 35, height: 25)
            .foregroundColor(.red)
            .transition(.scale)
        }
        .opacity(model.friendshipStatus == .awaiting ? 1 : 0 )

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
					  
				
				
                
                rejectFriend()
                    .padding()
                
                nearbyConnectionButton()
                    .padding()
                    .sheet(isPresented: $showNearbyInteraction,  content: {
                        FindNearbyUserView( user: model.user! , blindMode: false)
                    })
					 
				
				

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
        var helper = NearbyInteractionHelper()
		UserProfileView(model: UserProfileModel.previewInstance())
			.environmentObject(UserProfileModel.previewInstance())
            .environmentObject(helper)
            .environmentObject(BackgroundViewModel())
    }
}
