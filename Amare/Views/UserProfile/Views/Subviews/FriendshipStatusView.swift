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
        .transition(.scale)
    }
}

#Preview {
    FriendshipStatusView()
        .frame(width: 50)

}
