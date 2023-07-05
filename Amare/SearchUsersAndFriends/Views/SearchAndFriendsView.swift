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

class SearchAndFriendsViewModel: ObservableObject {
    
    
    
    @Published var friendRequests: [FriendRequest] =  []
    @Published var error: Error?
    
    
    // Whether we are displaying this data in preview or not
    var inPreview: Bool = false
    
    
    private var friendRequestsListener: ListenerRegistration?
    
    
    init(inPreview: Bool = false) {
            // Retrieve the current signed-in user's ID from Firebase Authentication
            
        if let id = Auth.auth().currentUser?.uid {
            self.error = nil
            fetchFriendRequests(for: id, inPreview: inPreview)
        } else {
            self.error = AccountError.notSignedIn
        }
       
        
        }
    
    
    deinit {
            friendRequestsListener?.remove()
        }
    
    
    func fetchFriendRequests(for userId: String, inPreview: Bool = false) {
         FirestoreService.shared.getAllFriendRequests(for: userId, inPreview: inPreview) {  result in
                switch result {
                case .success(let friendRequests):
                    self.error = nil
                    DispatchQueue.main.async {
                        self.friendRequests = friendRequests
                    }
                case .failure(let error):
                    self.error = error
                    print("Failed to fetch friend requests: \(error)")
                }
            }
        }
    
    
    
    
   
    
  /*  func searchUsers(matching prefix: String) {
        FirestoreService.shared.searchUsers(matching: prefix) { result in
            switch result {
            case .success(let (users, notables)):
                self.error = nil
                DispatchQueue.main.async {
                                withAnimation {
                                    self.users = users
                                    self.notables = notables
                                }
                            }
            case .failure(let error):
                print("Failed to search users: \(error.localizedDescription)")
                self.error = error
                DispatchQueue.main.async {
                                withAnimation {
                                    self.users = []
                                    self.notables = []
                                }
                            }
            }
        }
    } */
}

/// View that displays `FriendRequest`s, `Friend`s, `Suggestions`
struct SearchAndFriendsView: View {
    @State private var searchText = ""
    @StateObject var dataModel = SearchAndFriendsViewModel(inPreview: true)
    
    
    var req = FriendRequest.randomList(count: 59)
    var body: some View {
        
        NavigationView{
            
            
            
            ScrollView{
                
                ForEach(dataModel.friendRequests) { request in
                    /*@START_MENU_TOKEN@*/Text(request.name)/*@END_MENU_TOKEN@*/
                }
            }
                        
            /*
            List {
                
                Section("Friend Requests", content: {
                    ForEach(req, id: \.id) { user in
                        Text("\(user.name)")
                    }
                })
                
                /*
                Section("Usernames", content: {
                    ForEach(searchViewModel.users, id: \.documentID) { user in
                        Text(user.get("username") as? String ?? "")
                    }
                })
                Section("Notables", content: {
                    ForEach(searchViewModel.notables, id: \.documentID) { notable in
                        Text(notable.get("username") as? String ?? "")
                    }
                })
                
                */
            }
             */
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
