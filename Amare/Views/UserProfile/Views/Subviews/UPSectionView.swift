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
    var winkStatus: IncomingWink?
    
    var name: String?
    var username: String?
    
    var friendshipStatus: UserFriendshipStatus = .unknown
    
    var oneLinerSummary: String?
    
    var compatibility_score: Double?
    
    var natalChart: NatalChart?
    
    var cancelFriendRequestAction: (() -> Void)? = nil
    var addFriendAction: (() -> Void)? = nil
    var acceptFriendAction: (() -> Void)? = nil
    
    
    
    fileprivate func friendshipStatusButton() -> some View {
        Button{
            
        print("did tap friendship status")
            if friendshipStatus == .requested{
                cancelFriendRequestAction?()
            }
            
            if friendshipStatus == .notFriends {
                addFriendAction?()
                
            }
            
            if friendshipStatus == .awaiting{
                acceptFriendAction?()
         
            }
            
            
        }
    label: {
        
        
        FriendshipStatusView(friendshipStatus: friendshipStatus)
            .frame(width: 35)
            .transition(.scale)
    }
    .disabled( friendshipStatus == .friends)
    }
    
    
    var body: some View {
        VStack{
            CircularProfileImageView(profileImageUrl: profileImageURL, isNotable: isNotable, winked: winkStatus != nil)
                .frame(width: 100, height: 100)
               // .padding()
            
       
            ZStack{
                
                NameLabelView(name: name, username: username)
                  //  .padding()
                
                HStack{
                    Spacer()
                    friendshipStatusButton()
                        .frame(width: 35)
                        .padding()
                }
            }
            
            /*
            Text(oneLinerSummary ?? "" )
                .multilineTextAlignment(.center)
               // .frame(height: 38)
                .font(.caption)
                .padding(.horizontal)
              //  .border(.white)
            */
            
            NatalChartTabView(natalChart: natalChart)
                .frame(height: 45)
                .padding()
                
               // .border(.white)
            
            
            RadialChart(progress: compatibility_score)
                .padding()
            
           
        }
    }
}

#Preview {
    UPSectionView(profileImageURL: AppUser.generateMockData().profileImageUrl, isNotable: true, winkStatus: nil, name: AppUser.generateMockData().name, username: AppUser.generateMockData().username, oneLinerSummary: "Enjoy this while it lasts because days of length you shall not have.", compatibility_score: 0.80)
}
