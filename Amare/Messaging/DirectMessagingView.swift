//
//  DirectMessagingView.swift
//  Amare
//
//  Created by Micheal Bingham on 10/22/23.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

struct DirectMessageView: View {
    // Assume chatClient is already initialized and connected
    @Injected(\.chatClient) var chatClient

    var body: some View {
    
            ChatChannelView(
                viewFactory: CustomViewFactory(),
                channelController: try! chatClient.channelController(createDirectMessageChannelWith: ["micheal", "elizabeth"], extraData: [:])
            )
      
    }
    
    /*
    func getDirectMessageController() -> ChatChannelController {
        let currentUserId = chatClient.currentUserId!
        let otherUserId = "<Other User ID>"
        
        let channelId = ChannelId(type: .messaging, id: "\(currentUserId)-\(otherUserId)")
        let controller = try! chatClient.channelController(
            createDirectMessageChannelWith: [otherUserId],
            name: nil,
            imageURL: nil,
            options: [],
            id: channelId
        )
        
        return controller
    }
     */
}

#Preview {
    DirectMessageView()
}




