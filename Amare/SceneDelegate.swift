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
//import MultipeerKit
import Firebase
import StreamChat
import StreamChatSwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
	var authService: AuthService = AuthService.shared
	
	
    //var account: Account = Account()
    /*
    private lazy var transceiver: MultipeerTransceiver = {
            var config = MultipeerConfiguration.default
            config.serviceType = "Amare"

            config.security.encryptionPreference = .required
        
            if let deviceID = UIDevice.current.identifierForVendor?.uuidString {
            config.peerName = deviceID
        }
     
            let t = MultipeerTransceiver(configuration: config)
        
            return t
        }()

    private lazy var dataSource: MultipeerDataSource = {
        MultipeerDataSource(transceiver: transceiver)
    }()
    */
    
   
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        //account.listen()
        
        let urlImageService = URLImageService(fileStore: nil, inMemoryStore: URLImageInMemoryStore())
        
      //  transceiver.resume()
        
       
        
        // TESTING //
        //var helper = NearbyInteractionHelper()
		
	
		let contentView = ContentView().environmentObject(authService) // Pass authService as environment object
		
		
		
		//let example = AmareUser.random() //AmareUser(id: "3432", name: "Micheal")
	//	let contentView = FindNearbyUserView(user: .constant(example), blindMode: false)
		//.environmentObject(helper)
		.environmentObject(authService)
		.environmentObject(BackgroundViewModel())
		
		// END TESTING

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
        
		/*
        print("the account data is \(account.data)")
        
        if (account.data?.isComplete() ?? false) && account.isSignedIn {
            print("!Just entered foreground ")
        }
		*/

    }
    
    
func sceneDidEnterBackground(_ scene: UIScene) {
    
    /*  We MIGHT not need this. This signs out user if app goes into background and if they aren't finished signing up in app
     
    if !(isDoneWithSignUp()){
            // if not done with sign up... log user out.
        account.signOut {
            //
        } cantSignOut: { error in
            //
        }

    }
    */
    
    
}
    
func sceneWillResignActive(_ scene: UIScene) {
    

}
    
    
func sceneDidDisconnect(_ scene: UIScene) {
    /*
    print("application WILL terminate ")
    if !(isDoneWithSignUp()){
            // if not done with sign up... log user out.
        print("not done with sign up ... signing out..")
        account.signOut { error in
            
            guard error == nil else{
                return
            }
            
        }
        
        
    }
    */
}
    
}
