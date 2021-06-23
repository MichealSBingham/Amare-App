//
//  Account.swift
//  Love
//
//  Created by Micheal Bingham on 6/19/21.
//

import Foundation
import Firebase
import FirebaseAuth
import Combine

/// Class for handling user account related things such as signing in, signing out, listening for auth changes, etc.
class Account: ObservableObject {

    
        var didChange = PassthroughSubject<Account, Never>()
    @Published var user: User? { didSet { self.didChange.send(self) }}
        var handle: AuthStateDidChangeListenerHandle?
    @Published var isSignedIn: Bool = false
    var isListening: Bool = false
    var isListeningForSignOut: Bool = false
    
    /// Sends a verification code to the user's phone number to be used to login or create an account
    /// - Parameters:
    ///   - phoneNumber: Must include country code, ex:  "+19176990590"
    ///   - onSuccess: Completion block to run after code is succesfully sent
    ///   - onFailure: Completion block to run if some error occured. Error is passed in this closure
    ///   - error: `LoginError` passed if `onFailure` completion block is ran
    ///
    /// - Author: Micheal S. Bingham
     func sendVerificationCode(to phoneNumber: String,
                                    andifItWorks onSuccess: (() -> Void)? = nil,
                                    butIfSomeError onFailure: ((_ error: LoginError) -> Void)? = nil ) {
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            
// ============================================  Handling Errors ==============================================================================
            if let error = error{
                
              
                print("\n\nAn error happened when trying to send verification code to phone \(error.localizedDescription)")
                
                if let error = AuthErrorCode(rawValue: error._code){
                    
                    switch error {
                    case .networkError:
                        onFailure!(LoginError.networkError)
                    case .tooManyRequests:
                        onFailure!(LoginError.tooManyRequests)
                    case .captchaCheckFailed:
                        onFailure!(LoginError.captchaCheckFailed)
                    case .userDisabled:
                        onFailure!(LoginError.accountDisabled)
                    case .invalidPhoneNumber:
                        onFailure!(LoginError.invalidInput)
                    default:
                        onFailure!(LoginError.unknown)
                    }
                    
                    return
                    
                } else{
                    
                    onFailure!(LoginError.unknown)
                    return
                }
            
// ============================================  Handling Errors ==============================================================================

                
            
                
            }
            
            guard let vID = verificationID else{
                
                onFailure!(LoginError.cantGetVerificationID)
                
                return
            }
            
            vID.save()
            
            onSuccess?()
            
            
           
        }
    }
    
    
    
    
    /// Logs in the user with the verification code sent via SMS.
    /// - Parameters:
    ///   - verification_code: Verification code SMS sent
    ///   - couldNotLogin: `LoginError `  passed in completion block if some error happened attemtping to sign in
    ///   - error: `LoginError`passed in if could not log in
    ///   - didLogIn: Completion block for when the user successfully signed in.  FirebaseAuth.User object is passed here
    ///   -  user: ` `FIRUser` object of the signed in user
    ///   - onFirstSignIn: Completion block for if either it is the user's first sign in, or they did not complete the sign up flow and should
    /// - Author: Micheal S. Bingham
    /// - TODO: Handle Login Errors, Detect if it is first sign In
     func login(with verification_code: String,
                     failedToLogin couldNotLogin: ((_ error: LoginError) -> Void)? = nil ,
                     afterSuccess  didLogIn: @escaping (_ user: User) -> Void,
                     onFirstSignIn shouldSignUp: (() -> Void)? = nil ) {
        
        // Sign in User
        guard let verificationID = getVerificationID() else{
        
            print("Some Error happened. Can't grab Verification ID.  ")
            
            couldNotLogin!(LoginError.cantGetVerificationID)
            
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verification_code)
        
  
        
        Auth.auth().signIn(with: credential) { authData, error in
            
            if let error = error { // Some error happened
                
                print("Some Error Happened Signing In : \(error.localizedDescription)")
                
                // TODO: Handle Login Errors
                
// ============================================  Handling Errors ==============================================================================

                if let error = AuthErrorCode(rawValue: error._code){
                    
                    switch error {
                    case .networkError:
                        couldNotLogin!(LoginError.networkError)
                    case .tooManyRequests:
                        couldNotLogin!(LoginError.tooManyRequests)
                    case .captchaCheckFailed:
                        couldNotLogin!(LoginError.captchaCheckFailed)
                    case .userDisabled:
                        couldNotLogin!(LoginError.accountDisabled)
                    case .wrongPassword:
                        couldNotLogin!(LoginError.wrongVerificationCode)
                    case .invalidVerificationCode:
                        couldNotLogin!(LoginError.wrongVerificationCode)
                    default:
                        couldNotLogin!(LoginError.unknown)
                    }
                    
                    return
                    
                } else{
                    
                    couldNotLogin!(LoginError.unknown)
                    return
                }
            
                
// ============================================  Handling Errors ==============================================================================

                                
                
            }
            
            if let  user = authData?.user{
                
                // User logged in
                
                print("Inside login function we just set the new user ....  with ID\(user.uid)")
                self.user = user
                print("Now self id is ... \(self.user?.uid)")
              //  self.isSignedIn = true Vould be causing error. Should only do this when .listen()
                if self.isListening{
                    self.isListening = true
                }
                
          // \\//\\     // Check if it is user's first sign in or not \\//\\//\\//\\//\\//\\/
                
                didLogIn(user)
                
            } else{
                
                // Unknown Why
                
                print("Error... for some reason, auth().signIn returned an empty FIRUser object. ")
                
                couldNotLogin!(LoginError.unknown)
                
            }
            
            
            
            
            
    }
    

   
    
}
    
    
    /// Signs the user out
    /// - Parameters:
    ///   - didSignOut: Completion block for when sign out succeeds
    ///   - failure: Complettion block for when sign out fails
    ///   - error: A `NSError` is passed in the `cantSignOut ` block. If sign out fails, it is most likely just a network error.
    /// - Author: Micheal S. Bingham
     func signOut(success didSignOut: () -> Void,
                       cantSignOut failure: (_ error: LoginError) -> Void) {
        
        let firebaseAuth = Auth.auth()
    do {
        
      try firebaseAuth.signOut()
        //self.isSignedIn = false  will casue an error because of navigation links and $boolean values
        if  self.isListening{
            self.isSignedIn = false
        }
        didSignOut()
        
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
        let e = AuthErrorCode(rawValue: signOutError.code)
        switch e {
        case .networkError:
            failure(LoginError.networkError)
        default:
            failure(LoginError.unknown)
        }
        
        failure(LoginError.unknown)
    }
      
    }
    
    
    
    /// Monitors for authentification changes. Uses Firebase.
    func listen () {
            // monitor authentication changes using firebase
        self.isListening = true
        print("Listening...")
            handle = Auth.auth().addStateDidChangeListener { (auth, user) in
                if let user = user {
                    // if we have a user, create a new user model
                    print("Got user: \(user)")
                    self.user = user
                    if self.isListening{
                        self.isSignedIn = true
                    }
                  
                    
                } else {
                    // if we don't have a user, set our session to nil
                    print("No user signed in  detected")
                    self.user = nil
                    
                    NotificationCenter.default.post(name: NSNotification.logout, object: nil)// consider placing this under if statement below
                    
                    if self.isListening{
                        self.isSignedIn = false
                    }
                   
                }
            }
        }
    
    
    /// Monitor a user signing out 
    func listenOnlyForSignOut()  {
        
        // monitor authentication changes using firebase
    self.isListeningForSignOut = true
    print("Listening...")
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if (user == nil)  {
                // if we don't have a user, set our session to nil user is signed out
                print("No user signed in  detected")
                self.user = nil
                
                NotificationCenter.default.post(name: NSNotification.logout, object: nil)// consider placing this under if statement below
                
                if self.isListeningForSignOut{
                    self.isSignedIn = false
                }
               
            }
        }
    }

    /// Unbinds listener so that it is no longer listening for auth changes    
    func stopListening () {
        self.isListening = false
            if let handle = handle {
                print("Just Stopped Listening...")
                Auth.auth().removeStateDidChangeListener(handle)
            }
        }
    
}
