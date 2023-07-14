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
    
    @StateObject var dataModel = SearchAndFriendsViewModel(inPreview: true)
    
    @State private var searchText = ""
    
    @State var segmentationSelection : UserTypeSection = .all
    
    
    
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                
                SegmentedMenuView(segmentationSelection: $segmentationSelection)
                
                if segmentationSelection == .all{
                    
                    List(dataModel.friendRequests) { request in
                        
                        HStack{
                            
                            ProfileImageView(profile_image_url: .constant(request.profileImageURL), size: 100)
                                
                                
                            VStack{
                                Text(request.name)
                                    .font(.headline.bold())
                                    .padding()
                             
                            }
                            
                            
                            Spacer()
                            
                            
                        }
                        
                    }
                    .listSectionSeparator(.hidden)
                   
                }
                
                if segmentationSelection == .friends{
                    
                    List(dataModel.friendRequests) { request in
                        Text(request.name)
                    }
                    .listSectionSeparator(.hidden)
                }
                
                if segmentationSelection == .requests{
                    
                    List(dataModel.friendRequests) { request in
                        Text(request.name)
                    }
                    .listSectionSeparator(.hidden)
                }
                
                if segmentationSelection == .custom{
                    
                    List(dataModel.friendRequests) { request in
                        Text(request.name)
                    }
                    .listSectionSeparator(.hidden)
                }
                
                
            }
            
        
            
                        
           
            .padding()
            .searchable(text: $searchText) {
                // If you want to provide suggestions as user types in the search bar, you can add them here.
            }
            
            
            .navigationTitle(Text("Friends"))
        }
    }
}


struct SearchAndFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchAndFriendsView()
            .environmentObject(SearchAndFriendsViewModel(inPreview: true))
            
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

struct ContentView4_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

