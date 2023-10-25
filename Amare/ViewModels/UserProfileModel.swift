//
//  UserProfileModel.swift
//  Amare
//
//  Created by Micheal Bingham on 7/27/23.
//

import Foundation
import SwiftUI
import Firebase

//TODO: Consider the error handling
class UserProfileModel: ObservableObject{
	
	@Published var user: AppUser?
	
	@Published var natalChart: NatalChart?
	
	@Published var friendshipStatus: UserFriendshipStatus = .unknown
	
	@Published var friendRequests: [IncomingFriendRequest] = []
	
    //TODO:
	///Bool to indicate whether the user winked `at` the current `signed in user` /
	@Published var winkedAtMe: Bool?
	
	/// TODO: make sure this data is updated n the initial LoadUser() function, right now, only changes if the user sends the friend request .. perhaps update the `friendshipStatus` variable here.
	@Published var didSendFriendRequest: Bool?
    
    @Published var oneLiner: String?
	
	//TODO: compatibility score
    @Published var score: Double?
	
	@Published var error: Error?
	
	///Firestore listener for the profile that the user is currently looking at , must detach the listener when it is done
	private var userListener: ListenerRegistration?
	
	
	var friendshipStatusListeners: [ListenerRegistration] = []
	
	private var friendRequestsListener: ListenerRegistration?
	
	
	
	
	func loadUser(userId: String = Auth.auth().currentUser?.uid ?? "" ){
		
		
		self.startListeningForUserDataChanges(userId: userId)
		
		if Auth.auth().currentUser?.uid != userId { self.getFriendshipStatus(with: userId)}
		
		self.getNatalChart(userId: userId)
		
		if Auth.auth().currentUser?.uid == userId { self.listenForAllFriendRequests()}
        
        self.getCompatibilityScore(for: userId)

		
	}
    
        //TODO: get the compatibility score
    func getCompatibilityScore(for userID: String) {
        // get's the compatibility score
        AmareApp().delay(2) {
            self.score = Double.random(in: 0...1)
        }
        
   
    }
    
    func getOneLiner(for userID: String){
        AmareApp().delay(2) {
            self.oneLiner = "Enjoy this while you can because days of length you shall not have..="
        }
        }
	
	//TODO: Reconsider this !
	func unloadUser()  {
		/*
		self.stopListeningForUserDataChanges()
		self.stopListeningForFriendshipStatus()
		self.user = nil
		self.natalChart = nil
		self.winkedAtMe = nil
		 */
	}
	

	func addFriend(currentSignedInUser: AppUser){
		
		guard let userToAddID = self.user?.id else {
			self.error = NSError(domain: "Cannot load data", code: 0, userInfo: nil)
			return
		
		}
		
		guard userToAddID != Auth.auth().currentUser?.uid else { print("can't add yourself as a friend"); return }
		
		
		FirestoreService.shared.sendFriendRequest(from: currentSignedInUser, to: userToAddID) { result in
			switch result {
			case .success(let success):
				DispatchQueue.main.async {
					withAnimation{
						self.didSendFriendRequest = true
					}
					
				}
			case .failure(let failure):
				self.error = NSError(domain: "Something went wrong", code: 0)
				print("Couldn't send friend request with error \(failure)")
			}
		}
	}
	
	func cancelFriendRequest(){
		
		guard let userToAddID = self.user?.id else {
			self.error = NSError(domain: "Cannot load data", code: 0, userInfo: nil)
			return
		
		}
		
		guard userToAddID != Auth.auth().currentUser?.uid else { print("can't add yourself as a friend"); return }
		
		
		FirestoreService.shared.cancelFriendRequest( to: userToAddID) { result in
			switch result {
			case .success(let success):
				DispatchQueue.main.async {
					withAnimation{
						self.didSendFriendRequest = false
					}
					
				}
			case .failure(let failure):
				self.error = NSError(domain: "Something went wrong", code: 0)
				print("Couldn't send friend request with error \(failure)")
			}
		}
	}
    
