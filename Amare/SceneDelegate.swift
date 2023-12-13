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
import PushNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate, ObservableObject {
    
    let pushNotifications = PushNotifications.shared
    weak var windowScene: UIWindowScene?
    var tabWindow: UIWindow?
    

    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
     /*   pushNotifications.start(instanceId: "de066573-35a5-496c-aae2-16b1d465ebcd")
            pushNotifications.registerForRemoteNotifications()
            try? pushNotifications.addDeviceInterest(interest: "hello")

            // Handling push notifications when the app launches due to a push
            if let notificationResponse = connectionOptions.notificationResponse {
                self.pushNotifications.handleNotification(userInfo: notificationResponse.notification.request.content.userInfo)
            }
        */
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
    
   
    
    func addTabBar( viewRouter: ViewRouter, _ profileModel: UserProfileModel, background: BackgroundViewModel){
        
        guard let scene = windowScene else {
            return
        }
        
        let tabBarController = UIHostingController(rootView: CustomBottomTabBar()
            .environmentObject(viewRouter)
            .environmentObject(profileModel)
            .environmentObject(background)
            .environmentObject(AuthService.shared)
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


    
    func scene(_ scene: UIScene, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
     //   pushNotifications.registerDeviceToken(deviceToken)
        print("registering device with token \(deviceToken)")
    }

    func scene(_ scene: UIScene, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Handle error
        print("error failing remote notifications  \(error)")
    }

}


/// PassThrough UIWindow
class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        return rootViewController?.view == view ? nil : view
    }
}
