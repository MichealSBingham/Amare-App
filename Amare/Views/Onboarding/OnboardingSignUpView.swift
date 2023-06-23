//
//  OnboardingSignUpView.swift
//  Amare
//
//  Created by Micheal Bingham on 6/4/23.
//

import SwiftUI

struct OnboardingSignUpView: View {
    
    @StateObject var viewModel = OnboardingViewModel()
    
    @State var page: OnboardingScreen = .name
    
  
    var body: some View {
        
        ZStack{
            
                        
            VStack{
                
                ProgressBarView(progress: $viewModel.progress)
                    .onChange(of: viewModel.currentPage, perform: { page in
                        
                        withAnimation{
                            
                            viewModel.progress = onboardingProgress(on: page)
                        }
                       
                    })
                    .padding()
                
                Spacer()
            }
            
            TabView(selection: $viewModel.currentPage) {
                
                Group{
                    
                    InputNameView()
                        .tag(OnboardingScreen.name)
                    /*
                        .onAppear{ withAnimation{viewModel.progress = onboardingProgress(on: page)}}
                     */
                    
                    UsernameInputView()
                        .tag(OnboardingScreen.username)
                    
                    Text("Will Be Birthday Screen")
                        .tag(OnboardingScreen.birthday)
                    
                }
                .environmentObject(viewModel)
               
                
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
        }
        
        
            
            
        
        
    }
    
    /// Returns a double to represent the progress the user has completed onboarding , calculated dynamically
    func onboardingProgress(on screen: OnboardingScreen) -> Double {
        
        return Double(OnboardingScreen.allCases.firstIndex(of: screen) ?? 0) / Double(OnboardingScreen.allCases.count - 2)
    }
}

struct OnboardingSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingSignUpView()
    }
}
