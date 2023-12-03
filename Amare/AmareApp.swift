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
import StreamChat
import StreamChatSwiftUI
import UIKit
import FirebaseMessaging
import FirebaseInAppMessagingSwift

@main
struct AmareApp: App {
 
    // Need to keep track of app's life cycle. They should be signed out if they are during sign up process and app quits or exits. Sign the user out if the app enters 
    @Environment(\.scenePhase) var scenePhase
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    
    let urlImageService = URLImageService(fileStore: nil, inMemoryStore: URLImageInMemoryStore())
    
    //var authService: AuthService = AuthService.shared
    
    let beamsClient = PushNotifications.shared
    
    // This is the `StreamChat` reference we need to add
    var streamChat: StreamChat?
    
    @StateObject var viewRouter: ViewRouter = ViewRouter()
    @StateObject var profileModel: UserProfileModel = UserProfileModel()

    init(){
        
        
        
    }
    var body: some Scene {
        
        WindowGroup {
            
        ContentView()
            .environmentObject(AuthService.shared)
            .environmentObject(BackgroundViewModel())
            .environmentObject(viewRouter)
            .environmentObject(profileModel)
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


    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
          
		// MARK: - Configuing Google Places API
      //  GMSServices.provideAPIKey("YOUR_API_KEY")
            // GMSPlacesClient.provideAPIKey("AIzaSyDezwobB5BsaO8E8RuuBA715EIc5CeZSCc")
        
		
		// MARK: - Configuring Beams Push Notification API
        
       //configureBeamsPushNotifications()
		
		
		// MARK: -  Configuring Firebase
       FirebaseApp.configure()
        // Register for push notifications
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
            application.registerForRemoteNotifications()
		
        //MARK: - Push the device token to the database
        // Listener for authentication state
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
                    if let user = user {
                        // User is signed in, update token
                        self?.updateFirestoreWithFCMToken(token: Messaging.messaging().fcmToken, userID: user.uid)
                    } else {
                        // User is signed out, remove token
                        self?.removeFCMTokenForSignedOutUser()
                    }
                }
		
		//MARK: - Customizing Stream Chat Messaging  Design
		
		
		var mycolors = [
			Color(UIColor(red: 1.00, green: 0.01, blue: 0.40, alpha: 1.00)),
			Color(UIColor(red: 0.94, green: 0.16, blue: 0.77, alpha: 1.00))
		]
			var colors = ColorPalette()
			//let streamBlue = UIColor(red: 0, green: 108.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
			//colors.tintColor = Color(streamBlue)
			let amarePink = UIColor(mycolors.first!)
			colors.tintColor = mycolors.first!
		var colorsToUse: [UIColor] = []
		for color in mycolors{
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

			let utils = Utils(channelNamer: DefaultChatChannelNamer())
        let messageListConfig = MessageListConfig(
            becomesFirstResponderOnOpen: false
        )
        
        utils.messageListConfig = messageListConfig
      
    
		
        var config = ChatClientConfig(apiKey: .init("92jyyxebed2m"))
       
		ChatClient.shared = ChatClient(config: config)
		
		
        
		// The `StreamChat` instance we need to assign
		streamChat = StreamChat(chatClient: ChatClient.shared, appearance: appearance, utils: utils)
		
		
        
        return true
    }
    
	// The `connectUser` function we need to add.
  /*  private func connectUser() {
        
        

        
            let id: String = "micheal"
            let name: String = "Micheal Bingham"
            let imageURL: String = AppUser.generateMockData().profileImageUrl!
        // This is a hardcoded token valid on Stream's tutorial environment.
        //let token = try! Token(rawValue: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibHVrZV9za3l3YWxrZXIifQ.kFSLHRB5X62t0Zlc7nwczWUfsQMwfkpylC6jCUZ6Mc0")
    
            let token = try! Token(rawValue: "eeyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibWljaGVhbCJ9.FFwAA6_jdJgAkWYBAb_jKorjOTpfhZkTg7zdsE1GiNI")
        // Call `connectUser` on our SDK to get started.
            ChatClient.shared.connectUser(
                userInfo: .init(id: id,
                                name: name,
                                imageURL: URL(string: imageURL)!),
                token: .development(userId: id)
        ) { error in
            if let error = error {
                // Some very basic error handling only logging the error.
                log.error("connecting the user failed \(error)")
                return
            }
        }
    }
	*/
	
	
	
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        

        
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
        
        completionHandler([.alert, .badge, .sound, .banner])
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        config.delegateClass = SceneDelegate.self
        return config

    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM Token: \(String(describing: fcmToken))")
        if let token = fcmToken {
            UserDefaults.standard.set(token, forKey: "FCMToken")
        }
    }

    

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("registering remote notificaitons with token \(deviceToken)")
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
        Messaging.messaging().apnsToken = deviceToken

        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
            let token = tokenParts.joined()
            print("Device Token: \(token)")

