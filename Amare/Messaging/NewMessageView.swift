//
//  NewMessageView.swift
//  Amare
//
//  Created by Micheal Bingham on 6/4/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct NewMessageView: View {
	
	@EnvironmentObject var allThreadsData: ChatsUIMessageThreadsModel
	
	@StateObject var usersSearchData = NewMessageViewModel()
	
	@State var searchString = ""
	
	@State var goToMessageThreadView = false
	
	func search() {  usersSearchData.search(for: searchString)}
	
	func cancel() {}
	
    var body: some View {
        
		NavigationView {
			VStack {
				
					List {
						
						ForEach(usersSearchData.searchedUsers, id: \.self){ user in
							
							Button {
								// see if a thread between user exists
								// if not, create one otherwise go to it
								//TODO: work for group messages\
								
								allThreadsData.findThread(of: .twoWay, withUsers: [user])
								
								
								
							} label: {
								
								Text(user.username ?? "")
							}
							.onChange(of: allThreadsData.singleThread) { newValue in
								if newValue != nil {
									
									// make sure the thread exists
									goToMessageThreadView = true
								}
							}

						}
					}
					.searchable(text: $searchString)
						
				NavigationLink(isActive: $goToMessageThreadView) {
					
					ConversationView(messageThread: Binding($allThreadsData.singleThread) ?? .constant(MessageThread.randomThread()))
					
				} label: {
					EmptyView()
				}

				
			}.navigationTitle(Text("Who do you want to message?"))
			.onChange(of: searchString) { words in
				
				guard !words.isEmpty else { usersSearchData.searchedUsers = []; return }
				usersSearchData.search(for: words)
		}
			
		}
    }
}

struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        NewMessageView()
    }
}


class NewMessageViewModel: ObservableObject {
	
	/// Users returend by the search query
	@Published var users: [AmareUser] = []
	
	private var db = Firestore.firestore()
	
	@Published var searchedUsers : [AmareUser] = []
	
	@Published var searchError: Error?
	
	func search(for username: String)  {
		
		db.collection("usernames")
			.whereField("username", isGreaterThanOrEqualTo: username)
			.addSnapshotListener { snapshot, error in
				
				guard error == nil else {
					self.searchError = error!
					return
				}
				
			   
				var users: [AmareUser] = []
				for document in snapshot!.documents{
			 
					let result = Result {
						try document.data(as: AmareUser.self)
					}
					
					switch result {
					
					
					case .success(var user):
						
						if  user != nil{
							user.id = document.data()["userId"] as? String
							
							
							if user.id != Auth.auth().currentUser?.uid {
								users.append(user)
							}
							
							self.searchedUsers = users

							
							
						} else{
							
							// Could not retreive the data for some reason
							self.searchError = GlobalError.unknown
							return
						}
						
					
					case .failure(let error):
						// Handle errors
						self.searchError = error
						continue
					  //  return
				  
					}

					
				}
			 
				
				
				
			}
	}
}
