//
//  FriendsListView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/30/23.
//

import SwiftUI

struct FriendsListView: View {
    @EnvironmentObject var you: UserProfileModel
    @StateObject var dataModel: SearchAndFriendsViewModel = SearchAndFriendsViewModel()
    @State private var selectedUser: Bool = false
    @StateObject private var tappedUser = UserProfileModel()
    @State private var searchText = ""

    var filteredFriends: [Friend] {
        if searchText.isEmpty {
            return dataModel.friends
        } else {
            return dataModel.friends.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        VStack {
            // Search bar
            TextField("Search Friends", text: $searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onAppear {
                    // This is needed to prevent the navigation bar from hiding the search bar when the list is scrolled
                    UITableView.appearance().contentInset.top = -35
                }
                .background(
                            NavigationLink(destination: UserProfileView2(model: tappedUser),
                                           isActive: $selectedUser) { EmptyView() }
                        )

            // List of friends
            List(filteredFriends) { friend in
                Button {
                    tappedUser.loadUser(userId: friend.id ?? "")
                    selectedUser = true
                } label: {
                    UserListRowView(imageUrl: friend.profileImageURL, text: friend.name, isNotable: friend.isNotable)
                }
                .buttonStyle(.plain)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
        .navigationBarTitle("@\(you.user?.username ?? "" )")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                BackButton()
                    .padding()
                
            }
        }
    }
}


#Preview {
    NavigationView{
        FriendsListView()
            .environmentObject(UserProfileModel())
    }
    
}