    func rejectFriendRequest(){
        
        guard let from = self.user?.id else {
            self.error = NSError(domain: "Cannot load data", code: 0, userInfo: nil)
            return
            
        }
        
        guard from != Auth.auth().currentUser?.uid else { print("can't reject yourself as a friend"); return }
        
        FirestoreService.shared.declineFriendRequest(from: from) { result in
            
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    withAnimation{
                        self.didSendFriendRequest = false
                    }
                }
            case .failure(let failure):
                self.error = NSError(domain: "Something went wrong", code: 0)
                print("Couldn't send friend request with error \(failure)")
            }
        }
        
    }
    
    func acceptFriendRequest(){
        guard let from = self.user?.id else {
            self.error = NSError(domain: "Cannot load data", code: 0, userInfo: nil)
            return
            
        }
        
        guard from != Auth.auth().currentUser?.uid else { print("can't accept yourself as a friend"); return }
        
        FirestoreService.shared.acceptFriendRequest(from: from) { result in
            
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    withAnimation{
                        self.didSendFriendRequest = false
                    }
                }
            case .failure(let failure):
                self.error = NSError(domain: "Something went wrong", code: 0)
                print("Couldn't send friend request with error \(failure)")
            }
        }
    }
	
	
	private func getNatalChart(userId: String){
		
		FirestoreService.shared.fetchNatalChart(userId: userId) { result in
			
			switch result {
			case .success(let chart):
				withAnimation{
					print("got the natal chart")
					self.error = nil
					self.natalChart = chart
				}
			case .failure(let failure):
				withAnimation{
					print("can't get chart .\(failure)")

					self.error = failure
				}
			}
		}
		
	}
	
	 func startListeningForUserDataChanges(userId: String = Auth.auth().currentUser?.uid ?? "") {
		guard !userId.isEmpty else { self.error = AccountError.notSignedIn; return }
		   userListener = FirestoreService.shared.listenForUser(userId: userId) { result in
			   switch result {
			   case .success(let user):
				   DispatchQueue.main.async {
					   withAnimation {
						   //self.error = nil
						   self.user = user
					   }
					  
				   }
			   case .failure(let error):
				   print("Error fetching user data: \(error)")
				   withAnimation{
					   self.error = error
				   }
				  
			   }
		   }
	   }
	
	private func stopListeningForUserDataChanges() {
			userListener?.remove() // Call this function when you want to detach the listener
		}
	
	
	/// Checks if the current user is friends with `userId` the loaded user for `UserProfileModel`
	private func getFriendshipStatus(with otherUserID: String) {
		guard let currentUserId = Auth.auth().currentUser?.uid else { self.error = AccountError.notSignedIn; return }
			
		friendshipStatusListeners = FirestoreService.shared.listenForFriendshipStatus(currentUserID: currentUserId, otherUserID: otherUserID) { [weak self] result in
				switch result {
				case .success(let status):
					DispatchQueue.main.async {
						withAnimation{
                            print("after completion friendship status did change... \(status)")
							self?.friendshipStatus = status
						}
						
					}
				case .failure(let error):
					withAnimation{
						self?.error = error
					}
					
					print("Error checking friendship status: \(error)")
				}
			}
		}
	
	
	 private func listenForAllFriendRequests(){
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
		
		func stopListeningForFriendshipStatus() {
			friendshipStatusListeners.forEach { $0.remove() }
			friendshipStatusListeners.removeAll()
		}

	/// Convenience initializer for preview with mock data
	#if DEBUG
	static func previewInstance() -> UserProfileModel {
		let model = UserProfileModel()
		model.simulateLoadingWithMockData()
		return model
	}
	
	
	// Simulate loading and populate user object after 2 seconds
	func simulateLoadingWithMockData() {
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			withAnimation{
				self.user = AppUser.generateMockData()
			}
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
				withAnimation{
					self.winkedAtMe = true //Bool.random()
				}
				
			}
			
		}
		
		
		
	}
	#endif
	
	
	
	
}
