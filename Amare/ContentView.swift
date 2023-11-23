//
//  ContentView.swift
//  Amare
//
//  Created by Micheal Bingham on 7/1/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Combine

struct ContentView: View{
    
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var dataModel: UserProfileModel
    @StateObject var bgModel = BackgroundViewModel()
    @StateObject var onboardingModel = OnboardingViewModel()
   // @StateObject var dataModel = UserProfileModel()
    //@StateObject var viewRouter = ViewRouter()
    
    @EnvironmentObject private var sceneDelegate: SceneDelegate
    
    @State var showSheetForMap: Bool = true
    
    var body: some View{
        
        switch viewRouter.screenToShow {
        case .loading:
            Text("Loading...")
                   .onAppear(perform: {
                    // MARK: - Checking sign in status
                    if let user = Auth.auth().currentUser{
                        //MARK: - User is signed in
                        AuthService.shared.checkOnboardingStatus(for: user.uid) { didFinish in
                            
                            if didFinish{
                                //MARK: - Show Home Screen
                                viewRouter.screenToShow = .home
                                
                            } else {
                                
                                //MARK: - Show onboaring screen
                                viewRouter.screenToShow = .onboarding
                            }
                        }
                    }
                    else{
                        viewRouter.screenToShow = .signInOrUp
                    }
                })

                .environmentObject(bgModel)
                .environmentObject(authService)
                .environmentObject(onboardingModel)
                .environmentObject(dataModel)
                .environmentObject(viewRouter)
        case .signInOrUp:
            SignInOrUpView()
                .environmentObject(bgModel)
                .environmentObject(authService)
                .environmentObject(onboardingModel)
                .environmentObject(dataModel)
                .environmentObject(viewRouter)
        case .onboarding:
            OnboardingSignUpView(skipLogin: true )
                .environmentObject(bgModel)
                .environmentObject(authService)
                .environmentObject(onboardingModel)
                .environmentObject(dataModel)
                .environmentObject(viewRouter)
        case .home:
           /* MapView()
                .opacity(viewRouter.currentPage == .map ? 1: 0) */
            ZStack{
                MapView()
                    .opacity(viewRouter.currentPage == .map ? 1: 0)
                    .onChange(of: viewRouter.currentPage) {
                        page in
                        
                        if page == .map {
                            withAnimation { showSheetForMap = true }
                        } else {
                            withAnimation { showSheetForMap = false }
                        }
                    }
                
                HomeView()
                
            }
            
            .tabSheet(showSheet: $showSheetForMap , initialHeight: 200, sheetCornerRadius: 15) {
                     NavigationStack {
                         ScrollView {
                             /// Showing Some Sample Mock Devices
                             VStack(spacing: 15) {
                                 Text("Tab sheet content")
                                 Text("Tab sheet content")
                                 Text("Tab sheet content")
                                 }
                             }
                             .padding(.horizontal, 15)
                             .padding(.vertical, 10)
                         }
                         .scrollIndicators(.hidden)
                         .scrollContentBackground(.hidden)
                         .toolbar(content: {
                             /// Leading Title
                             ToolbarItem(placement: .topBarLeading) {
                                 Text("Tab Sheet")
                                     .font(.title3.bold())
                             }
                             
                            
                         })
                         .background {
                             if #unavailable(iOS 16.4) {
                                 ClearBackground()
                             }
                         }
                }
             
                 .onAppear {
                     dataModel.loadUser()
                     
                     guard sceneDelegate.tabWindow == nil else { return }

                     sceneDelegate.addTabBar(viewRouter: viewRouter, dataModel)
                 }
                .environmentObject(bgModel)
                .environmentObject(authService)
                .environmentObject(onboardingModel)
                .environmentObject(dataModel)
                .environmentObject(viewRouter)
            
        
            
        }
        
        //Text("Content View")
       

        }
       
        
     
        
    }



struct ContentViewWorkingish: View {
    @EnvironmentObject var authService: AuthService
    @StateObject var bgModel = BackgroundViewModel()
    @StateObject var onboardingModel = OnboardingViewModel()
    @StateObject var dataModel = UserProfileModel()
    @StateObject var viewRouter = ViewRouter()

    @State private var currentView: AnyView = AnyView(LoadingView2())

    var body: some View {
        currentView
            .onAppear {
                determineView()
            }
            .environmentObject(bgModel)
            .environmentObject(authService)
            .environmentObject(onboardingModel)
            .environmentObject(dataModel)
            .environmentObject(viewRouter)
    }

    private func determineView() {
        // Assuming there's a slight delay in fetching the user and onboarding status
        DispatchQueue.main.async {
            if let user = authService.user {
                if authService.isOnboardingComplete {
                    currentView = AnyView(HomeView().onAppear { dataModel.loadUser() })
                } else {
                    currentView = AnyView(OnboardingSignUpView(skipLogin: true).onAppear { onboardingModel.currentPage = .name })
                }
            } else {
                currentView = AnyView(SignInOrUpView().onAppear { bgModel.isSolidColor = false })
            }
        }
    }
}

struct LoadingView2: View {
    var body: some View {
        // Customize your loading view
        Text("Loading...")
    }
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
