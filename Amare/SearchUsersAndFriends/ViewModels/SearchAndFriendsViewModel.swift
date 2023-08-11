//
//  SearchAndFriendsViewModel.swift
//  Amare
//
//  Created by Micheal Bingham on 7/13/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class SearchAndFriendsViewModel: ObservableObject {
    
	#if DEBUG
    
    @Published var all: [SearchedUser] =  []
	@Published var friendRequests: [FriendRequest] = (0..<50).map { _ in FriendRequest.random() }// []
	@Published var friends: [FriendRequest] =  (0..<50).map { _ in FriendRequest.random() }
    @Published var error: Error?
	
	#else
	
	@Published var all: [SearchedUser] =  []
	@Published var friendRequests: [FriendRequest] =  []
	@Published var friends: [FriendRequest] =  []
	@Published var error: Error?
	
	#endif
    
 
    
    
    private var friendRequestsListener: ListenerRegistration?
    
    
    init() {
            // Retrieve the current signed-in user's ID from Firebase Authentication
            

        
        if let id = Auth.auth().currentUser?.uid {
            self.error = nil
            fetchFriendRequests(for: id)
        } else {
            self.error = AccountError.notSignedIn
        }
       
        
        }
    
    
    deinit {
            friendRequestsListener?.remove()
        }
	
	
	
	/*
	#if DEBUG
	/// doesn't work
	static func previewInstance() -> SearchAndFriendsViewModel{
		let model = SearchAndFriendsViewModel()
		model.friends = (0..<20).map { _ in FriendRequest.random() }
		//model.simulateLoadingData()
		return model
		
	}
	
	func simulateLoadingData()  {
		
			withAnimation {
				self.friendRequests =  (0..<20).map { _ in FriendRequest.random() }
				self.friends = [FriendRequest.random()]
			}
		
	}
	#endif
	*/
    
    
    func fetchFriendRequests(for userId: String) {
         FirestoreService.shared.getAllFriendRequests(for: userId) {  result in
                switch result {
                case .success(let friendRequests):
                    self.error = nil
                    DispatchQueue.main.async {
                        self.friendRequests = friendRequests
                    }
                case .failure(let error):
                    self.error = error
                    print("Failed to fetch friend requests: \(error)")
                }
            }
		
        }
	
	
	func declineFriendRequest(for userId: String){
		
	}
	
	func acceptFriendRequest(for userId: String){
		
	}
    
    
    
    
   
    
    func searchUsers(matching prefix: String) {
        guard !prefix.isEmpty else { self.all = []; return }
        FirestoreService.shared.searchUsers(matching: prefix) { result in
            switch result {
            case .success(let (users, notables)):
                self.error = nil
                DispatchQueue.main.async {
                                withAnimation {
                                    self.all = users + notables
                                }
                            }
            case .failure(let error):
                print("Failed to search users: \(error.localizedDescription)")
                self.error = error
                DispatchQueue.main.async {
                                withAnimation {
                                    self.all = []
                                }
                            }
            }
        }
    }
     
}
