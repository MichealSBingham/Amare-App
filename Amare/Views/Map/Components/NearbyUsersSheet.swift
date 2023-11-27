//
//  NearbyUsersSheet.swift
//  Amare
//
//  Created by Micheal Bingham on 11/27/23.
//

import SwiftUI

struct NearbyUsersSheet: View {
    @EnvironmentObject var mapViewModel: MapViewModel
    @Binding var showUserSheet: Bool
    
    @StateObject var userDataModel: UserProfileModel = UserProfileModel()
    
    @EnvironmentObject var signedInUserDataModel: UserProfileModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    userCountTitle
                    nearbyUsersScrollView
                }
            }
            .padding()
            .padding(.vertical, 10)
            .scrollIndicators(.hidden)
        }
        .background(ClearBackgroundView())
    }
    
    private var userCountTitle: some View {
        HStack {
            Text("\(mapViewModel.nearbyUsers.count) \(mapViewModel.nearbyUsers.count == 1 ? "Person" : "People") Near You")
                .font(.title3.bold())
            Spacer()
        }
    }

    private var nearbyUsersScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(mapViewModel.nearbyUsers) { user in
                    
                    NavigationLink {
                        
                        userView
                            .onAppear(perform: {
                                userDataModel.loadUser(userId: user.id ?? "" )
                            })
                        
                    } label: {
                        
                        CircularProfileImageView(profileImageUrl: user.profileImageUrl, isNotable: false, showShadow: false)
                            .frame(width: 80)
                            .padding()
                            .buttonStyle(.plain)
                    }

                    
                   
                }
            }
            .frame(minHeight: 90)
        }
        .scrollContentBackground(.hidden)
        .background(Color.clear)
    }
    
    
    private var userView: some View {
       UserProfileView2(model: userDataModel, hideCustomNavBar: true)
            .environmentObject(signedInUserDataModel)
            .environmentObject(AuthService.shared)
    }
}

struct ClearBackgroundView: View {
    var body: some View {
        // Custom implementation for a clear background
        Color.clear
    }
}

// CircularProfileImageView should be defined here, or if it's defined elsewhere, ensure it's imported correctly.

#Preview {
    NearbyUsersSheet( showUserSheet: .constant(false))
        .environmentObject(MapViewModel())
}
