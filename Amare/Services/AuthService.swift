//
//  AuthService.swift
//  Amare
//
//  Created by Micheal Bingham on 7/1/23.
//

import Foundation
import Firebase
import Combine
import FirebaseFirestore
import FirebaseFunctions
import StreamChat
import StreamChatSwiftUI
import FirebaseMessaging

class AuthService: ObservableObject , EventsControllerDelegate{
    
    //This is for the StreamChatSDK so that we can listen to events
    var eventsController: EventsController!
    
    /// Delegate method to detect when a new message is sent to a user
    func eventsController(_ controller: EventsController, didReceiveEvent event: Event) {
        
         
        switch event {
        case let messageNewEvent as MessageNewEvent:
            
            // Check if it's in the "dasha" chat
            
            guard let id = Auth.auth().currentUser?.uid else {   return }
            
            
            guard messageNewEvent.channel.cid.rawValue == "messaging:\(id)-dasha" else {  return }

            // Check if the message is sent by you
            if messageNewEvent.user.id == id {
                // Access the message content
                let message = messageNewEvent.message
                let text = message.text ?? ""
                
                
                // Send to API
                APIService.shared.messageDasha(message: text)
                
                
            }
        default:
            break
        }
    }

    
	private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?

	@Published var user: User?
	
	@Published var isOnboardingComplete: Bool = false
	
	
/// We this variable because our ContentView needs to check `once` if the user is signed in / completed onboarding
	@Published var AUTH_STATUS_CHECKED_ALREADY: Bool = false
	
	static let shared = AuthService()
	
