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


class SceneDelegate: UIResponder, UIWindowSceneDelegate, ObservableObject {
    
    weak var windowScene: UIWindowScene?
    var tabWindow: UIWindow?
    
    //var window: UIWindow?
//	var authService: AuthService = AuthService.shared
   // weak var windowScene: UIWindowScene?
   // var hudWindow: UIWindow?
    
   // var viewRouter: ViewRouter = ViewRouter()
  //  var profileModel: UserProfileModel = UserProfileModel()
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        windowScene = scene as? UIWindowScene
        
        /*
        let urlImageService = URLImageService(fileStore: nil, inMemoryStore: URLImageInMemoryStore())
		
        
        
	
		let contentView = ContentView()
		.environmentObject(authService)
		.environmentObject(BackgroundViewModel())
        .environmentObject(viewRouter)
        .environmentObject(profileModel)
        

				if let windowScene = scene as? UIWindowScene {
                    
                   
                    
					let window = UIWindow(windowScene: windowScene)
					window.rootViewController = UIHostingController(rootView: contentView) // Set contentView as the root view
					self.window = window
					window.makeKeyAndVisible()
                    
                    self.windowScene = windowScene
                    
                   // addTabBar(in: windowScene, viewRouter: viewRouter, profileModel)
				}
        
        */
			
        
    }
    
   
    
    func addTabBar( viewRouter: ViewRouter, _ profileModel: UserProfileModel){
        
        guard let scene = windowScene else {
            return
        }
        
        let tabBarController = UIHostingController(rootView: CustomBottomTabBar()
            .environmentObject(viewRouter)
            .environmentObject(profileModel)
        )
        tabBarController.view.backgroundColor = .clear
        ///Window
        let tabWindow = PassThroughWindow(windowScene: scene)
        tabWindow.rootViewController = tabBarController
        tabWindow.isHidden = false
        self.tabWindow = tabWindow
        
    }
    
    func removeTabBar() {
        print("removing tab bar scene delegate")
        self.tabWindow?.isHidden = true
        self.tabWindow = nil // Remove the reference, allowing it to be recreated later
    }


    
    
}


/// PassThrough UIWindow
class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        return rootViewController?.view == view ? nil : view
    }
}
