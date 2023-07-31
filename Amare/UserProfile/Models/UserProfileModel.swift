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
	
	@Published var error: Error?
	
	///Firestore listener for the profile that the user is currently looking at , must detach the listener when it is done
	private var userListener: ListenerRegistration?
	
	
	
	
	func loadUser(userId: String){
		
		
		self.startListeningForUserDataChanges(userId: userId)
		self.getNatalChart(userId: userId)
	}
	
	//TODO: Reconsider this !
	func unloadUser()  {
		/*
		self.stopListeningForUserDataChanges()
		self.user = nil
		self.natalChart = nil
		self.winkedAtMe = nil
		 */
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
	
	private func startListeningForUserDataChanges(userId: String) {
		   userListener = FirestoreService.shared.listenForUser(userId: userId) { result in
			   switch result {
			   case .success(let user):
				   DispatchQueue.main.async {
					   withAnimation {
						   self.error = nil
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
