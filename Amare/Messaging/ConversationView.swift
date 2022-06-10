//
//  ConversationView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/29/22.
//

import SwiftUI
import FirebaseFirestore
import PushNotifications
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
		//VStack {
			
			
			
		//NavigationView {
			//TitleRowForMessagingView(testMode: test_mode, thread: $messageThread)
				//.ignoresSafeArea()
			VStack{
					
					
				
					
				
						
						ScrollViewReader{ proxy in
							
							ScrollView {
								
								ForEach($conversation.messages, id: \.self){ $message in
									
									MessageBubbleView(message: $message, testMode: test_mode, me: me_for_testing, them: them_for_testing)
								}.onChange(of: conversation.lastMessage) { last in
									
									if let lastMessage = last {
										print("should be scrolling to \(lastMessage.text)")
										
										DispatchQueue.main.async {
											
											withAnimation {
												proxy.scrollTo(lastMessage, anchor: .bottom)
												
											}
										}
								 
							  }
						  }
				
								
							}
							
						
							
													
						
						}
						
						

						
						
					
					
				
					
					
					
					
						
					
				MessageField(thread: messageThread)
					.environmentObject(conversation)
					
			}
			.navigationBarTitle(Text(""))
			.toolbar {
			
				TitleRowForMessagingView(testMode: false, thread: $messageThread)
			}
			.onAppear {
				conversation.loadConversation(from: messageThread)
			}
			
		//}
			
			
		//}
		//		.background(.ultraThinMaterial)
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
	
	@Published var someErrorHappened: Error?
	
	@Published var someErrorHappenedWhenTryingToSendMessage: Error?
	
	@Published private(set) var lastMessage: Message?
	
	private var db = Firestore.firestore()
	
	func loadConversation(from thread: MessageThread)  {
		// loads converastion and publishes each message to the thread
		
		db.collection("messageThreads").document(thread.id!).collection("messages")
			.addSnapshotListener{ snapshot, error in
				
				guard error == nil else { self.someErrorHappened = error; return }
				
				if snapshot?.isEmpty ?? true { self.messages = [] }
				
				
				guard let messagesDocuments = snapshot?.documents else { self.someErrorHappened = error; return }
				
				
				// map to a message object
				
				withAnimation{
					
					self.messages = messagesDocuments.compactMap({ (docSnapshot) -> Message? in
						
						return try? docSnapshot.data(as: Message.self)
						
					}).sorted(by: { $0.sentAt < $1.sentAt})
				}
				
				if let lastMessage = self.messages.last {
					
					self.lastMessage = lastMessage
				}
				
				
			}
		
	}
	
	
	func send(this message: Message, to thread: MessageThread){
		do {
			try? db.collection("messageThreads").document(thread.id!).collection("messages")
				.addDocument(from: message)
			
			
			// Adds the messsage to the thread's most recent message
			
			var updatedThread = thread
			updatedThread.lastMessage = message
			
			try? db.collection("messageThreads").document(thread.id!)
				.setData(from: updatedThread, merge: true) { error in
					guard error == nil else { return }
					self.someErrorHappenedWhenTryingToSendMessage = error
				}
				
			
		} catch (let error) {
			self.someErrorHappenedWhenTryingToSendMessage = error
		}
	}
	
	func loadRandomConveration(between me: AmareUser = AmareUser(), and them: AmareUser = AmareUser())  {
		
		messages = Message.randomTwoWayConservation(with: me, and: them, on: UUID().uuidString).sorted()
	}
	
	
	
	
	
}


