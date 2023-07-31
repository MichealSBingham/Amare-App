//
//  SearchAndFriendsView.swift
//  Amare
//
//  Created by Micheal Bingham on 7/11/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase



/// View that displays `FriendRequest`s, `Friend`s, `Suggestions`
struct SearchAndFriendsView: View {
    
    @StateObject var dataModel = SearchAndFriendsViewModel()
    
    @State private var searchText = ""
    
    @State var segmentationSelection : UserTypeSection = .all
    
	@StateObject var tappedUser: UserProfileModel = UserProfileModel()
    
	@State var selectedUser: Bool = false
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                
                SegmentedMenuView(segmentationSelection: $segmentationSelection)
                
                if segmentationSelection == .all{
                    
                    List(dataModel.all) { user in
						
                        
						Button {
						print("Tapped userId \(user.userId) and id: \(user.id)")
						tappedUser.loadUser(userId: user.userId)
							selectedUser = true
						} label: {
							
							UserListRowView(imageUrl: user.profile_image_url ?? "", text: user.username, isNotable: user.isNotable)
								
						}
						.buttonStyle(.plain)
						.listRowInsets(EdgeInsets())
						.listRowSeparator(.hidden)
					

							
								
						
						
						

						
						
                        
                        
                    }
					.listStyle(.plain)
					.padding(0)
                    
                   
                }
                
                if segmentationSelection == .friends{
                    
                    List(dataModel.friends) { friends in
                        Text(friends.name)
                    }
					.listStyle(.plain)
					.padding(0)
                    
                }
                
                if segmentationSelection == .requests{
                    
                    List(dataModel.friendRequests) { request in
						
			
						
						
						UserListRowView(imageUrl: request.profileImageURL, text: request.name, isNotable: request.isNotable)
							.listRowInsets(EdgeInsets())
							.listRowSeparator(.hidden)
							
							
						
                    }
					.listStyle(.plain)
					.padding(0)
					

                    
                }
                
                if segmentationSelection == .custom{
                    
                    List(dataModel.friendRequests) { request in
                        Text(request.name)
                    }
					.listStyle(.plain)
					.padding(0)
                    
                }
                
                
            }
            .scrollContentBackground(.hidden)
			.background(
						NavigationLink(destination: UserProfileView(model: tappedUser),
									   isActive: $selectedUser) { EmptyView() }
					)

            
        
            
                        
           
            .padding()
            .searchable(text: $searchText) {
                // If you want to provide suggestions as user types in the search bar, you can add them here.
                
            }
            .onChange(of: searchText){ text in
                
                switch segmentationSelection {
                case .all:
                    dataModel.searchUsers(matching: text)
                case .friends:
                    if let id = Auth.auth().currentUser?.uid{
                        dataModel.fetchFriendRequests(for: id)
                    }
                    
                case .requests:
                    break
                case .suggestions:
                    break
                case .custom:
                    break
                }
            }
            
            .navigationTitle(Text("Friends"))
        }
    }
}


struct SearchAndFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        SearchAndFriendsView()
			.environmentObject(SearchAndFriendsViewModel())
            .environmentObject(AuthService.shared)
            
    }
}






import SwiftUI

struct Friend: Identifiable {
    let id = UUID()
    let name: String
    let category: String
}

struct ContentView4: View {
    @State private var searchText = ""

    let friends: [Friend] = [
        Friend(name: "John", category: "Friends"),
        Friend(name: "Emma", category: "Friends"),
        Friend(name: "Sarah", category: "Friends"),
        Friend(name: "Brad", category: "Celebrities"),
        Friend(name: "Jennifer", category: "Celebrities"),
        Friend(name: "Chris", category: "Colleagues")
    ]

    var filteredFriends: [Friend] {
        if searchText.isEmpty {
            return friends
        } else {
            return friends.filter { friend in
                friend.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Friends")) {
                    ForEach(filteredFriends.filter { $0.category == "Friends" }) { friend in
                        Text(friend.name)
                    }
                }

                Section(header: Text("Celebrities")) {
                    ForEach(filteredFriends.filter { $0.category == "Celebrities" }) { friend in
                        Text(friend.name)
                    }
                }

                Section(header: Text("Colleagues")) {
                    ForEach(filteredFriends.filter { $0.category == "Colleagues" }) { friend in
                        Text(friend.name)
                    }
                }
            }
            .navigationTitle("Friends")
            .searchable(text: $searchText)
        }
    }
}


