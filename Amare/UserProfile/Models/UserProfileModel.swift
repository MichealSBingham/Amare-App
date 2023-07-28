//
//  UserProfileModel.swift
//  Amare
//
//  Created by Micheal Bingham on 7/27/23.
//

import Foundation
import SwiftUI
import Firebase

class UserProfileModel: ObservableObject{
	
	@Published var user: AppUser?
	
	@Published var natalChart: NatalChart?
	
	///Bool to indicate whether the user winked `at` the current `signed in user`
	@Published var winkedAtMe: Bool?
	
	///Firestore listener for the profile that the user is currently looking at , must detach the listener when it is done
	private var userListener: ListenerRegistration?
	
	
	func startListeningForUserDataChanges(userId: String) {
		   userListener = FirestoreService.shared.listenForUserDataChanges(userId: userId) { result in
			   switch result {
			   case .success(let user):
				   DispatchQueue.main.async {
					   withAnimation {
						   self.user = user
					   }
					  
				   }
			   case .failure(let error):
				   print("Error fetching user data: \(error)")
			   }
		   }
	   }
	
	func stopListeningForUserDataChanges() {
			userListener?.remove() // Call this function when you want to detach the listener
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
