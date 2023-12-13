//
//  CustomChannelListView.swift
//  Amare
//
//  Created by Micheal Bingham on 12/9/23.
//
/*
import SwiftUI
import StreamChat
import StreamChatSwiftUI

struct CustomChannelListView: View {
    
    @StateObject private var viewModel: ChatChannelListViewModel
    @StateObject private var channelHeaderLoader = ChannelHeaderLoader()
    
    public init(
        channelListController: ChatChannelListController? = nil
    ) {
        let channelListVM = ViewModelsFactory.makeChannelListViewModel(
            channelListController: channelListController,
            selectedChannelId: nil
        )
        _viewModel = StateObject(
            wrappedValue: channelListVM
        )
    }
    
    var body: some View {
        NavigationView {
            ChannelList(
                factory: DefaultViewFactory.shared,
                channels: viewModel.channels,
                selectedChannel: $viewModel.selectedChannel,
                swipedChannelId: $viewModel.swipedChannelId,
                onItemTap: { channel in
                    viewModel.selectedChannel = channel.channelSelectionInfo
                },
                onItemAppear: { index in
                    viewModel.checkForChannels(index: index)
                },
                channelDestination: DefaultViewFactory.shared.makeChannelDestination()
            )
            .toolbar {
                DefaultChatChannelListHeader(title: "Stream Tutorial")
            }
        }
    }
}

#Preview {
    CustomChannelListView()
}
*/
