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

@main
struct AmareApp: App {
 
    // Need to keep track of app's life cycle. They should be signed out if they are during sign up process and app quits or exits. Sign the user out if the app enters 
    @Environment(\.scenePhase) var scenePhase
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    


    var body: some Scene {
        
       
        
        WindowGroup {
			
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
/*	var chatClient: ChatClient = {
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
	*/


    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
          
		// MARK: - Configuing Google Places API
      //  GMSServices.provideAPIKey("YOUR_API_KEY")
            // GMSPlacesClient.provideAPIKey("AIzaSyDezwobB5BsaO8E8RuuBA715EIc5CeZSCc")
        
		
		// MARK: - Configuring Beams Push Notification API
        
       configureBeamsPushNotifications()
		
		
		// MARK: -  Configuring Firebase
       FirebaseApp.configure()
		
		
		
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
		
		connectUser()
		// The `StreamChat` instance we need to assign
		streamChat = StreamChat(chatClient: ChatClient.shared, appearance: appearance, utils: utils)
		
		
        
        return true
    }
    
	// The `connectUser` function we need to add.
    private func connectUser() {
        
        
    //	guard Account.shared.data?.isComplete() ?? false else { print("Data is not complete, thus we will not connect the user to messaging SDK. "); return }
        
        
    //	print("Data is complete, thus we will connect to the user.")
        
    //	let name = Account.shared.data?.name ?? ""
    //	let id = Account.shared.data?.id
    //	let imageURL: String  = (Account.shared.data?.profile_image_url!)!
        
        //guard let id = id else { print("We don't have the user id so we are not connecting to Messaging"); return }
        
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
    
    
    
    
    
    
    

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
        self.beamsClient.registerDeviceToken(deviceToken)
        
       
    }
    
    // MARK: - Configuring Beams Push Notification API
    func configureBeamsPushNotifications() {
        self.beamsClient.start(instanceId: "ac1386a2-eac8-4f11-aaab-cad17174260a")
        self.beamsClient.registerForRemoteNotifications()
        try? self.beamsClient.addDeviceInterest(interest: "hello")
        try? self.beamsClient.addDeviceInterest(interest: "debug-hello")
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
