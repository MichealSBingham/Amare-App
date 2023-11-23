//
//  HomeView.swift
//  Amare
//
//  Created by Micheal Bingham on 7/2/23.
//

import SwiftUI
import StreamChatSwiftUI

struct HomeView: View {
	
	@EnvironmentObject var background: BackgroundViewModel
	
	@EnvironmentObject var authService: AuthService
	
	@EnvironmentObject var viewModel: OnboardingViewModel
	
	@EnvironmentObject var currentUserDataModel: UserProfileModel
    
    @EnvironmentObject var viewRouter: ViewRouter
    
   
	
    
    @State var tabSelection: Int = 3
	
	
    
    
    
   
    

	
	
    var body: some View {
		
       EmptyView()
        
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
            .environmentObject(UserProfileModel())
            .environmentObject(ViewRouter())
    }
}
