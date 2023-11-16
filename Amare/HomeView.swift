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
	
    
    @State var tabSelection: Int = 3
	
	
    
    
    
   
    

	
	
    var body: some View {
		
	
        
        
        TabView(selection: $tabSelection){
            
           
                SearchAndFriendsView()
                    .tag(0)
                    .tabItem {
                        
                        VStack{
                            
                            Image(self.tabSelection == 0 ? "TabView/search2" : "TabView/search")
                                .resizable()
                                .frame(width: 25, height: 25)
                              //  .preferredColorScheme(.dark)
                        }
                        
                    }
            
           
            
          
            ChatChannelListView(/*viewFactory: CustomViewFactory(), title: "Messages"*/)
                        .tag(1)
                        .tabItem {
                            
                            VStack{
                                
                                Image(self.tabSelection == 1 ? "TabView/messagesIcon2" : "TabView/messagesIcon")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                  //  .preferredColorScheme(.dark)
                            }
                            
                        }
            
 
                Text("Sign out \(authService.user?.uid ?? "") and name: \(currentUserDataModel.user?.name ?? "")")
                    .onTapGesture {
                        authService.signOut()
                        withAnimation{
                            background.isSolidColor = false
                        }
                       
                    }
                    .tag(2)
                    .tabItem {
                        
                        VStack{
                            
                            Image(self.tabSelection == 2 ? "TabView/HomeIcon2" : "TabView/HomeIcon")
                                .resizable()
                                .frame(width: 25, height: 25)
                              //  .preferredColorScheme(.dark)
                        }
                        
                    }
                
            
        MainProfileView()
                .preferredColorScheme(.dark)
                .tag(3)
                .tabItem{
                    
                    CircularProfileImageView(profileImageUrl: currentUserDataModel.user?.profileImageUrl)
                        .preferredColorScheme(.dark)
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
            .environmentObject(UserProfileModel())
    }
}
