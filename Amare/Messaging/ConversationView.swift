//
//  ConversationView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/29/22.
//

import SwiftUI

struct ConversationView: View {
	
	@Binding var messageThread: MessageThread
	@Binding var messages: [Message]
	
	
    var body: some View {
		VStack{
			TitleRowForMessagingView(user: .constant(testUser))
		}
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        //ConversationView()
		EmptyView()
    }
}

class ConversationDataStore: ObservableObject{
	
}
