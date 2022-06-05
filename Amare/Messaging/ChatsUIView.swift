//
//  ChatsUIView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/29/22.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth
import MapKit

var testUser = AmareUser(id: "23", name: "Jane Smith", profile_image_url: mockProfileImageURL)

/// View for the message threads
struct ChatsUIView: View {
	
	@StateObject var threads =  ChatsUIMessageThreadsModel()
	@StateObject var conversation = ConversationDataStore()
	
	var test_mode: Bool = false
	
    var body: some View {
		
		NavigationView{
			
					
				
				List($threads.messageThreads){ $message in
					
					NavigationLink {
						
						ConversationView(conversation: conversation,messageThread: $message, me_for_testing: message.members.first!, them_for_testing: message.members.last!, test_mode: true)
					
							//.preferredColorScheme(.dark)
							.onAppear {
								//withAnimation {
								conversation.loadRandomConveration(between: message.members.first!, and: message.members.last!)
								//}
								
							}

					} label: {
						
						MessageThreadView(thread: $message, me_for_testing: message.members.first!, them_for_testing: message.members.last!, test_mode: test_mode)
							
					}

			
					
					
					
					
				}
				.navigationTitle(Text("DMs"))
				.toolbar(content: {
					
					Button {
						
					} label: {
						
						Image("square.and.pencil")
					}

					
				})
			
			
		
				.listStyle(.plain)
			
				
				
				
			//}
		}
		.onAppear {
			
		}
    }
}

struct ChatsUIView_Previews: PreviewProvider {
    static var previews: some View {
		var chats = ChatsUIMessageThreadsModel()
		ChatsUIView(threads: chats, test_mode: true)
			//.preferredColorScheme(.dark)
			.onAppear {
				//chats.loadRandomThreads()
			}
			
    }
}


/// View data model for viewing message threads / chats
class ChatsUIMessageThreadsModel: ObservableObject{
	
	@Published var messageThreads: [MessageThread] = []
	
	@Published var error: Error?
	

	
	private var db = Firestore.firestore()
	
	init(){
		self.listenForMessageThreads()
	}
	
	
	/// Listens for all of the message threads
	func listenForMessageThreads()  {
		
		if let signedInUserID = Auth.auth().currentUser?.uid{
			
			db.collection("users").document(signedInUserID).collection("threadIDs").addSnapshotListener { snapshot, error in
				
				guard let messageThreadDocuments = snapshot?.documents else { self.error = error; return }
				
				//TODO: just return them sorted in the query
				for thread in messageThreadDocuments {
					
					self.listenToSingleMessageThread(id: thread.documentID)
				
				}
				
			}
			
		} else{
			// Not signed in
			self.error = AccountError.notSignedIn
		}
		
		
	}
	
	/// Listens for updates to a single message thread i.e. its name, thumbnail, recent message etc
	private func listenToSingleMessageThread(id: String) {
	
		var listener = db.collection("messageThreads").document(id).addSnapshotListener { snapshot, error  in
			
			guard let document = snapshot else { return }
			
			do {
				
				let thread = try document.data(as: MessageThread.self)
				
				if let index = self.messageThreads.firstIndex(where: {$0 == thread} ){
					
					self.messageThreads[index] == thread
					
				} else{
					self.messageThreads.append(thread)
				}
				
				
				
			} catch (let error) {
				print("Some error happened trying to convert to MessageThread \(error) ")
			}
			
			
		}
		
		
		
	}
	
	//TODO: - detach  listener
	func detachSingleMessageThreadListener(id: String)   {
		
	}
	
	func loadRandomThreads() {
		
		var messages: [MessageThread] = []
		
		
		for i in 0...20{
			var randThread = MessageThread.randomThread()
			messages.append(randThread)
		}
		messages.sort()

		messageThreads = messages.reversed()
		
	}
	
}

