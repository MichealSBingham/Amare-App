//
//  FriendshipStatusView.swift
//  Amare
//
//  Created by Micheal Bingham on 10/20/23.
//

import SwiftUI

struct FriendshipStatusView: View {
    var friendshipStatus: UserFriendshipStatus = .unknown
    
    var body: some View {
        Image(systemName: friendshipStatus.imageName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .foregroundColor(Color.green)
        .frame(width: 35, height: 35) // did not have this at first
        .transition(.scale)
    }
}

#Preview {
    FriendshipStatusView()
        .frame(width: 50)

}
