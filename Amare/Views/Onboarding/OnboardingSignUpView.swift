//
//  OnboardingSignUpView.swift
//  Amare
//
//  Created by Micheal Bingham on 6/4/23.
//

import SwiftUI

struct OnboardingSignUpView: View {
    
	@EnvironmentObject var background: BackgroundViewModel
	
	@EnvironmentObject var viewModel: OnboardingViewModel
	
	@EnvironmentObject var authService: AuthService
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var page: OnboardingScreen = .phoneNumber
    
	@State var showProgressBar: Bool = false
    
    var skipLogin: Bool = false
  
    var body: some View {
        
        ZStack{
            
                        
            VStack{
                
                ProgressBarView(progress: $viewModel.progress)
					.opacity(showProgressBar || skipLogin ? 1 : 0 )
                    .onChange(of: viewModel.currentPage, perform: { page in
                        
                        withAnimation{
                            
                            viewModel.progress = onboardingProgress(on: page)
                        }
						
						if page == .name {
							withAnimation {
								
								background.solidColor = .black
								background.isSolidColor = true 
								showProgressBar = true
								
								
							}
						}
                       
                    })
                    .padding()
                
                Spacer()
            }
            
            TabView(selection: $viewModel.currentPage) {
                
                Group{
					
                    if !skipLogin {
                        InputPhoneNumber()
                            .tag(OnboardingScreen.phoneNumber)
                        
                        InputVerificationCode()
                            .tag(OnboardingScreen.authCode)
                    }
					
					 
                     
                    InputNameView()
                        .tag(OnboardingScreen.name)
						
					
                    
                    BirthdayInputView()
                        .tag(OnboardingScreen.birthday)
					
					BirthtimeInputView()
						.tag(OnboardingScreen.birthtime)
					
					GenderInputView()
						.tag(OnboardingScreen.genderSelection)
					
					IntentionInputView()
						.tag(OnboardingScreen.intention)
					
					OrientationInputView()
                        .tag(OnboardingScreen.orientation)
					
                    
                    PredictedTraitsView()
                        .tag(OnboardingScreen.traitPredictor)
                    
                    PredictedPersonalityStatementsView()
                        .tag(OnboardingScreen.personality)
                    
                    MediaUploadView()
                        .tag(OnboardingScreen.mediaUpload)
                    
                    UsernameInputView()
                        .tag(OnboardingScreen.username)
                    
                }
                .environmentObject(viewModel)
				.environmentObject(background)
				.environmentObject(authService)
                .environmentObject(viewRouter)
               
                
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
			.onAppear{
                viewModel.resetData()
				if viewModel.currentPage == .name{
					withAnimation {
						
						background.solidColor = .black
						background.isSolidColor = true
						showProgressBar = true
						
						
					}
				}
                
              
			}
			
            
        }
        .ignoresSafeArea(.keyboard)
		.preferredColorScheme(.dark)
            
            
        
        
    }
    
    /// Returns a double to represent the progress the user has completed onboarding , calculated dynamically
    func onboardingProgress(on screen: OnboardingScreen) -> Double {
        
		//print("Screen \(screen) : num \(Double(OnboardingScreen.allCases.firstIndex(of: screen) ?? 0) ) and dem: \(Double(OnboardingScreen.allCases.count - 2))\n\n")
		
        return Double(OnboardingScreen.allCases.firstIndex(of: screen) ?? 0) / Double(OnboardingScreen.allCases.count - 1)
    }
}

struct OnboardingSignUpView_Previews: PreviewProvider {
    static var previews: some View {
		
		ZStack{
			
			//Background()
				//.environmentObject(BackgroundViewModel())
			OnboardingSignUpView()
				.environmentObject(BackgroundViewModel())
				.environmentObject(OnboardingViewModel())
				.environmentObject(AuthService.shared)
		}
        
			
    }
}
