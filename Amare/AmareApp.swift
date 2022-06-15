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
import StreamChat
import StreamChatSwiftUI
import UIKit

@main
struct AmareApp: App {
 
    // Need to keep track of app's life cycle. They should be signed out if they are during sign up process and app quits or exits. Sign the user out if the app enters 
    @Environment(\.scenePhase) var scenePhase
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    


    var body: some Scene {
        
       
        
        WindowGroup {
			//ChatChannelListView(viewFactory: CustomViewFactory())
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
	
	// This is the `StreamChat` reference we need to add
	var streamChat: StreamChat?

		// This is the `chatClient`, with config we need to add
	var chatClient: ChatClient = {
			//For the tutorial we use a hard coded api key and application group identifier
		var config = ChatClientConfig(apiKey: .init("8br4watad788"))
		
		// Real API Key
			//var config = ChatClientConfig(apiKey: .init("6vb87hptvk7d"))
		
			config.applicationGroupIdentifier = "group.com.findamare"
		//tutorial config
		//config.applicationGroupIdentifier = "group.io.getstream.iOS.ChatDemoAppSwiftUI"

			// The resulting config is passed into a new `ChatClient` instance.
			let client = ChatClient(config: config)
			return client
		}()



    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
          
		//-MARK: Configuing Google Places API
      //  GMSServices.provideAPIKey("YOUR_API_KEY")
        GMSPlacesClient.provideAPIKey("AIzaSyDezwobB5BsaO8E8RuuBA715EIc5CeZSCc")
        
		
		//-MARK: Configuring Beams Push Notification API
        self.beamsClient.start(instanceId: "ac1386a2-eac8-4f11-aaab-cad17174260a")
                self.beamsClient.registerForRemoteNotifications()
        try? self.beamsClient.addDeviceInterest(interest: "hello")
        try? self.beamsClient.addDeviceInterest(interest: "debug-hello")
		
		
		//-MARK: Configuring Firebase
     //   FirebaseApp.configure()
		EasyFirebase.configure()
		
		
		//MARK: Customizing Stream Chat Messaging  Design
		
		
		
			var colors = ColorPalette()
			//let streamBlue = UIColor(red: 0, green: 108.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
			//colors.tintColor = Color(streamBlue)
			let amarePink = UIColor(Background().colors.first!)
			colors.tintColor = Background().colors.first!
		var colorsToUse: [UIColor] = []
		for color in Background().colors{
			colorsToUse.append(color.uiColor())
		}
		colors.messageOtherUserBackground = colorsToUse

		//	var fonts = Fonts()
		//	fonts.footnoteBold = Font.footnote
		//	fonts.body = Font.title

			let images = Images()
			images.reactionLoveBig = UIImage(systemName: "heart.fill")!

			let appearance = Appearance(colors: colors/*, images: images, fonts: fonts*/)

			let channelNamer: ChatChannelNamer = { channel, currentUserId in
				"\(channel.name ?? "no name")"
			}

			let utils = Utils(channelNamer: channelNamer)
		
			
		
		
		// The `StreamChat` instance we need to assign
				streamChat = StreamChat(chatClient: chatClient, appearance: appearance, utils: utils)
		
		//MARK: Connecting User to Stream Chat Messaging
		connectUser()
        //account = Account()
        
        return true
    }
    
	// The `connectUser` function we need to add.
		private func connectUser() {
			// This is a hardcoded token valid on Stream's tutorial environment.
			let token = try! Token(rawValue: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibHVrZV9za3l3YWxrZXIifQ.kFSLHRB5X62t0Zlc7nwczWUfsQMwfkpylC6jCUZ6Mc0")

			// Call `connectUser` on our SDK to get started.
			chatClient.connectUser(
					userInfo: .init(id: "luke_skywalker",
									name: "Luke Skywalker",
									imageURL: URL(string: "https://vignette.wikia.nocookie.net/starwars/images/2/20/LukeTLJ.jpg")!),
					token: token
			) { error in
				if let error = error {
					// Some very basic error handling only logging the error.
					log.error("connecting the user failed \(error)")
					return
				}
			}
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


//MARK: Customizing Messaging

class CustomViewFactory: ViewFactory {
	@Injected(\.chatClient) public var chatClient

	func makeMessageTextView(for message: ChatMessage,
							 isFirst: Bool,
							 availableWidth: CGFloat) -> some View {
		return CustomMessageTextView(message: message, isFirst: isFirst)
	}
	
	
}

struct CustomMessageTextView: View {
	@Injected(\.colors) var colors
	@Injected(\.fonts) var fonts

	var message: ChatMessage
	var isFirst: Bool

	public var body: some View {
		Text(message.text)
			.padding()
			.messageBubble(for: message, isFirst: isFirst)
			.foregroundColor(Color(colors.text))
			.font(fonts.bodyBold)
			.overlay(
				BottomRightView {
					Image(systemName: "checkmark.circle.fill")
						.foregroundColor(.green)
						.offset(x: 1, y: -1)
				}
			)
	}
}
