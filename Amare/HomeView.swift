//
//  HomeView.swift
//  Amare
//
//  Created by Micheal Bingham on 7/2/23.
//

import SwiftUI

struct HomeView: View {
	
	@EnvironmentObject var background: BackgroundViewModel
	
	@EnvironmentObject var authService: AuthService
	
	@EnvironmentObject var viewModel: OnboardingViewModel
	
	//@Binding var dismissView: Bool 
	
	
	
    var body: some View {
		
		ZStack{
			
			Group{
				Text("This is what the user will see when they sign in.\nTap to Sign out")
					.foregroundColor(.amare)
					.onTapGesture{
						authService.signOut{_ in
							withAnimation{
								//dismissView = false
								//authService.AUTH_STATUS_CHECKED_ALREADY = false
								viewModel.currentPage = .phoneNumber
							}
							
						}
					}
			}
			
			
		
			
				
			
		}
		.environmentObject(authService)
		.environmentObject(background)
		.environmentObject(viewModel)
		
		
	
		

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
		HomeView()
			.environmentObject(AuthService.shared)
			.environmentObject(BackgroundViewModel())
			.environmentObject(OnboardingViewModel())
    }
}
