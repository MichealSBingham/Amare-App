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
	
	//TODO: - make this an enviromment object earlier in view flow

	@StateObject var threads =  ChatsUIMessageThreadsModel()
	@StateObject var conversation = ConversationDataStore()
	
	@State var showNewMessage = false
	
	@State var searchString = ""
	
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
				.searchable(text: $searchString)
				.navigationTitle(Text("DMs"))
				.toolbar(content: {
					
					Button {
						showNewMessage.toggle()
					} label: {
						
						Image(systemName: "square.and.pencil")
							.foregroundColor(.white)
						
					}

					
				})
			
			
		
				.listStyle(.plain)
			
				
				
				
			//}
		}
		.sheet(isPresented: $showNewMessage) {
			NewMessageView()
				.environmentObject(threads)
		}
    }
}

struct ChatsUIView_Previews: PreviewProvider {
    static var previews: some View {
		var chats = ChatsUIMessageThreadsModel()
		ChatsUIView(threads: chats, test_mode: true)
			//.preferredColorScheme(.dark)
			.onAppear {
			chats.loadRandomThreads()
			}
			
    }
}


/// View data model for viewing message threads / chats
class ChatsUIMessageThreadsModel: ObservableObject{
	
	@Published var messageThreads: [MessageThread] = []
	
	@Published var error: Error?
	
	/// We use this to focus on one thread, useful for the NewMessageView , the selected thread
	@Published var singleThread: MessageThread? 
	

	
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
	///  - Parameter :
	///  	- updateAllThreadsFromHere: By default true, in general this is for updating all of the threads in the published messageThreads, set to false if only you need to update the thread that's in the singleThread variable.. useful for the NewMessage View
	private func listenToSingleMessageThread(id: String, updateAllThreadsFromHere: Bool = true ) {
	
		var listener = db.collection("messageThreads").document(id).addSnapshotListener { snapshot, error  in
			
			guard let document = snapshot else { return }
			
			do {
				
				let thread = try document.data(as: MessageThread.self)
				
				if updateAllThreadsFromHere{
					if let index = self.messageThreads.firstIndex(where: {$0 == thread} ){
						
						self.messageThreads[index] == thread
						
					} else{
						self.messageThreads.append(thread)
					}
				} else {
					
					// Just update the single thread and listen for its changes
					self.singleThread = thread
				}
				
				
				
				
			} catch (let error) {
				print("Some error happened trying to convert to MessageThread \(error) ")
			}
			
			
		}
		
		
		
	}
	
	//TODO: - detach  listener
	func detachSingleMessageThreadListener(id: String)   {
		
	}
	
	func detachThreadsListener(){
		
	}
	
	
	//TODO: Work with group messages
	func findThread(of type: MessageType, withUsers:  [AmareUser], me: AmareUser = AmareUser(id: Auth.auth().currentUser?.uid ?? "")) {
		
		print("Looking for thread of type .. \(type)... with users \(withUsers) ")
		var withUsers = withUsers
		withUsers.append(me)
		// loops through each of the threads to see if they match
		
		
		if let  threadToReturn = messageThreads.first(where: {$0.type == type && $0.members == withUsers}) {
			
			print("Thread found!")
			self.singleThread = threadToReturn
			self.listenToSingleMessageThread(id: threadToReturn.id!)
		} else {
			
			print("no thread found. ")
			// create the thread
			var newThread = MessageThread(id: UUID().uuidString, createdAt: Date(), members: withUsers, lastModified: Date(), type: type, thumbnailURL: nil, name: nil, lastMessage: nil)
			
			self.createThread(thread: newThread) { err in
				guard err == nil else { self.error = err; return }
				
				self.singleThread = newThread
				self.listenToSingleMessageThread(id: newThread.id!, updateAllThreadsFromHere: false )
			}
			
			
			
		}
		
		
		
		
	}
	
	func createThread(thread: MessageThread, completion: @escaping ((_ err: Error?) -> Void) ){
		print("Trying to create thread")
		
		do {
			
			try db.collection("messageThreads").addDocument(from: thread) { error in
				
				print("thread created with error \(error)")
				completion(error)
				
				
			}
		} catch let(error) {
			completion(error)
		}
		
		
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

