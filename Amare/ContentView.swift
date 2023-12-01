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
    @StateObject var mapViewModel: MapViewModel = MapViewModel()
    @StateObject var bgModel = BackgroundViewModel()
    @StateObject var onboardingModel = OnboardingViewModel()
   // @StateObject var dataModel = UserProfileModel()
    //@StateObject var viewRouter = ViewRouter()
    
    @EnvironmentObject  var sceneDelegate: SceneDelegate
    
    @State var showSheetForMap: Bool = true
    
    @State var showUserSheet: Bool = false
    
    @State var mapSheetDetent: PresentationDetent = .fraction(0.35)
    
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
                .onAppear(perform: {
                    withAnimation {
                       
                        guard sceneDelegate.tabWindow != nil else { return }
                        sceneDelegate.removeTabBar()
                    }
                })
           
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
            .sheet(isPresented: $showUserSheet, onDismiss: {
                showSheetForMap = true
            }, content: {
                VStack{
                    
                    CircularProfileImageView(profileImageUrl: AppUser.generateMockData().profileImageUrl, isNotable: AppUser.generateMockData().isNotable, winked: Bool.random(),  showShadow: false)
                        .frame(width: 100, height: 100)
                    
                    NameLabelView(name: AppUser.generateMockData().name, username: AppUser.generateMockData().username)
                    
                }
                    .presentationDetents([.medium])
                    .presentationBackgroundInteraction(
                        .enabled(upThrough: .medium)
                    )
                    
            })
            
            .sheet(isPresented: $showSheetForMap, content: {
                
                NearbyUsersSheet(showUserSheet: $showUserSheet, presentationDetent: $mapSheetDetent)
                    
                    .cornerRadius(20)
                    .environmentObject(mapViewModel)
                    .presentationDetents([.fraction(0.35), .medium, .large], selection: $mapSheetDetent)
                .presentationBackgroundInteraction(
                    .enabled(upThrough: .medium)
                )
                .presentationBackground(.thinMaterial)
                .environmentObject(viewRouter)
            })
            
            /* .tabSheet(showSheet: $showSheetForMap, initialHeight: 250, sheetCornerRadius: 15) {
                NavigationStack{
                    ScrollView{
                        VStack{
                            
                            HStack{
                                Text("\(mapViewModel.nearbyUsers.count) \(mapViewModel.nearbyUsers.count == 1 ? "Person" : "People") Near You")
                                    .font(.title3.bold())
                                    Spacer()
                            }
                            //MARK: - Show nearby users
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack{
                                    
                                    ForEach(mapViewModel.nearbyUsers) { user in
                                        
                                            
                                        CircularProfileImageView(profileImageUrl: user.profileImageUrl, isNotable: false , showShadow: false)
                                                .frame(width: 80)
                                                .padding()
                                                .onTapGesture{
                                                    showSheetForMap = false
                                                    
                                                    AmareApp().delay(1.0) {
                                                        showUserSheet = true
                                                    }
                                                    
                                                    
                                                    
                                                }
                                                
                                                //.padding(.vertical, 10)
                                            
                                    }
                                    
                                }
                                .frame(minHeight: 90)
                                
                            }.scrollContentBackground(.hidden).background(Color.clear)
                               
                        }
                    }
                    .padding()
                    .padding(.vertical, 10)
                    .scrollIndicators(.hidden)
                    .scrollContentBackground(.hidden)
                    
                }.background {
                    if #unavailable(iOS 16.4) {
                        ClearBackground()
                    }
                }
            } */
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
                .environmentObject(mapViewModel)
                .environmentObject(sceneDelegate)
            
        
            
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






struct PreviewHome: View {
    var bgmodel = BackgroundViewModel()
    var vr = ViewRouter()
    var body: some View{
        ContentView()
            .onAppear{
                vr.screenToShow = .home
            }
            .environmentObject(AuthService.shared)
            .environmentObject(bgmodel)
    
            .environmentObject(OnboardingViewModel())
            .environmentObject(MapViewModel()
            )
            .environmentObject(vr)
            .environmentObject(UserProfileModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var bgmodel = BackgroundViewModel()
    static var sceneDelegate = SceneDelegate()
    static var vr = ViewRouter()
    static var previews: some View {
        PreviewHome()
            .environmentObject(sceneDelegate)
    }
}
