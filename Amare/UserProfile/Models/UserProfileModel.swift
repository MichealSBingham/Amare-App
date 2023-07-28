//
//  UserProfileModel.swift
//  Amare
//
//  Created by Micheal Bingham on 7/27/23.
//

import Foundation
import SwiftUI

class UserProfileModel: ObservableObject{
	
	@Published var user: AppUser?
	
	@Published var natalChart: NatalChart?
	
	///Bool to indicate whether the user winked `at` the current `signed in user`
	@Published var winkedAtMe: Bool?
	
	
	

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
