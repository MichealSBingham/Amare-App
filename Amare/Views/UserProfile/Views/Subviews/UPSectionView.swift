//
//  UserProfileSectionView.swift
//  Amare
//
//  Created by Micheal Bingham on 10/20/23.
//

import SwiftUI

struct UPSectionView: View {
    
    var profileImageURL: String?
    var isNotable: Bool?
    var winked: Bool?
    
    var name: String?
    var username: String?
    
    var friendshipStatus: UserFriendshipStatus = .unknown
    
    var compatibility_score: Double?
    
    var body: some View {
        VStack{
            CircularProfileImageView(profileImageUrl: profileImageURL, isNotable: isNotable, winked: winked)
                .frame(width: 100, height: 100)
               // .padding()
            
       
            ZStack{
                
                NameLabelView(name: name, username: username)
                  //  .padding()
                
                HStack{
                    Spacer()
                    FriendshipStatusView(friendshipStatus: friendshipStatus)
                        .frame(width: 35)
                        .padding()
                }
            }
                
            NatalChartTabView()
            
            RadialChart(progress: compatibility_score)
            
           
        }
    }
}

#Preview {
    UPSectionView(profileImageURL: AppUser.generateMockData().profileImageUrl, isNotable: true, winked: true, name: AppUser.generateMockData().name, username: AppUser.generateMockData().username, compatibility_score: 0.4)
}
