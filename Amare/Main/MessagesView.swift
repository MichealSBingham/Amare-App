//
//  MessagesView.swift
//  Amare
//
//  Created by Micheal Bingham on 8/12/21.
//

import SwiftUI

struct MessagesView: View {
    @EnvironmentObject private var account: Account
    
    var body: some View {
        Text("You will see your messages and group chats here.")
            .foregroundColor(.white)
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
            .environmentObject(Account())
            .preferredColorScheme(.dark)
    }
}
