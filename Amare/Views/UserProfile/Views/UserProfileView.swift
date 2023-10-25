//
//  UserProfileView.swift
//  Amare
//
//  Created by Micheal Bingham on 7/26/23.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI



struct UserProfileView: View {
    @Injected(\.chatClient) var chatClient
    
	@EnvironmentObject var currentUserDataModel: UserProfileModel
	@ObservedObject  var model: UserProfileModel // was @ObservedObject but it makes it lag changes .. TODO: optimize this because theoretically  we need to be using @ObservedObject but it makes it lag when you switch between profile changes because it show sold data, maybe we can change to environment object or something
    
    @State var showNearbyInteraction: Bool = false
	
    @available(*, deprecated, message: "Will be removed soon. We won't need it.")
    fileprivate func winkStatusLabel() -> some View {
    return Text((model.winkedAtMe ?? false) ? "\(model.user?.name ?? "") 😉 at you" : "")
        .fontWeight(.light)
}
	
    @available(*, deprecated, message: "This function will be removed soon. Use newFunction() instead.")
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
	
    //TODO: maybe the user ids won't always be loaded ?? do something here maybe
    /* fileprivate func messageButton() -> some View {
        return NavigationLink(destination: ChatChannelView(
            viewFactory: CustomViewFactory(),
            channelController: try! chatClient.channelController(createDirectMessageChannelWith: [model.user?.id ?? "", currentUserDataModel.user?.id ?? ""], extraData: [:])
        ))
        
        {
            Image(systemName: "envelope.circle")
                .resizable()
                .frame(width: 30, height: 30)
        }
        .buttonStyle(.plain)
    } */
    
    fileprivate func messageButton() -> some View {

        return NavigationLink(destination: DirectMessageView().tabBar(hidden: true)/*ChatChannelView(
            viewFactory: CustomViewFactory(),
            channelController: try! chatClient.channelController(createDirectMessageChannelWith: ["micheal", "elizabeth"], extraData: [:])
        )*/)
        
        {
            Image(systemName: "envelope.circle")
                .resizable()
                .frame(width: 30, height: 30)
        }
        .buttonStyle(.plain)
    }

    
    fileprivate func winkButton() -> some View {
        return Button {
            
        } label: {
            
            
            
           Text("😉")
                .font(
                Font.custom("SF Pro", size: 30)
                .weight(.black)
                )
                .frame(width: 30)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    fileprivate func nearbyConnectionButton() -> some View {
        Button {
            withAnimation{ showNearbyInteraction.toggle() }
        } label: {
           
            Image("location")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30)
               // .foregroundColor(.blue)
                
        }
        .buttonStyle(.plain)
    }
    
    func cancelFriendRequestAction() {
        guard let current = currentUserDataModel.user else { print("Can't add friend, no signed in user"); return }
        model.cancelFriendRequest()
    }
	
    func addFriendAction(){
        guard let current = currentUserDataModel.user else { print("Can't add friend, no signed in user"); return }
        model.addFriend(currentSignedInUser: current)
    }
    
    func acceptFriendAction(){
        guard let current = currentUserDataModel.user else { print("Can't add friend, no signed in user"); return }
        model.acceptFriendRequest()
    }
    
	@ViewBuilder
    @available(*, deprecated, message: "This function will be removed soon. ")
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
	
    @available(*, deprecated, message: "This function will be removed soon. ")
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
    @available(*, deprecated, message: "This function will be removed soon.")
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
    
    
    fileprivate func menuOptionsButton(username: String?) -> some View {
        MenuOptionsView()
            .contextMenu {
                            if model.friendshipStatus == .friends {
                                Button(action: {
                                    // Your remove friend action here
                                }) {
                                    HStack {
                                        Text("Remove as Friend")
                                        Image(systemName: "person.fill.xmark")
                                    }
                                }
                                .foregroundColor(.red)
                            }
                            
                            Button(action: {
                                // Your block action here
                            }) {
                                HStack {
                                    Text("Block \(username ?? "")")
                                    Image(systemName: "hand.raised.fill")
                                }
                            }
                            .foregroundColor(.red)
                            
                            Button(action: {
                                // Your report action here
                            }) {
                                HStack {
                                    Text("Report")
                                    Image(systemName: "flag.fill")
                                }
                            }
                        }
            
        
    }
	
	var body: some View {
		VStack{
			
            UPSectionView(profileImageURL: model.user?.profileImageUrl, isNotable: model.user?.isNotable, winked: model.winkedAtMe, name: model.user?.name, username: model.user?.username, friendshipStatus: model.friendshipStatus,
                oneLinerSummary: model.oneLiner, compatibility_score: model.score, natalChart: model.natalChart, cancelFriendRequestAction: cancelFriendRequestAction, addFriendAction: addFriendAction, acceptFriendAction: acceptFriendAction)
            
        
				
			
		//	winkStatusLabel()
			
			
            
            
            
            
			HStack{
				
            
				messageButton()
					.padding()
					 
				Spacer()
                
                nearbyConnectionButton()
                    .padding()
                    .sheet(isPresented: $showNearbyInteraction,  content: {
                        FindNearbyUserView( user: model.user! , blindMode: false)
                    })
				
					  
                Spacer()
                
				winkButton()
                    .padding()
                
                
                
               
                
            
					 
				
				

			}
			
			
		}
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                            BackButton()
                    .padding()
                  
                }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Menu {
                    //MARK: - Button for removing friend
                    if model.friendshipStatus == .friends {
                        Button(action: {
                            cancelFriendRequestAction()
                        }) {
                            HStack {
                                Text("Remove as Friend")
                                Image(systemName: "person.fill.xmark")
                            }
                        }
                        .foregroundColor(.red)
                    }
                    
                    //MARK: - Button for cancelling SENT friend request
                    if model.friendshipStatus == .requested {
                        Button(action: {
                            cancelFriendRequestAction()
                        }) {
                            HStack {
                                Text("Cancel Friend Request")
                                Image(systemName: "person.fill.xmark")
                            }
                        }
                        .foregroundColor(.red)
                    }
                    
                    //MARK: - Button fors for accepting and rejecting friend requests
                    
                    if model.friendshipStatus == .awaiting{
                        Button(action: {
                            acceptFriendAction()
                        }) {
                            HStack {
                                Text("Accept Friend Request")
                                Image(systemName: "person.fill.checkmark")
                            }
                        }
                       
                        
                        Button(action: {
                            model.rejectFriendRequest()
                        }) {
                            HStack {
                                Text("Reject Friend Request")
                                Image(systemName: "person.fill.xmark")
                            }
                        }
                        .foregroundColor(.red)
                    }
                    
                       
                    
                    
                    //MARK: - Button for Blocking
                    Button(action: {
                        // Your block action here
                    }) {
                        HStack {
                            Text("Block @\(model.user?.username ?? "")")
                                .foregroundColor(.red)
                            Image(systemName: "hand.raised.fill")
                                .foregroundColor(.red)
                        }
                    }
                    
                    //MARK: - Button for Reporting
                    
                    Button(action: {
                        // Your report action here
                    }) {
                        HStack {
                            Text("Report @\(model.user?.username ?? "" )")
                            Image(systemName: "flag.fill")
                        }
                    }
                        } label: {
                            MenuOptionsView()
                                .padding()
                                .buttonStyle(PlainButtonStyle())
                                
                        }
                        .buttonStyle(PlainButtonStyle())
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
