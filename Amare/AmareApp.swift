//
//  LoveApp.swift
//  Love
//
//  Created by Micheal Bingham on 6/15/21.
//

import SwiftUI
import Firebase
import FirebaseAuth
import URLImage
import URLImageStore
import PushNotifications
import GooglePlaces
import EasyFirebase

@main
struct AmareApp: App {
 
    // Need to keep track of app's life cycle. They should be signed out if they are during sign up process and app quits or exits. Sign the user out if the app enters 
    @Environment(\.scenePhase) var scenePhase
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    


    var body: some Scene {
        
       
        
        WindowGroup {
           
        }
        
        .onChange(of: scenePhase) { newScenePhase in
            
            switch scenePhase{
                
            case .background:
                print("\n\n Scence Phase: Background")
                
                /*
                // Log out the user if they are in the sign up process
                if !(isDoneWithSignUp()){
                        // if not done with sign up... log user out.
                    Account().signOut {
                        //
                        NavigationUtil.popToRootView()
                    } cantSignOut: { error in
                        //
                    }

                } */

                
                break
            case .inactive:
                print("\n\n Scence Phase: Inactive ")
                break
            case .active:
                print("\n\n Scence Phase: Active ")
                break
            @unknown default:
                print("\n\n Scence Phase: Unknown ")
                break
            }
        }
    }
    
    /// Dismisses the keyboard
    func dismissKeyboard(completion: (() -> Void)? = nil )  {
        UIApplication.shared.dismissKeyboard()
        completion?()
    }
    
    /// Delays code executiion by a specified time
    func delay(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
}



class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
   // var account: Account?
    let beamsClient = PushNotifications.shared


    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
          
      //  GMSServices.provideAPIKey("YOUR_API_KEY")
        GMSPlacesClient.provideAPIKey("AIzaSyDezwobB5BsaO8E8RuuBA715EIc5CeZSCc")
        
        self.beamsClient.start(instanceId: "ac1386a2-eac8-4f11-aaab-cad17174260a")
                self.beamsClient.registerForRemoteNotifications()
        try? self.beamsClient.addDeviceInterest(interest: "hello")
        try? self.beamsClient.addDeviceInterest(interest: "debug-hello")
     //   FirebaseApp.configure()
		EasyFirebase.configure()
        
        //account = Account()
        
        return true
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        self.beamsClient.handleNotification(userInfo: userInfo)

        
        if Auth.auth().canHandleNotification(userInfo){
            completionHandler(.noData)
            return
        }
    }
    
    
    // Notification received in foreground
    
   
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    
        print("**** RECEIVED Notification **** ")
        
        // check if it is a winking notification ..
        //NotificationCenter.default.post(name: NSNotification.gotWinkedAt, object: nil)
        
        completionHandler([.alert, .badge, .sound])
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)

    }
    
    /*
    func applicationWillResignActive(_ application: UIApplication) {
        
        if !(isDoneWithSignUp()){
                // if not done with sign up... log user out.
            print("not done with sign up ... signing out..")
            account.signOut { error in
                
                guard error == nil else{
                    return
                }
                
            }
            
          
        }
    }
    */
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        /* Alternative Solution is to just sign them out if the data isn't complete on the homepage
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
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        /*
        if !(isDoneWithSignUp()){
                // if not done with sign up... log user out.
            account.signOut { error in
                //
                guard error == nil else { return }
                //NavigationUtil.popToRootView()
            }

        }
        
        */
    

    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
        self.beamsClient.registerDeviceToken(deviceToken)
        
       
    }
    
    
    
}

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func showKeyboard() {
        sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
    }
}
