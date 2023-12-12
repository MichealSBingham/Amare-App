//
//  DirectMessagingView.swift
//  Amare
//
//  Created by Micheal Bingham on 10/22/23.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI
import FirebaseAuth
struct DirectMessageView: View {
    // Assume chatClient is already initialized and connected
    @Injected(\.chatClient) var chatClient
    @EnvironmentObject var viewRouter: ViewRouter

    /// user id to begin the direct message view with
    var with: String = ""
    var ignoreBottomTabBar: Bool = false

    var body: some View {
        
        if let id = Auth.auth().currentUser?.uid, with == "dasha"{
            ChatChannelView(
                viewFactory: CustomViewFactory(),
                channelController: try!  chatClient.channelController(createChannelWithId:   ChannelId(type: .messaging, id: "\(id)-dasha"))
                   
            )
            .onAppear(perform: {
                withAnimation{
                    
                    if !ignoreBottomTabBar{
                        viewRouter.showBottomTabBar = false
                    }
                    
                }
            })
            .onDisappear(perform: {
                withAnimation{
                    if !ignoreBottomTabBar{
                        viewRouter.showBottomTabBar = true
                    }
                  
                }
            })
        
        }
       
        
        else {
            ChatChannelView(
                viewFactory: CustomViewFactory(),
                channelController: try! chatClient.channelController(createDirectMessageChannelWith: [Auth.auth().currentUser?.uid ?? "", with], extraData: [:])
            )
            .onAppear(perform: {
                withAnimation{
                    
                    if !ignoreBottomTabBar{
                        viewRouter.showBottomTabBar = false
                    }
                    
                }
            })
            .onDisappear(perform: {
                withAnimation{
                    if !ignoreBottomTabBar{
                        viewRouter.showBottomTabBar = true
                    }
                  
                }
            })
        
        }
        
            
        
        
            
      
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




