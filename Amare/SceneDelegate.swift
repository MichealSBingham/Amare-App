//
//  SceneDelegate.swift
//  Love
//
//  Created by Micheal Bingham on 6/21/21.
//

import SwiftUI
import UIKit
//import NavigationStack
import URLImage
import URLImageStore
import Firebase
import StreamChat
import StreamChatSwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
	var authService: AuthService = AuthService.shared
	
    
    

    
   
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
      
        
        let urlImageService = URLImageService(fileStore: nil, inMemoryStore: URLImageInMemoryStore())
		
	
	//	let contentView = ContentView().environmentObject(authService) // Pass authService as environment object
      //  let contentView = OnboardingSignUpView(skipLogin: true).environmentObject(OnboardingViewModel())
      
        let contentView = HomeView().environmentObject(authService).environmentObject(UserProfileModel()).environmentObject(OnboardingViewModel())
		.environmentObject(authService)
		.environmentObject(BackgroundViewModel())
		
		

				if let windowScene = scene as? UIWindowScene {
					let window = UIWindow(windowScene: windowScene)
					window.rootViewController = UIHostingController(rootView: contentView) // Set contentView as the root view
					self.window = window
					window.makeKeyAndVisible()
				}
			
		
		
        /*
		 
================================================== OLD WAY OF DOING THINGS ==========================
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
          
            var firstView = RootView()
                                    .environmentObject(self.account)
                                    .environment(\.urlImageService, urlImageService)
                                    .environmentObject(dataSource)
            
            
            let testView = OnboardingSignUpView()
			
			
            
            
			
			//let firstView =   ChatChannelListView(viewFactory: CustomViewFactory())
                                    
			///
			window.overrideUserInterfaceStyle = .dark
                                        
            
            
            switch AppConfig.environment{
            case .development:
                window.rootViewController = UIHostingController(rootView: testView)
            case .testing:
                window.rootViewController = UIHostingController(rootView: testView)
            case .production:
                window.rootViewController = UIHostingController(rootView: firstView)
            }
            
            self.window = window
            window.makeKeyAndVisible()
        }
		
		*/
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
		

    }
    
    
func sceneDidEnterBackground(_ scene: UIScene) {
    
    
    
    
}
    
func sceneWillResignActive(_ scene: UIScene) {
    

}
    
    
func sceneDidDisconnect(_ scene: UIScene) {

}
    
}
