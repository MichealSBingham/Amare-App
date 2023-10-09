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
    
	
	
	
	
	@Published var all: [SearchedUser] =  []
	@Published var friendRequests: [IncomingFriendRequest] =  []
	@Published var friends: [FriendRequest] =  []
	@Published var error: Error?
	

    
 
    
    
    private var friendRequestsListener: ListenerRegistration?
    
    
    init() {
            // Retrieve the current signed-in user's ID from Firebase Authentication
            

        
        if let id = Auth.auth().currentUser?.uid {
            self.error = nil
            listenForAllFriendRequests()
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
    
    
  
	
	
    func rejectFriendRequest(from userID: String?){
        
         
        
        guard let userID = userID, userID != Auth.auth().currentUser?.uid else { print("can't reject yourself as a friend"); return }
        
        FirestoreService.shared.declineFriendRequest(from: userID) { result in
            
            switch result {
            case .success(let success):
                break
            case .failure(let failure):
                self.error = NSError(domain: "Something went wrong", code: 0)
                print("Couldn't send friend request with error \(failure)")
            }
        }
        
    }
    
    func acceptFriendRequest(from userID: String?){
         
        
        guard let userID = userID, userID != Auth.auth().currentUser?.uid else { print("can't accept yourself as a friend"); return }
        
        FirestoreService.shared.acceptFriendRequest(from: userID) { result in
            
            switch result {
            case .success(let success):
                break
            case .failure(let failure):
                self.error = NSError(domain: "Something went wrong", code: 0)
                print("Couldn't send friend request with error \(failure)")
            }
        }
    }
    
     func listenForAllFriendRequests(){
       guard let currentUserId = Auth.auth().currentUser?.uid else { self.error = AccountError.notSignedIn; return }
        
        friendRequestsListener = FirestoreService.shared.listenForAllIncomingRequests(userId: currentUserId, completion: { result in
            
            switch result {
            case .success(let req):
                withAnimation { self.friendRequests = req }
            case .failure(let failure):
                withAnimation { self.friendRequests = [] ; self.error = failure }
            }
        })
       
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
