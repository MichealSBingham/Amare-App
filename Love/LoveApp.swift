//
//  LoveApp.swift
//  Love
//
//  Created by Micheal Bingham on 6/15/21.
//

import SwiftUI
import Firebase
import FirebaseAuth


@main
struct LoveApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    


    var body: some Scene {
        
        WindowGroup {
           
                EnterPhoneNumberView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
            
        }
    }
}



class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var account: Account = Account()

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Did finish launching with options")
        FirebaseApp.configure()
        
        
        return true
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if Auth.auth().canHandleNotification(userInfo){
            completionHandler(.noData)
            return
        }
    }
    
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)

    }
    
}
