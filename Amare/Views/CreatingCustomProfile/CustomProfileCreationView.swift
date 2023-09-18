//
//  CustomProfileCreationView.swift
//  Amare
//
//  Created by Micheal Bingham on 8/8/23.
//

import SwiftUI
import Firebase

struct CustomProfileCreationView: View {
	
	@StateObject var newProfileViewModel = OnboardingViewModel()
	@Environment(\.dismiss) var dismiss
	
    var body: some View {
		
		TabView(selection: $newProfileViewModel.currentPage) {
			Text("Create a Custom Profile")
				.font(.largeTitle.bold())
				.tag(OnboardingScreen.phoneNumber)
			
			InputNameView(customAccount: true)
				.tag(OnboardingScreen.name)
			
			InputHomeCityView(customAccount: true)
				.tag(OnboardingScreen.hometown)
			
			BirthdayInputView(customAccount: true)
				.tag(OnboardingScreen.birthday)
			
			BirthtimeInputView(customAccount: true)
				.tag(OnboardingScreen.birthtime)
				.onChange(of: newProfileViewModel.currentPage) { page in
					if page == .genderSelection{
						
						newProfileViewModel.createCustomProfile { result in
							switch result {
							case .success(let success):
								print("Suceeded in making a custom profile ")
							case .failure(let failure):
								print("Failed to make a custom profile \(failure)")
							}
						}
						dismiss()
					}
				}
			
			
		}
		.environmentObject(newProfileViewModel)
		.tabViewStyle(.page(indexDisplayMode: .always))
		
        
    }
}

struct CustomProfileCreationView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProfileCreationView()
			//.environmentObject(OnboardingViewModel())
    }
}
