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
	
    
    @State var tabSelection: Int = 2
	
	
    
    ///  Contains the data model that represents all of the user data for the signed in user
    @StateObject private var mainViewModel: UserDataModel = UserDataModel()
    
    /// Contains data model for obtaining nearby users
    /// TODO:  seperate this from `testViewModel` to make more light weight
    @StateObject private var nearbyUsersModel: TestViewModel = TestViewModel()
    
    @ObservedObject private var account: Account = Account()
    
	
	
    var body: some View {
		
	/*	ZStack{
			
			Group{
				Text("This is what the user will see when they sign in.\nTap to Sign out")
					.foregroundColor(.amare)
					.onTapGesture{
						authService.signOut{_ in
							withAnimation{
								//dismissView = false
								//authService.AUTH_STATUS_CHECKED_ALREADY = false
                                background.isSolidColor = false
								viewModel.currentPage = .phoneNumber
							}
							
						}
					}
			}
			
			
		
			
				
			
		} */
        
        ZStack{
            
            switch tabSelection {
                
            case 0:
                SearchAndFriendsView()
                    
                   
            case 1:
                DiscoverNearbyView()
                    .ignoresSafeArea()
                    
                   
                    
            case 2:
                Background()
                    
            case 3:
               // NavigationStackView{
                    ChatChannelListView(viewFactory: CustomViewFactory(), title: "DMs")
                            .navigationTitle("DMs")
                            .ignoresSafeArea()
                            
                            
                    
               // }
            case 4:
                SettingsView()
                    .ignoresSafeArea()
            default:
               Background()
                    //.ignoresSafeArea()
                    
               
                
            }
            
            
            VStack{
                Spacer()
                FloatingTabbar(selected: $tabSelection)
                
            }
        }
		.environmentObject(authService)
		.environmentObject(background)
		.environmentObject(viewModel)
        .environmentObject(mainViewModel)
		
		
	
		

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
		HomeView()
			.environmentObject(AuthService.shared)
			.environmentObject(BackgroundViewModel())
			.environmentObject(OnboardingViewModel())
            .environmentObject(Account())
    }
}
