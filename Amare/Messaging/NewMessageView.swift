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
	
	@StateObject var usersSearchData = NewMessageViewModel()
	
	@State var searchString = ""
	
	func search() {  usersSearchData.search(for: searchString)}
	
	func cancel() {}
	
    var body: some View {
        
		VStack {
			SearchNavigation(text: $searchString, search: search, cancel: cancel) {
				List {
					
					ForEach(usersSearchData.searchedUsers, id: \.self){ user in
						
						Button {
							// see if a thread between user exists
							// if not, create one otherwise go to it
							//TODO: assumg it doesn't exit for simplicity rn
							
						
							
							
						} label: {
							
							Text(user.name!)
						}

					}
				}.navigationTitle(Text("Who do you want to message?"))
			}
		}
		.onChange(of: searchString) { words in
			usersSearchData.search(for: words)
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