            // Store the token in UserDefaults
            UserDefaults.standard.set(token, forKey: "DeviceToken")
       
    }
    
    // MARK: - Configuring Beams Push Notification API
    func configureBeamsPushNotifications() {
        print("configuring beams push notifications")
        self.beamsClient.start(instanceId: "de066573-35a5-496c-aae2-16b1d465ebcd")
        self.beamsClient.registerForRemoteNotifications()
        
        do {
            try self.beamsClient.addDeviceInterest(interest: "hello")
        } catch {
            print("Error adding device interest 'hello': \(error)")
        }
        
       //  Uncomment and use the following if you want to add additional interests with error handling
         do {
             try self.beamsClient.addDeviceInterest(interest: "debug-hello")
         } catch {
             print("Error adding device interest 'debug-hello': \(error)")
         }
    }

    
   
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }
    
    private func updateDeviceTokenForUser(userID: String?, addingToken: Bool) {
            guard let deviceToken = UserDefaults.standard.string(forKey: "DeviceToken") else { return }

            guard let userID = userID else {
                // If there's no user ID (user signed out), exit early
                return
            }

            let db = Firestore.firestore()
            let userDeviceTokenRef = db.collection("deviceTokens").document(userID)

            // Transaction to ensure atomic update of the device tokens array
            db.runTransaction({ (transaction, errorPointer) -> Any? in
                let userDocument: DocumentSnapshot
                do {
                    try userDocument = transaction.getDocument(userDeviceTokenRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }

                // Get current device tokens, if they exist
                var deviceTokens = userDocument.data()?["tokens"] as? [String] ?? []

                if addingToken {
                    // Add new token if it's not already in the array
                    if !deviceTokens.contains(deviceToken) {
                        deviceTokens.append(deviceToken)
                    }
                } else {
                    // Remove the token if the user is signing out
                    if let index = deviceTokens.firstIndex(of: deviceToken) {
                        deviceTokens.remove(at: index)
                    }
                }

                // Update the Firestore document
                transaction.updateData(["tokens": deviceTokens], forDocument: userDeviceTokenRef)
                return nil
            }) { (_, error) in
                if let error = error {
                    print("Error updating device tokens: \(error)")
                }
            }
        }

    private func updateDeviceTokenForUser(userID: String) {
            guard let deviceToken = UserDefaults.standard.string(forKey: "DeviceToken") else { return }

            let db = Firestore.firestore()
            let userDeviceTokenRef = db.collection("deviceTokens").document(userID)

            // Transaction to ensure atomic update of the device tokens array
            db.runTransaction({ (transaction, errorPointer) -> Any? in
                let userDocument: DocumentSnapshot
                do {
                    try userDocument = transaction.getDocument(userDeviceTokenRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }

                // Get current device tokens, if they exist
                var deviceTokens = userDocument.data()?["tokens"] as? [String] ?? []

                // Add new token if it's not already in the array
                if !deviceTokens.contains(deviceToken) {
                    deviceTokens.append(deviceToken)
                }

                // Update the Firestore document
                transaction.updateData(["tokens": deviceTokens], forDocument: userDeviceTokenRef)
                return nil
            }) { (_, error) in
                if let error = error {
                    print("Error updating device tokens: \(error)")
                }
            }
        }
    
    private func updateFirestoreWithFCMToken(token: String?, userID: String) {
        guard let token = token else { return }

        let userDeviceTokenRef = Firestore.firestore().collection("deviceTokens").document(userID)
        userDeviceTokenRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var deviceTokens = document.data()?["tokens"] as? [String] ?? []
                if !deviceTokens.contains(token) {
                    deviceTokens.append(token)
                }
                userDeviceTokenRef.updateData(["tokens": deviceTokens])
            } else {
                userDeviceTokenRef.setData(["tokens": [token]])
            }
        }
    }





        private func removeFCMTokenForSignedOutUser() {
            guard let userID = Auth.auth().currentUser?.uid,
                  let tokenToRemove = Messaging.messaging().fcmToken else { return }

            let db = Firestore.firestore()
            let userDeviceTokenRef = db.collection("deviceTokens").document(userID)

            db.runTransaction({ (transaction, errorPointer) -> Any? in
                let userDocument: DocumentSnapshot
                do {
                    try userDocument = transaction.getDocument(userDeviceTokenRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }

                var deviceTokens = userDocument.data()?["tokens"] as? [String] ?? []
                deviceTokens.removeAll { $0 == tokenToRemove }

                transaction.updateData(["tokens": deviceTokens], forDocument: userDeviceTokenRef)
                return nil
            }, completion: { _, error in
                if let error = error {
                    print("Error removing device token: \(error)")
                }
            })
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


//MARK: Customizing The Chat UI
class DemoAppFactory: ViewFactory {

    @Injected(\.chatClient) public var chatClient

     init() {}

    public static let shared = DemoAppFactory()

    func makeChannelListHeaderViewModifier(title: String) -> some ChannelListHeaderViewModifier {
        CustomChannelModifier(title: title)
    }
}



class CustomViewFactory: ViewFactory {
	@Injected(\.chatClient) public var chatClient

	func makeMessageTextView(for message: ChatMessage,
							 isFirst: Bool,
							 availableWidth: CGFloat) -> some View {
		return CustomMessageTextView(message: message, isFirst: isFirst)
	}
	
	func makeChannelListHeaderViewModifier(title: String) -> some ChannelListHeaderViewModifier {
			CustomChannelModifier(title: title)
		}
	
    
	func makeChannelListTopView(searchText: Binding<String>) -> some View {
		MessagesChannelListTopView(searchText: searchText)
	}
	
	
	
}


//MARK: Custom Message Text View
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


//MARK: Custom Chanel Header
public struct CustomChannelHeader: ToolbarContent {

	@Injected(\.fonts) var fonts
	@Injected(\.images) var images

	public var title: String
	public var onTapLeading: () -> ()

	public var body: some ToolbarContent {
		ToolbarItem(placement: .principal) {
			Text(title)
				.font(fonts.bodyBold)
		}
		ToolbarItem(placement: .navigationBarTrailing) {
			NavigationLink {
				Text("This is injected view")
			} label: {
				Image(uiImage: images.messageActionEdit)
					.resizable()
			}
		}
		ToolbarItem(placement: .navigationBarLeading) {
			Button {
				onTapLeading()
			} label: {
				Image(systemName: "line.3.horizontal")
					.resizable()
			}
		}
	}
}

//MARK: Custom Channel Modifier
struct CustomChannelModifier: ChannelListHeaderViewModifier {

	var title: String

	@State var profileShown = false

	func body(content: Content) -> some View {
		content.toolbar {
			CustomChannelHeader(title: title) {
				profileShown = true
			}
		}
		.sheet(isPresented: $profileShown) {
			Text("Profile View")
		}
	}

}