	private init() {
		addAuthListener()
	}
    
	
	private func addAuthListener() {
		if authStateDidChangeListenerHandle != nil {
			return
		}
		
		authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
			self.user = user
            if let user = user {
                
                // check if onboarding complete
                //self.checkOnboardingStatus(for: user.uid)
            } else {
                //self.isOnboardingComplete = false
            }
			
		})
	}
	
	func signOut(completion: ((Result<Void, Error>) -> Void)? = nil) {
		print("Signing the user out")
		AUTH_STATUS_CHECKED_ALREADY = false
		do {
			
			try Auth.auth().signOut()
            logoutChat()
			completion?(.success(()))
		} catch {
			print("Sign out error: \(error)")
			completion?(.failure(error))
		}
	}
    
    private func logoutChat() {
        // Revoke Stream token
        Functions.functions().httpsCallable("ext-auth-chat-revokeStreamUserToken").call { result, error in
            // Handle response or error
        }
        
        
        guard let deviceId = Messaging.messaging().fcmToken /* ChatClient.shared.currentUserController().currentUser?.devices.last?.id */ else {
            return
        }
        
            
            // Disconnect from Stream Chat
            ChatClient.shared.disconnect()
            
            ChatClient.shared.currentUserController().removeDevice(id: deviceId) { error in
                if let error = error {
                    log.warning("removing the device failed with an error \(error)")
                }
            }
        }

       

        

       
    



    func login(with verificationCode: String, completion: @escaping (Result<(User, Bool), Error>) -> Void) {
        
        guard let verificationID = getVerificationID() else {
            completion(.failure(GlobalError.cantGetVerificationID))
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) { authData, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authData?.user {
                self.user = user
                self.checkOnboardingStatus(for: user.uid) { finishedOnBoarding in
                    // Now returning a tuple with User and the onboarding status
                    completion(.success((user, finishedOnBoarding)))
                }
            } else {
                completion(.failure(GlobalError.unknown))
            }
        }
    }

	
	func sendVerificationCode(to phoneNumber: String, completion: @escaping ((Result<Void, Error>) -> Void)) {
		Auth.auth().settings?.isAppVerificationDisabledForTesting = true
		PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
			if let error = error {
				
				
			
					completion(.failure(error))
				
				return
				
			}

			guard let vID = verificationID else {
				completion(.failure(GlobalError.cantGetVerificationID))
				return
			}

			vID.save()
			print("the verificationid in send verification code is .. \(vID)")
			NotificationCenter.default.post(name: NSNotification.verificationCodeSent, object: phoneNumber)
			completion(.success(()))
		}
	}

	
    func checkOnboardingStatus(for userID: String, completion: @escaping (Bool) -> Void) {
            let docRef = Firestore.firestore().collection("users").document(userID)
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    self.isOnboardingComplete = true
                    let name = document.data()?["name"] as? String ?? ""
                    let url = document.data()?["profile_image_url"] as? String ?? ""
                    let username = document.data()?["username"] as? String ?? ""
                    self.fetchStreamTokenFromFirebase(andUpdate: name, profileImageURL: url, username: username)
                    completion((true))
                } else {
                    self.isOnboardingComplete = false
                   
                    completion(false)
                }
            }
        }
	
	/*
	func mapAuthErrorToAppError(_ error: AuthErrorCode) -> Error {
		switch error {
		case .networkError:
			return GlobalError.networkError
		case .tooManyRequests:
			return GlobalError.tooManyRequests
		case .captchaCheckFailed:
			return GlobalError.captchaCheckFailed
		case .invalidPhoneNumber:
			return GlobalError.invalidInput
		case .quotaExceeded:
			return GlobalError.quotaExceeded
		case .operationNotAllowed:
			return GlobalError.notAllowed
		case .internalError:
			return GlobalError.internalError
			
		case .expiredActionCode:
			return AccountError.expiredActionCode
		case .sessionExpired:
			return AccountError.sessionExpired
		case .userTokenExpired:
			return AccountError.userTokenExpired
		case .userDisabled:
			return AccountError.disabledUser
		case .wrongPassword, .invalidVerificationCode, .missingVerificationCode:
			return AccountError.wrong
		default:
			print("Some error happened, likely an unhandled error from firebase : \(error). This happened inside mapAuthErrorCodeToCustomError()")
			return GlobalError.unknown
		}
	}
*/
    
   
/// This fetches the stream Token From Firebase,.. you *also* need to call this whenever we're updating the user's name or profile image url
    func fetchStreamTokenFromFirebase(andUpdate name: String? = nil , profileImageURL: String? = nil, username: String? = nil ) {

        Functions.functions().httpsCallable("ext-auth-chat-getStreamUserToken").call { result, error in
            if let error = error {
                print("Error fetching stream token from Firebase: \(error)")
                return
            }

            // Print the entire result for debugging
            print("Result from Firebase Function: \(String(describing: result?.data))")

            if let token = result?.data as? String {
                print("Token received: \(token)")
                if let name = name, let profileImageURL = profileImageURL {
                    self.connectToStreamChat(with: token, name: name, imageURL: profileImageURL, username: username)
                } else{
                    self.connectToStreamChat(with: token )
                }
               
            } else {
                print("Token not found in result")
            }
        }
    }


    func connectToStreamChat(with token: String, name: String? = nil, imageURL: String? = nil, username: String? = nil) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Firebase user ID not found")
            return
        }
        
        

        if let name = name, let imageURL = imageURL, let url = URL(string: imageURL) {
            // Both name and imageURL are provided
            print("sending in name and image url \(name) image \(url)")
            
            
            ChatClient.shared.connectUser(userInfo: .init(id: username ?? userId, name: name, imageURL: url), token: .init(stringLiteral: token)) { [self] error in
                print("the error connecting in \(error)")
                if error == nil {
                    UNUserNotificationCenter
                            .current()
                            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                                if granted {
                                    DispatchQueue.main.async {
                                        UIApplication.shared.registerForRemoteNotifications()
                                    }
                                }
                            }
                    
                    self.eventsController = ChatClient.shared.eventsController()
                    eventsController.delegate = self
                }
                self.handleConnectionResult(error)
                
            }
            
            
        } else if let name = name {
            // Only name is provided
            print("sending in name")
            ChatClient.shared.connectUser(userInfo: .init(id: userId, name: name), token: .init(stringLiteral: token)) { error in
                self.handleConnectionResult(error)
            }
        } else if let imageURL = imageURL, let url = URL(string: imageURL) {
            // Only imageURL is provided
            print("sending in image url")
            ChatClient.shared.connectUser(userInfo: .init(id: userId,  imageURL: url), token: .init(stringLiteral: token)) { error in
                self.handleConnectionResult(error)
            }
        } else {
            // Neither name nor imageURL is provided
            print("connecting chat user without name or image url ")
            ChatClient.shared.connectUser(userInfo: .init(id: userId), token: .init(stringLiteral: token)) { error in
                self.handleConnectionResult(error)
            }
        }
    }

    private func handleConnectionResult(_ error: Error?) {
        if let error = error {
            // Handle error
            print("Error connecting to chatClient: \(error)")
        }
        // User is now connected to Stream Chat
    }



	
	deinit {
		if let listener = authStateDidChangeListenerHandle {
			Auth.auth().removeStateDidChangeListener(listener)
		}
	}
}

