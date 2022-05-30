//
//  ConversationView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/29/22.
//

import SwiftUI

struct ConversationView: View {
	
	@StateObject var conversation = ConversationDataStore()
	@Binding var messageThread: MessageThread
	//@Binding var messages: [Message]
	
	//MARK: - Only for testing in preview
 /// Helps preview understand if this is a sent or received messsage, should be nil in production
	var me_for_testing: AmareUser? = nil
	/// Helps preview understand if this is a sent or received messsage, should be nil in production
	var them_for_testing: AmareUser? = nil
	var test_mode: Bool = false
	
	
    var body: some View {
		ZStack{
			
				
			
			ScrollView{
				
				ForEach($conversation.messages){ $message in
					
					MessageBubbleView(message: $message, testMode: test_mode, me: me_for_testing, them: them_for_testing)
				}
			}
			
			VStack{
				TitleRowForMessagingView(thread: $messageThread)
					.ignoresSafeArea()
				Spacer()
			}
			
			
		}
		//.background(.ultraThinMaterial)
		//.foregroundColor(Color.primary.opacity(0.35))
		//.foregroundStyle(.ultraThinMaterial)
    }
}

struct ConversationView_Previews: PreviewProvider {
	
	
    static var previews: some View {
		
		let me = AmareUser.random()
		let them = AmareUser.random()
		
		let  conversation = ConversationDataStore()
		
		ConversationView(conversation: conversation, messageThread: .constant(MessageThread.randomThread(with: me, and: them)), me_for_testing: me, them_for_testing: them, test_mode: true)
			.preferredColorScheme(.dark)
			.onAppear {
				conversation.loadRandomConveration(between: me, and: them)
			}
		//EmptyView()
    }
}

class ConversationDataStore: ObservableObject{
	
	@Published var messages: [Message] = []
	
	func loadRandomConveration(between me: AmareUser = AmareUser(), and them: AmareUser = AmareUser())  {
		
		messages = Message.randomTwoWayConservation(with: me, and: them)
	}
	
	
}
