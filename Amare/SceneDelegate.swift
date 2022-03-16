//
//  SceneDelegate.swift
//  Love
//
//  Created by Micheal Bingham on 6/21/21.
//

import SwiftUI
import UIKit
import NavigationStack
import URLImage
import URLImageStore
import MultipeerKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var account: Account = Account()
    
    private lazy var transceiver: MultipeerTransceiver = {
            var config = MultipeerConfiguration.default
            config.serviceType = "Amare"

            config.security.encryptionPreference = .required
        
        if let me = Auth.auth().currentUser?.uid{
            config.peerName = me
        }
        
        print("peer name : \(Auth.auth().currentUser?.uid)")
           

            let t = MultipeerTransceiver(configuration: config)

            t.receive(String.self) { [weak self] payload, peer in
                print("Got payload: \(payload)")

                //self?.notify(with: payload, peer: peer)
            }

            return t
        }()

        private lazy var multipeerDataSource: MultipeerDataSource = {
            MultipeerDataSource(transceiver: transceiver)
        }()
    
    
   
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        account.listen()
        
        let urlImageService = URLImageService(fileStore: nil, inMemoryStore: URLImageInMemoryStore())
        
        
        
       
      
        transceiver.resume()
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
          
            let firstView = RootView()
                                    .environmentObject(self.account)
                                    .environment(\.urlImageService, urlImageService)
                                    .environmentObject(multipeerDataSource)
			///
			window.overrideUserInterfaceStyle = .dark
                                        
            window.rootViewController = UIHostingController(rootView: firstView)
            
           
            
            self.window = window
            window.makeKeyAndVisible()
        }
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
