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
    @Published var historical: [SearchedUser] =  []
	@Published var friendRequests: [IncomingFriendRequest] =  []
	@Published var friends: [Friend] =  []
    @Published var customProfiles: [AppUser] = []
	@Published var error: Error?
	

    
 
    
    
    private var friendRequestsListener: ListenerRegistration?
    private var friendsListener: ListenerRegistration?
    private var customProfilesListener: ListenerRegistration?
    
    
    init() {
            // Retrieve the current signed-in user's ID from Firebase Authentication
            

        
        if let id = Auth.auth().currentUser?.uid {
            self.error = nil
            listenForAllFriendRequests()
            listenForAllFriends()
            listenForAllCustomProfiles()
        } else {
            self.error = AccountError.notSignedIn
        }
       
        
        }
    
    
    deinit {
            friendRequestsListener?.remove()
            friendsListener?.remove()
            customProfilesListener?.remove()
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
    
    func listenForAllFriends(){
        guard let currentUserID = Auth.auth().currentUser?.uid else { self.error = AccountError.notSignedIn; return }
        
        friendsListener = FirestoreService.shared.listenForAllFriends(for: currentUserID, completion: { result in
            switch result {
            case .success(let success):
                withAnimation{
                    self.friends = success 
                }
            case .failure(let failure):
                self.error = failure
            }
        })
    }
    
    func listenForAllCustomProfiles(){
        guard let currentUserID = Auth.auth().currentUser?.uid else { self.error = AccountError.notSignedIn; return }
        
        customProfilesListener = FirestoreService.shared.listenForAllCustomProfiles(for: currentUserID, completion: { result in
            switch result {
            case .success(let success):
                withAnimation{
                    self.customProfiles = success
                }
            case .failure(let failure):
                self.error = failure
            }
        })
    }
    
   
    
    func searchRegularUsers(matching prefix: String) {
        guard !prefix.isEmpty else { self.all = []; return }
        FirestoreService.shared.searchRegularUsers(matching: prefix) { result in
            switch result {
            case .success(let (users)):
                self.error = nil
                DispatchQueue.main.async {
                                withAnimation {
                                    self.all = users
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
    
    func searchHistoricalUsers(matching prefix: String) {
        guard !prefix.isEmpty else { self.all = []; return }
        FirestoreService.shared.searchNotableUsersNotOnHere(matching: prefix) { result in
            switch result {
            case .success(let ( notables)):
                self.error = nil
                DispatchQueue.main.async {
                                withAnimation {
                                    self.historical =   notables
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
