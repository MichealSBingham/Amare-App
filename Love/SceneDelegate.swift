//
//  SceneDelegate.swift
//  Love
//
//  Created by Micheal Bingham on 6/21/21.
//

import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var account: Account = Account()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        account.listen()
        
        
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
          
            let firstView = RootView().environmentObject(self.account)
            window.rootViewController = UIHostingController(rootView: firstView)
            
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    
    
    
func sceneDidEnterBackground(_ scene: UIScene) {
    
    if !(isDoneWithSignUp()){
            // if not done with sign up... log user out.
        account.signOut {
            //
        } cantSignOut: { error in
            //
        }

    }
   
    
    
}
    func sceneWillResignActive(_ scene: UIScene) {
       

    }
    
}
