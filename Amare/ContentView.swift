//
//  ContentView.swift
//  Amare
//
//  Created by Micheal Bingham on 7/1/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ContentView: View {
	@EnvironmentObject var authService: AuthService
	
	@StateObject var bgModel = BackgroundViewModel()
	
	@StateObject var onboardingModel: OnboardingViewModel = OnboardingViewModel()

	// Flag to limit unnecessary updates
	@State var initialCheckDone: Bool = false

	var body: some View {
		ZStack {
			if authService.user != nil {
				if authService.isOnboardingComplete {
					HomeView()
						.transition(.opacity)
				} else {
					OnboardingSignUpView()
                        .onAppear{
                            withAnimation{
                                onboardingModel.currentPage = .name
                            }
                            
                        }
						.transition(.opacity)
				}
			} else {
				SignInOrUpView()
					.transition(.opacity)
                    .onAppear{
                        withAnimation{
                            bgModel.isSolidColor = false
                        }
                       
                        initialCheckDone = false
                    }
                
			}
		}
		.environmentObject(bgModel)
		.environmentObject(authService)
		.environmentObject(onboardingModel)
		.animation(.default, value: authService.user)
		.animation(.default, value: authService.isOnboardingComplete)
		.onAppear {
			if !initialCheckDone {
				// Here, you might check the auth state and only update authService.user
				// and authService.isOnboardingComplete if the check has not been done before
				initialCheckDone = true
			}
		}
	}
}



struct ContentView2: View {
	
	@ObservedObject var bgModel = BackgroundViewModel()
	@EnvironmentObject var authService: AuthService
	@ObservedObject var onboardingModel: OnboardingViewModel = OnboardingViewModel()
	
	
	
	
	@State var userIsSignedIn: Bool = false
	@State var onboardingComplete: Bool = false
	
	@State var userSignedOut: Bool = false
	
	var body: some View {
		ZStack {
			if userIsSignedIn && onboardingComplete {
				AnyView(HomeView( )
					.transition(.move(edge: .leading)))
			} else if userIsSignedIn {
				AnyView(ZStack {
					Background()
					OnboardingSignUpView()
				}.onAppear {
					withAnimation{
						bgModel.solidColor = .black
						bgModel.isSolidColor = true
						onboardingModel.currentPage = .name
					}
				}.transition(.move(edge: .leading)))
			} else {
				AnyView(ZStack {
					Background()
					SignInOrUpView()
				}.transition(.move(edge: .leading)))
			}
		}
		.environmentObject(bgModel)
		.environmentObject(authService)
		.environmentObject(onboardingModel)
		.onAppear {
			Auth.auth().addStateDidChangeListener { auth, user in
				print("auth: \(auth) user: \(user)")
				if let _ = user {
					// User is signed in
					guard !authService.AUTH_STATUS_CHECKED_ALREADY else { return }
					withAnimation{
						userIsSignedIn = true
						onboardingComplete = false // Bool.random()
					}
				} else {
					// User is signed out
					userIsSignedIn = false; print("user is not signed in ")
				}
			}
		}
	}


	
	/*
	var body: some View{
		
		ZStack{
			
			
			
			
			 if userIsSignedIn && onboardingComplete{
				HomeView(dismissView: $userIsSignedIn)
					.onAppear{
					//	authService.AUTH_STATUS_CHECKED_ALREADY = true
					}
			}
			
			
			
			
			else if userIsSignedIn && !onboardingComplete{
				
				Background()
				OnboardingSignUpView()
					.onAppear{
						//authService.AUTH_STATUS_CHECKED_ALREADY = true
						
						withAnimation{
							bgModel.solidColor = .black
							bgModel.isSolidColor = true 
							onboardingModel.currentPage = .name
						}
						
					}
			}
			
			
			
			else{
				
				Background()
				SignInOrUpView()
					.onAppear{
						//authService.AUTH_STATUS_CHECKED_ALREADY = true
					}
			}
		
			
		}
		.transition(.opacity)
		.onAppear {
					Auth.auth().addStateDidChangeListener { auth, user in
						
						print("auth: \(auth) user: \(user)")
						
						if let _ = user {
							// User is signed in
							guard !authService.AUTH_STATUS_CHECKED_ALREADY else { return }
							
							withAnimation{
								userIsSignedIn = true
								
								onboardingComplete = false // Bool.random()
							}
							
							
							// ... do something with user
						} else {
							// User is signed out
							userIsSignedIn = false; print("user is not signed in ")
						}
					}
				}
		
		/*
		.onAppear{
			if Auth.auth().currentUser != nil {
				print(" user signed in")
				// the user is signed in
				// check now if they completed onboarding
				
				guard !authService.AUTH_STATUS_CHECKED_ALREADY else { return }
				
				withAnimation{
					userIsSignedIn = true
					
					onboardingComplete = true // Bool.random()
				}
				
				authService.AUTH_STATUS_CHECKED_ALREADY = true
				
			} else { userIsSignedIn = false; print("user is not signed in ") }
		}
		 */
		.environmentObject(bgModel)
		.environmentObject(authService)
		.environmentObject(onboardingModel)
		
		
	
		
	}
	 
	 */
}







struct ContentView_Previews: PreviewProvider {
    
    static var bgmodel = BackgroundViewModel()
    static var previews: some View {
        ContentView()
            .onAppear{
                bgmodel.isSolidColor = false
            }
			.environmentObject(AuthService.shared)
			.environmentObject(bgmodel)
	
			.environmentObject(OnboardingViewModel())
    }
}
