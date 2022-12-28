//
//  MainView.swift
//  Amare
//
//  Created by Micheal Bingham on 8/12/21.
//

import SwiftUI
import NavigationStack
import MultipeerKit
import StreamChat
import StreamChatSwiftUI


struct MainView: View {
    
    /// id of view
    static let id = String(describing: Self.self)
   
	///  Contains the data model that represents all of the user data for the signed in user
    @StateObject private var mainViewModel: UserDataModel = UserDataModel()
    
    
    
    @EnvironmentObject private var account: Account

    
    @State private var tabSelection = 1

    /// Whether or not this view became the root view when it was instantiated 
     var isRoot: Bool
    
    var body: some View {
        
        ZStack{
            
            switch tabSelection{
                
            case 0:
                TestView()
                    .environmentObject(mainViewModel)
            case 1:
                DiscoverNearbyView()
            case 2:
                TestView2()
            case 3:
                NavigationStackView{
                    ChatChannelListView(viewFactory: CustomViewFactory(), title: "DMs")
                            
                            .environmentObject(account)
                            .navigationTitle("DMs")
                            .environmentObject(mainViewModel)
                            
                    
                }
            case 4:
                Perferences()
            default:
                TestView()
               
                
            }
            
            
            VStack{
                Spacer()
                FloatingTabbar(selected: $tabSelection)
            }
        }
       
    
/*
        TabView(selection: $tabSelection) {
                
                //Map()
           TestView()
                .tag(1)
                .environmentObject(mainViewModel)
        
                NatalChart()
                .environmentObject(mainViewModel)
                .tag(2)
            
                Scanner()
                .tag(3)
			
			DiscoverNearbyView()
				.tag(6)
			
			NavigationStackView{
				ChatChannelListView(viewFactory: CustomViewFactory(), title: "DMs")
						
						.environmentObject(account)
						.navigationTitle("DMs")
						.environmentObject(mainViewModel)
						
				
			}
			.tabItem { Label("Chats", systemImage: "message.circle") }
			.tag(4)
		
			
                Perferences()
                .tag(5)
                
                
            }
        
        
        
        
        */
            .onAppear(perform: { thingsToDoWhenMainViewLoads()})
            // .onDisappear(perform: {mainViewModel.unsubscribeToUserDataChanges()})
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.logout), perform: { _ in
            print("Received notification to sign out...")
                goBackToSignInRootView()
        
        })
            .onChange(of: mainViewModel.inCompleteData) { isIncomplete in
                
                print("*****Incomplete data variable changed in mainview : \(isIncomplete) ")
                
                if isIncomplete { account.signOut() }
            }
                        
            
            
            
        
       
    }
    
    
    func Scanner() ->  some View  {
        
        return ScannerView()
                .tabItem { Label("Scanner", systemImage: "iphone.rear.camera") }
                .environmentObject(account)
        
    }
    
    func NatalChart() ->  some View  {
        
        return ChartView(tabSelection: $tabSelection)
                .tabItem { Label("Chart", systemImage: "calendar.circle") }
                .environmentObject(account)
        
    }
    
    func Chats() ->  some View  {
        
        return ChatChannelListView(viewFactory: CustomViewFactory())
                .tabItem { Label("Chats", systemImage: "message.circle") }
                .environmentObject(account)
        
    }
    
    func Perferences() ->  some View  {
        
        return SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .environmentObject(account)
        
    }
    
    func Map() ->  some View  {
        
        return MapView()
                .tabItem { Label("Map", systemImage: "map.circle") }
                .environmentObject(account)
        
    }
    
    
    func goBackToSignInRootView()  {
        print("Should be going back to root sign in ")
        if isRoot {
            // Push it back I suppose ...
			print("***Pushing back is root")
            //navigationStack.push(SignInOrUpView( isRoot: false))
        } else{
            
			print("***popping back instead ")
            //navigationStack.pop(to: .root)
        }
     
        
    }
    
    
    
    
    
    /// Listen for user data updates
    /// Listen for a sign out change in the auth
    ///  Save this view so that app delgate knows that they finished the sign up process
    func thingsToDoWhenMainViewLoads()  {
        
        print("Things to do when view loads... ")
        
        /// We ensure that the data has complete sign up data otherwise we sign them out. This handles the case whre they begin signing up but for some reason they never finish. We don't want to show them the main view.
     
        
        mainViewModel.load()
        account.listenOnlyForSignOut()
      
        
		print("the user is ... \(mainViewModel.userData)")
		
		
		
    }
	
	
    
}




struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView( isRoot: false)
            .environmentObject(Account())
            .environmentObject(NavigationStackCompat())
    }
}
