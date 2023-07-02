//
//  ContentView.swift
//  Amare
//
//  Created by Micheal Bingham on 7/1/23.
//

import SwiftUI

/*
struct ContentView: View {
	
	@EnvironmentObject var authService: AuthService // Get the environment object
	@ObservedObject var bgViewModel = BackgroundViewModel()
	
	@ObservedObject var onboardModel = OnboardingViewModel()
	
	
	@State private var userCompletedOnboarding: Bool = false
	
	
	@State var showLoading: Bool = true
	
	@State var showHomeScreen: Bool = false
	@State var showSignInScreen: Bool = false
	@State var showOnboardingScreen: Bool = false
	
	var body: some View {
		
		// if keyboard does not need to be up (homeView) or sign in View
		
		if showLoading {
			Text("Loading Screen Will Go Here")
				.onAppear{
					if authService.user == nil {
						withAnimation {
							showLoading = false
							showHomeScreen = false
							showOnboardingScreen = false
							showSignInScreen  = true
						}
					}
				}
				.onChange(of: authService.user) { user in
					
					if let _ = user {
						// User IS signed in
						// called whenever the user signs in or the auth status changes to signed in
						
						// We need to check if the user completed onboarding or not
						if userCompletedOnboarding{
							
							withAnimation{
								showLoading = false
								showOnboardingScreen = false
								showSignInScreen = false
								showHomeScreen = true
							}
							
							
							
							
						} else{
							
							withAnimation{
								bgViewModel.isSolidColor = true
								bgViewModel.solidColor = .black
								onboardModel.currentPage = .name
								showLoading = false
								showHomeScreen = false
								showSignInScreen = false
								showOnboardingScreen = true
							}
							
						}
						
						
					} else{
						// The user is not signed in... so show signIn/SignUp view
						// Whenever the user is nil --> this will run
						withAnimation {
							showLoading = false 
							showHomeScreen = false
							showOnboardingScreen = false
							showSignInScreen  = true
						}
						
					}
				}
		}
		
		
		if showSignInScreen{
			ZStack{
				
				Group{
					
				
						Background()
						SignInOrUpView( beginOnboardingFlow: $showOnboardingScreen)
						.onChange(of: showOnboardingScreen) { showOnboardingScreen in
							if showOnboardingScreen == true {
								withAnimation {
									showHomeScreen = false
									showSignInScreen = false
								}
							}
						}
					
					
						
				}
				.environmentObject(bgViewModel)
				.opacity(showSignInScreen ? 1: 0)
				
			}
			
			
		}
		
		if showHomeScreen{
			
			Text("This is the home screen")
				.foregroundColor(.amare)
				.onTapGesture {
					authService.signOut()
				}
				.opacity(showHomeScreen ? 1: 0 )
		}
		
		if showOnboardingScreen{
			ZStack{
				
		
				
			
				
				Group{
					Background()
						.environmentObject(bgViewModel)
					OnboardingSignUpView()
						.preferredColorScheme(.dark)
						.environmentObject(onboardModel)
						.environmentObject(bgViewModel)
						.opacity(showOnboardingScreen ? 1 : 0 )
				}
					
				
				
				
				
				
			}
			.environmentObject(authService)
			
		}
		
		
	}
	
	
}
*/




struct ContentView: View {
	
	@ObservedObject var bgViewModel = BackgroundViewModel()

	@EnvironmentObject var authService: AuthService // Get the environment object

	@State var userIsSignedIn: Bool = false
	
	
	@State var userCompletedOnBoarding: Bool = false
	
	var body: some View {
		ZStack{
			
			Text("This is the homescreen of a signed in user")
				.foregroundColor(.amare)
				.onTapGesture {
					
					authService.signOut()
				}
				.opacity(userIsSignedIn && userCompletedOnBoarding  ? 1: 0)
			
			
			Group{
				
				Background()
					.environmentObject(bgViewModel)
				SignInOrUpView(beginOnboardingFlow: .constant(false))
					.environmentObject(bgViewModel)
					
			}
			.opacity(!userIsSignedIn ? 1: 0)
				
				
			
		}
		.onChange(of: authService.user) { user in
					withAnimation {
						userIsSignedIn = user != nil
					}
				}
		.environmentObject(authService)
	}
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
			.environmentObject(AuthService.shared)
    }
}
