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

class AuthService: ObservableObject {
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
                self.fetchStreamTokenFromFirebase()
                // check if onboarding complete
                self.checkOnboardingStatus(for: user.uid)
            } else {
                self.isOnboardingComplete = false
            }
			
		})
	}
	
	func signOut(completion: ((Result<Void, Error>) -> Void)? = nil) {
		print("Signing the user out")
		AUTH_STATUS_CHECKED_ALREADY = false
		do {
			
			try Auth.auth().signOut()
			completion?(.success(()))
		} catch {
			print("Sign out error: \(error)")
			completion?(.failure(error))
		}
	}


	func login(with verificationCode: String, completion: @escaping (Result<User, Error>) -> Void) {
		
		
		guard let verificationID = getVerificationID() else {
			completion(.failure(GlobalError.cantGetVerificationID))
			return
		}
		
		
		let credential = PhoneAuthProvider.provider().credential(
			withVerificationID: verificationID,
			verificationCode: verificationCode
		)
		
		Auth.auth().signIn(with: credential) { authData, error in
			
            if let error = error/*, let authError = AuthErrorCode(error._code) */{
				//let mappedError = self.mapAuthErrorToAppError(authError)
				completion(.failure(error))
			} else if let user = authData?.user {
			
				self.user = user
				completion(.success(user))
				
				
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

	
    func checkOnboardingStatus(for userID: String) {
            let docRef = Firestore.firestore().collection("users").document(userID)
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    self.isOnboardingComplete = true
                } else {
                    self.isOnboardingComplete = false
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
    func fetchStreamTokenFromFirebase(andUpdate name: String = "", profileImageURL: String = "" ) {
        print("Fetching stream token from firebase ")
        Functions.functions().httpsCallable("ext-auth-chat-getStreamUserToken").call { result, error in
            if let error = error {
                // Handle error
                print("\(error) trying to etchStreamTokenFromFirebase")
                return
            }
            if let token = (result?.data as? [String: Any])?["token"] as? String {
                print("token for fetching stream token \(token)")
                self.connectToStreamChat(with: token, name: name, imageURL: profileImageURL)
            }
        }
    }

    func connectToStreamChat(with token: String, name: String = "", imageURL: String = "") {
        let userId = Auth.auth().currentUser?.uid ?? ""
        

        ChatClient.shared.connectUser(userInfo: .init(id: userId,
                                                      name: name,
                                                      imageURL: URL(string: imageURL)!), token: .init(stringLiteral: token)) { error in
            if let error = error {
                // Handle error
                print("error connecting to chatClient: \(error)")
            }
            // User is now connected to Stream Chat
        }
    }
  


	
	deinit {
		if let listener = authStateDidChangeListenerHandle {
			Auth.auth().removeStateDidChangeListener(listener)
		}
	}
}

