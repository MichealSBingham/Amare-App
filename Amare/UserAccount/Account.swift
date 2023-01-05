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
import FirebaseFirestoreSwift
import SwiftUI
import FirebaseStorage
import PushNotifications
import EasyFirebase


/// Class for handling user account related things such as signing in, signing out, listening for auth changes, adding and reading from the database, etc. An account is associated with one user.
/// Represents operations you can do on backend as an authorized user Account
///  - Warning: If unexpected behavior occurs, set handle, didChange to public
class Account: ObservableObject {

    /// Shared instance of type `Account`
      static let shared = Account()
   
    /// Helper property that assists us in listening to real time changes to certain published attributes of the `Account` object
               private var didChange = PassthroughSubject<Account, Never>()
    /// User object (Firebase- `FIRUSER`). Stores the user id but do not confuse this with the `UserData` object.
    @Published public var user: User? { didSet { self.didChange.send(self) }}
    /// Helper property that assists us in listening to real time changes to certain published attributes of the `Account` object
               private var handle: AuthStateDidChangeListenerHandle?
    ///  Boolean value of whether the current user associated with the `Account` is signed in or not. This is `@Published` so a real-time observer listens for it the state change provided that the `Account` is listening for it.
    @Published public var isSignedIn: Bool = false
    ///  If true, the `isSignedIn` attribute is listening for authentification state changes. This changes to true if `listen()` or `listenOnlyForSignOut()` is called.
               private var isListening: Bool = false
    ///  Whether or not  `Account`  is listening only for sign out changes. Will not update sign in status if this is true but it will update sign out status.
               private  var isListeningForSignOut: Bool = false
    
    /// Reference to the firebase database
    public var db: Firestore?
    
    /// Reference to cloud storage (firebase)
    public var storage: StorageReference?
    let beamsClient = PushNotifications.shared
    

    
    
    
    /// User Data saved to an account object. This won't always have the user's saved data as it is stored in the `Account` object so you must pull the UserData from the dataset first before expecting this attribute to have the updated information.
    @Published var data: AmareUser? = AmareUser()
    
    public var signUpData: AmareUser = AmareUser()
    
    /// Nearby Users that are detected by Nearby Interaction. This is updated in `DiscoverNearbyView` 
    @Published var nearbyUsersByMultipeer =  Set<AmareUser>()
    

    init(){
		
		
    }


    
    
    func is_Signed_In() -> Bool {
        return self.isSignedIn
    }
    
    /// Sends a verification code to the user's phone number to be used to login or create an account
    /// - Parameters:
    ///   - phoneNumber: Must include country code, ex:  "+19176990590"
    ///   - runThisClosure: Closure to run after the verification code was sent (or attempted) with an optional error passed.
    ///   - error: Of type `AccountError`or `GlobalError`. This will be `nil` if a verification code was successfully sent.
    ///
    /// - Author: Micheal S. Bingham
     func sendVerificationCode(to phoneNumber: String,
                               andAfter  runThisClosure: ((_ error: Error?) -> Void)? = nil ) {
         
         Auth.auth().settings?.isAppVerificationDisabledForTesting = true//, enable or disable this for testing
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            
            
            
            
// ============================================  Handling Errors ==============================================================================
            if let error = error{
                
                print("the error is .. \(error)")
                              
                if let error = AuthErrorCode(rawValue: error._code){
                    
                    
                        
                    switch error {
                    case .networkError:
                        runThisClosure!(GlobalError.networkError)
                    case .tooManyRequests:
                        runThisClosure!(GlobalError.tooManyRequests)
                    case .captchaCheckFailed:
                        runThisClosure!(GlobalError.captchaCheckFailed)
                    case .invalidPhoneNumber:
                        runThisClosure!(GlobalError.invalidInput)
                    case .quotaExceeded:
                        runThisClosure!(GlobalError.quotaExceeded)
                    case .operationNotAllowed:
                        runThisClosure!(GlobalError.notAllowed)
                    case .internalError:
                        runThisClosure!(GlobalError.internalError)
                        
                    case .expiredActionCode:
                        runThisClosure!(AccountError.expiredActionCode)
                    case .sessionExpired:
                        runThisClosure!(AccountError.sessionExpired)
                    case .userTokenExpired:
                        runThisClosure!(AccountError.userTokenExpired)
                    case .userDisabled:
                        runThisClosure!(AccountError.disabledUser)
                    case .wrongPassword:
                        runThisClosure!(AccountError.wrong)
                    case .invalidVerificationCode:
                        runThisClosure!(AccountError.wrong)
                    case .missingVerificationCode:
                        runThisClosure!(AccountError.wrong)
                    default:
                        print("Some error happened, likely an unhandled error from firebase : \(error). This happened inside Account.sendVerificationCode()")
                        runThisClosure!(GlobalError.unknown)
                    }
                    
                    return
                    
                } else{
                    print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.sendVerificationCode()")
                    runThisClosure!(GlobalError.unknown)
                    return
                }
            
// ============================================  Handling Errors ==============================================================================

                
            
                
            }
            
            
            guard let vID = verificationID else{
                
                runThisClosure!(GlobalError.cantGetVerificationID)
                
                return
            }
            
            vID.save()
            print("the verificationid in send verification code is .. \(vID)")
            
            NotificationCenter.default.post(name: NSNotification.verificationCodeSent, object: phoneNumber)// consider placing this under if statement below
            runThisClosure!(nil)
            
            
           
        }
    }
    
    
    
    
    
    /// Signs in the user `Account` with the verification code SMS sent to the user's device.
    /// - Parameters:
    ///   - verification_code: SMS code sent to the user
    ///   - runThisClosure: Closure called after SMS is sent (or attempt).
    ///   - error:   `AccountError`  or   `GlobalError` type error if an error happens. Will be `nil` if no error occurred and it was successful.
    ///   - user:  an optional `User` object. Do  not confuse with a `UserData` object. This `User` object is the object returned by Firebase and it contains the unique UID.
    ///   - SignUpState: The first missing peice of data from the sign up process. For example if .name is returned, the user should be taken to the screen to enter his/her name because for some reason it's misssing from the user data. If this is nil it's either done or some other erorr happened. But if .done is returned, the data is complete.
    /// - Author: Mcheal S. Bingham
     func login(with verification_code: String,
                andAfter      runThisClosure:  ((_ error: Error?, _ user: User?, _ signUpState: SignUpState?) -> Void)?  = nil) {
        
        // Sign in User
        guard let verificationID = getVerificationID() else{
            
            print("Login Completion Block 1 ")
            runThisClosure!(GlobalError.cantGetVerificationID, nil, nil)
            
            return
        }
         
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verification_code)
        
  
        
        Auth.auth().signIn(with: credential) { authData, error in
            
            
            if let error = error { // Some error happened
                                
                // TODO: Handle Login Errors
                print("The error is ...\(error) with code .. \(error._code)")
// ============================================  Handling Errors ==============================================================================

                if let error = AuthErrorCode(rawValue: error._code){
                    
                    switch error {
                        
                        // Handle Global Errors
                    case .networkError:
                        print("Login Completion Block 2 ")
                        runThisClosure!(GlobalError.networkError, nil, nil)
                        return
                    case .tooManyRequests:
                        print("Login Completion Block 3")
                        runThisClosure!(GlobalError.tooManyRequests, nil, nil)
                        return
                    case .captchaCheckFailed:
                        print("Login Completion Block 4 ")
                        runThisClosure!(GlobalError.captchaCheckFailed, nil, nil)
                        return
                    case .invalidPhoneNumber:
                        print("Login Completion Block 5 ")
                        runThisClosure!(GlobalError.invalidInput, nil, nil)
                        return
                    case .quotaExceeded:
                        print("Login Completion Block 6 ")
                        runThisClosure!(GlobalError.quotaExceeded, nil, nil)
                        return
                    case .operationNotAllowed:
                        print("Login Completion Block 7 ")
                        runThisClosure!(GlobalError.notAllowed, nil, nil)
                        return
                    case .internalError:
                        print("Login Completion Block 8 ")
                        runThisClosure!(GlobalError.internalError, nil, nil)
                        return
                        
                        // Handle Account Errors
                    case .expiredActionCode:
                        print("Login Completion Block 9 ")
                        runThisClosure!(AccountError.expiredActionCode, nil, nil)
                        return
                    case .sessionExpired:
                        print("Login Completion Block 10 ")
                        runThisClosure!(AccountError.sessionExpired, nil, nil)
                        return
                    case .userTokenExpired:
                        print("Login Completion Block 11 ")
                        runThisClosure!(AccountError.userTokenExpired, nil, nil)
                        return
                    case .userDisabled:
                        print("Login Completion Block 12 ")
                        runThisClosure!(AccountError.disabledUser, nil, nil)
                        return
                    case .wrongPassword:
                        print("Login Completion Block 13 ")
                        runThisClosure!(AccountError.wrong, nil, nil)
                        return
                    case .invalidVerificationCode:
                        print("Login Completion Block 14 ")
                        runThisClosure!(AccountError.wrong, nil, nil )
                        return
                    case .missingVerificationCode:
                        print("Login Completion Block 15 ")
                        runThisClosure!(AccountError.wrong, nil , nil )
                        return
                    default:
                        print("Login Completion Block 16 ")
                        print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.login()")
                        runThisClosure!(GlobalError.unknown, nil, nil)
                        return
                    }
                    
                   return
                    
                } else{
                    print("Login Completion Block 17 ")
                    print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.login()")
                    runThisClosure!(GlobalError.unknown, nil, nil)
                    return
                }
            
                
// ============================================  Handling Errors ==============================================================================

                                
                
            }
            
            if let  user = authData?.user{
                
                // User is logged in
                
                self.user = user
                self.data?.id = user.uid // won't set if data is nil already which it is likely unless the account signed in already
                
                if self.isListening{ // only if it's listening should you change the sign in status
                     self.isSignedIn = true
                        
                 }
                
                self.getUserData { [self] error, amare_user  in
                    
                    guard error == nil else {
                        // Handle Errors Now...
                        
                        
                      
                        // Check if it's an AccountError or global error
                        
                        if let error = error as? AccountError{
                            // It's an account error
                            if error == .doesNotExist{ // it's the user's first sign in
                                print("Login Completion Block 18 ")
                                runThisClosure!(nil, user, .name)
                                return
                            } else {
                                // It was some other account error
                                print("Login Completion Block 19 ")
                                runThisClosure!(error, nil, nil)
                                return
                            }
                        }
                        
                        
                        
                        
                        if let error = error as? GlobalError{
                            // It's a global error so pass the error
                            print("Login Completion Block 20 ")
                           runThisClosure!(error, nil, nil )
                            return
                        }
                            
                        print("Login Completion Block 21 ")
                        print("There was some error get user data .. \(error?.localizedDescription) ")
                        runThisClosure!(GlobalError.unknown, nil, nil)

                        // Otherwise we don't know what error it is so just let it be a global error
                        
                        return
                        
                    }
                    
                    
                    // No Error occured
                  
                  
                    guard (self.data?.isComplete() ?? false) else{
                        
                        // The user data isn't complete so should go to the sign up state
                        // Means the user did not finish signing up
                        self.data = data
                        Account.shared.data = data
                        print("Login Completion Block 22 ")
                        runThisClosure!(nil, user, data?.getFirstNilInSignUpState())
    
                        return
                        
                    }
                   
                  // Otherwise sign in the user. False because it finished signing up and doesn't need to be taken to the sign up state
                    self.data = data
                    Account.shared.data = data
                    print("Login Completion Block 23 ")
                    runThisClosure!(nil, user, .done )
                    
                   return
                }
                
                
               
                
            } else{
                
                // Unknown Why
                
                print("\n\n Some error happened. Error... for some reason, auth().signIn returned an empty FIRUser object. Unknown Global Error")
                print("Login Completion Block 24 ")
                runThisClosure!(GlobalError.unknown, nil, nil)
                return
                
            }
            
            
            
            
            
    }
    

   
    
}
    
    
    /// Signs the user out of the account
    /// - Parameters:
    ///   - completion: Closure ran after sign out is called.
    ///   - error: An `AccountError` or `GlobalError` passed . If the sign out is successful, this will be `nil`.
    /// - Author: Micheal S. Bingham
     func signOut(_ completion: ((_ error: Error?) -> Void )? = nil ) {
        
        let firebaseAuth = Auth.auth()
    do {
        
      try firebaseAuth.signOut()
        if  self.isListening{
            self.isSignedIn = false
        }
        //clear verification code
    
        UserDefaults.standard.removeObject(forKey: "authVerificationID")
        UserDefaults.standard.reset()
        NotificationCenter.default.post(name: NSNotification.logout, object: nil)
        try? self.beamsClient.clearDeviceInterests()
        completion?(nil)
        return
        
    } catch let signOutError as NSError {
    
        let e = AuthErrorCode(rawValue: signOutError.code)
        
        
        switch e {
            
            // Handle Global Errors
        case .networkError:
            completion?(GlobalError.networkError)
        case .tooManyRequests:
            completion?(GlobalError.tooManyRequests)
        case .operationNotAllowed:
            completion?(GlobalError.notAllowed)
        case .internalError:
            completion?(GlobalError.internalError)
            
            // Handle Account Errors
        case .userDisabled:
            completion?(AccountError.disabledUser)
        default:
            print ("Some Error happened signing out: %@", signOutError)
            completion?(GlobalError.unknown)
        }
        
        print ("Some Error happened signing out: %@", signOutError)
        completion?(GlobalError.unknown)
        return
    }
      
    }
    
    
    
    /// Monitors for authentification changes by adding an observer to `.isSignedIn`. Uses Firebase. Call this before expecting `.isSignedIn`. to update in realtime.
    /// - Author: Micheal S. Bingham
    func listen () {
            // monitor authentication changes using firebase
        print("Listening on \(self.user?.uid)")
        self.isListening = true
            handle = Auth.auth().addStateDidChangeListener { (auth, user) in
                
                if let user = user {
                    // if we have a user, create a new user model
                    print("user is signed in ... ")
                    self.user = user
                  //  if self.isListening{
                       print("Setting to true..")
                        self.isSignedIn = true
                  //  }
                  
                    
                } else {
                    // if we don't have a user, set our session to nil
                    self.user = nil
                    
                    NotificationCenter.default.post(name: NSNotification.logout, object: nil)// consider placing this under if statement below
                    
                    if self.isListening{
                        self.isSignedIn = false
                    }
                   
                }
            }
        }
    
    
    /// Similiar to `listen()` but instead the observer is only activated when the user signs out so the user signing in won't update the attribute .
    /// - Author: Micheal S. Bingham
    func listenOnlyForSignOut()  {
        
        // monitor authentication changes using firebase
    self.isListeningForSignOut = true
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if (user == nil)  {
                // if we don't have a user, set our session to nil user is signed out
                self.user = nil
                
                NotificationCenter.default.post(name: NSNotification.logout, object: nil)// consider placing this under if statement below
                
                if self.isListeningForSignOut{
                    self.isSignedIn = false
                }
               
            }
        }
    }

    /// Unbinds listener so that it is no longer listening for auth changes    
   /// - Author: Micheal S. Bingham
    func stopListening () {
        self.isListening = false
            if let handle = handle {
                Auth.auth().removeStateDidChangeListener(handle)
            }
        }
    
    /// Reads the user data /in real time/  from the database and saves it in the object (Saves it to `account.data`). l. Assigns a `UserData` object to `self.data`. This will make the userdata subscribe to changes
    /// - Parameter completion: Completion block ran after an attempt to fetch the user data beloning to the `Account`
    /// - Parameter error: Will be nil if it was successful or an error of type `AccountError` or `GlobalError` will be passed.
    /// - Author: Micheal S. Bingham
    func getUserData(completion:( (_ err: Error?, _ data: AmareUser? ) -> Void)?  = nil )  {
        
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
    
        
        guard let id  = Auth.auth().currentUser?.uid else {
            
            
            completion?(AccountError.notSignedIn, nil)
            
            return
        }
        
        DB.collection("users").document(id)
            .getDocument { document, error in
            
            guard error == nil else{
                // Handle these errors....
                
                if let error = AuthErrorCode(rawValue: error?._code ?? 17999){
                    
                    switch error {
                        
                        // Handle Global Errors
                    case .networkError:
                        completion?(GlobalError.networkError, nil)
                    case .tooManyRequests:
                        completion?(GlobalError.tooManyRequests, nil)
                    case .captchaCheckFailed:
                        completion?(GlobalError.captchaCheckFailed, nil)
                    case .quotaExceeded:
                        completion?(GlobalError.quotaExceeded, nil)
                    case .operationNotAllowed:
                        completion?(GlobalError.notAllowed, nil)
                    case .internalError:
                        print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.getUserData()")
                        completion?(GlobalError.internalError, nil)
                        
                        // Handle Account Errors
                    case .expiredActionCode:
                        completion?(AccountError.expiredActionCode, nil)
                    case .sessionExpired:
                        completion?(AccountError.sessionExpired, nil)
                    case .userTokenExpired:
                        completion?(AccountError.userTokenExpired, nil)
                    case .userDisabled:
                        completion?(AccountError.disabledUser, nil)
                    case .wrongPassword:
                        completion?(AccountError.wrong, nil)
                    default:
                        print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.getUserData()")
                        completion?(GlobalError.unknown, nil)
                    }
                    
                   return
                    
                } else{
                    
                    print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.getUserData()")
                    completion?(GlobalError.unknown, nil)
                    return
                }
            
                
                
            }
            
                if let document = document {
                
                    guard document.exists else { self.data = nil; completion?(nil, nil); return}
                
                let result = Result {
                    try document.data(as: AmareUser.self)
                }
                
                switch result {
                
                
                case .success(let data):
                    
                    if  data != nil{
                        
                        // Data object contains all of the user's data
                        self.data = data
                        Account.shared.data = data
                        completion?(nil, data)
                        
                        
                    } else{
                        
                        // Could not retreive the data for some reason
                        completion?(AccountError.doesNotExist, nil)
                    }
                    
                
                case .failure(let error):
                    // Handle errors
                    print("Some error happened trying to convert the user data to a User Data object: \(error.localizedDescription)")
                    completion?(GlobalError.unknown, nil)
              
                }

                
                
                
                } else {
                    // User does not exist
                    completion?(AccountError.doesNotExist, nil)
                }
            
            
            return
        }
        
    }
    
    
    /// Reads the user data once from the database and returns it
    /// - Parameter completion: Completion block ran after an attempt to fetch the user data beloning to the `Account`
    /// - Parameter error: Will be nil if it was successful or an error of type `AccountError` or `GlobalError` will be passed.
    /// - Author: Micheal S. Bingham
    func getOtherUser(from id: String, completion:( ( _ user: AmareUser? , _ err: Error?) -> Void)?  = nil )  {
        
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
    
        /*
        guard let id  = self.user?.uid else {
            
            completion?(AccountError.notSignedIn)
            
            return
        }
        */
        
        DB.collection("users").document(id).getDocument { document, error in
            
            guard error == nil else{
                // Handle these errors....
                
                if let error = AuthErrorCode(rawValue: error?._code ?? 17999){
                    
                    switch error {
                        
                        // Handle Global Errors
                    case .networkError:
                        completion?(nil, GlobalError.networkError)
                    case .tooManyRequests:
                        completion?(nil, GlobalError.tooManyRequests)
                    case .captchaCheckFailed:
                        completion?(nil, GlobalError.captchaCheckFailed)
                    case .quotaExceeded:
                        completion?(nil, GlobalError.quotaExceeded)
                    case .operationNotAllowed:
                        completion?(nil, GlobalError.notAllowed)
                    case .internalError:
                        print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.getUserData()")
                        completion?(nil, GlobalError.internalError)
                        
                        // Handle Account Errors
                    case .expiredActionCode:
                        completion?(nil, AccountError.expiredActionCode)
                    case .sessionExpired:
                        completion?(nil, AccountError.sessionExpired)
                    case .userTokenExpired:
                        completion?(nil, AccountError.userTokenExpired)
                    case .userDisabled:
                        completion?(nil, AccountError.disabledUser)
                    case .wrongPassword:
                        completion?(nil, AccountError.wrong)
                    default:
                        print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.getUserData()")
                        completion?(nil, GlobalError.unknown)
                    }
                    
                   return
                    
                } else{
                    
                    print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.getUserData()")
                    completion?(nil, GlobalError.unknown)
                    return
                }
            
                
                
            }
            
            if let document = document, document.exists {
                
                  
                
                let result = Result {
                    try document.data(as: AmareUser.self)
                }
                
                switch result {
                
                
                case .success(let data):
                    
                    if  data != nil{
                        
                       
                        completion?(data, nil)
                        
                        
                    } else{
                        
                        // Could not retreive the data for some reason
                        completion?(nil, AccountError.doesNotExist)
                    }
                    
                
                case .failure(let error):
                    // Handle errors
                    print("Some error happened trying to convert the user data to a User Data object: \(error.localizedDescription)")
                    completion?(nil, GlobalError.unknown)
              
                }

                
                
                
                } else {
                    // User does not exist
                    completion?(nil, AccountError.doesNotExist)
                }
            
            
            return
        }
        
    }
    /// Reads the public user data from a particular id
    /// - Parameter completion: Completion block ran after an attempt to fetch the user data beloning to the `Account`
    /// - Parameter error: Will be nil if it was successful or an error of type `AccountError` or `GlobalError` will be passed.
    /// - Author: Micheal S. Bingham
    func getPublicData(from id: String, completion: ( (_ err: Error?, _ user: AmareUser?) -> Void)?  = nil )  {
        
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
    
        DB.collection("users").document(id).collection("public").document("publicData").getDocument { document, error in
            
            guard error == nil else{
                // Handle these errors....
                
                if let error = AuthErrorCode(rawValue: error?._code ?? 17999){
                    
                    switch error {
                        
                        // Handle Global Errors
                    case .networkError:
                        completion?(GlobalError.networkError, nil )
                    case .tooManyRequests:
                        completion?(GlobalError.tooManyRequests, nil )
                    case .captchaCheckFailed:
                        completion?(GlobalError.captchaCheckFailed, nil )
                    case .quotaExceeded:
                        completion?(GlobalError.quotaExceeded, nil )
                    case .operationNotAllowed:
                        completion?(GlobalError.notAllowed, nil )
                    case .internalError:
                        print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.getUserData()")
                        completion?(GlobalError.internalError, nil )
                        
                        // Handle Account Errors
                    case .expiredActionCode:
                        completion?(AccountError.expiredActionCode, nil )
                    case .sessionExpired:
                        completion?(AccountError.sessionExpired, nil )
                    case .userTokenExpired:
                        completion?(AccountError.userTokenExpired, nil )
                    case .userDisabled:
                        completion?(AccountError.disabledUser, nil )
                    case .wrongPassword:
                        completion?(AccountError.wrong, nil )
                    default:
                        print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.getUserData()")
                        completion?(GlobalError.unknown, nil )
                    }
                    
                   return
                    
                } else{
                    
                    print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.getUserData()")
                    completion?(GlobalError.unknown, nil )
                    return
                }
            
                
                
            }
            
            if let document = document, document.exists {
                
                  
                
                let result = Result {
                    try document.data(as: AmareUser.self)
                }
                
                switch result {
                
                
                case .success(let data):
                    
                    if  data != nil {
                        
                        // Data object contains all of the user's data
                
                        completion?(nil, data)
                        
                        
                    } else{
                        
                        // Could not retreive the data for some reason
                        completion?(AccountError.doesNotExist, nil )
                    }
                    
                
                case .failure(let error):
                    // Handle errors
                    print("Some error happened trying to convert the user data to a User Data object: \(error.localizedDescription)")
                    completion?(GlobalError.unknown, nil )
              
                }

                
                
                
                } else {
                    // User does not exist
                    completion?(AccountError.doesNotExist, nil )
                }
            
            
            return
        }
        
    }
    
    /// THIS WILL GET ALL OF THE USERS IN THE DATABASE USE THIS WITH CARE.
    func getALLusers( real: Bool = true, completion: ( (_ err: Error?, _ users: [AmareUser]) -> Void)?  = nil) -> Void  {
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
        let uid = Auth.auth().currentUser?.uid ?? ""
        
        DB.collection(!real ? "generated_users": "users")
           .whereField("isReal", isNotEqualTo: false)
           // .whereField("uid", isNotEqualTo: uid)
           .limit(to: 5)
            .getDocuments { snapshot, error in
            
            if let error = error {
                completion!(error, [])
                return
            }
            
            var users: [AmareUser] = []
            for document in snapshot!.documents{
                print("\n\n\n\n\nThe document data is ...\(document.data())")
                let result = Result {
                    try document.data(as: AmareUser.self)
                }
                
                switch result {
                
                
                case .success(var user):
                    
                    if  user != nil {
                        user.id = document.documentID
                        //print("\n\n\n\n\n\n***The document object is .. \(document.data())")
                        // Data object contains all of the user's data
                      
                        // append it
                        /*
                        self.getNatalChart(from: user.id ?? "hello", pathTousers: "generated_users") { err, natalChart in
                            if let natal_chart = natalChart{
                                //user.natal_chart = natal_chart
                                
                            }
                            
                          //  print("appending \(user) to \(users)")
                            users.append(user)
                          //  print("the count of users appendedare ... \(users.count)")
                            
                        }
                        */
                       // guard user.isReal ?? false else {return}
                        
                        if user.id != uid {
                            users.append(user)
                        }
                        

                        
                        
                    } else{
                        
                        // Could not retreive the data for some reason
                        return
                    }
                    
                
                case .failure(let error):
                    // Handle errors
                    print("Some error happened trying to convert the user data to a User Data object: \(error.localizedDescription)")
                    continue
                  //  return
              
                }

                
            }
            print("Running completed block with \(users.count) users")
            completion!(nil, users)
            
            
        }
        
        
        
    }
    
    
    
    func getAllCustomUserChartsThisUserMade(  completion: ( (_ err: Error?, _ users: [AmareUser]) -> Void)?  = nil) -> Void  {
        
        var DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
        _ = Auth.auth().currentUser?.uid ?? ""
        
        DB.collection("users")
           .whereField("isReal", isNotEqualTo: true)
           .limit(to: 5)
            .getDocuments { snapshot, error in
            
            if let error = error {
                completion!(error, [])
                return
            }
            
            var users: [AmareUser] = []
            for document in snapshot!.documents{
                print("\n\n\n\n\nThe document data is ...\(document.data())")
                let result = Result {
                    try document.data(as: AmareUser.self)
                }
                
                switch result {
                
                
                case .success(var user):
                    
                    if  user != nil {
                        user.id = document.documentID
                        
                        
                      
                            users.append(user)
                        
                        
                        
                    } else{
                        
                        // Could not retreive the data for some reason
                        return
                    }
                    
                
                case .failure(let error):
                    // Handle errors
                    print("Some error happened trying to convert the user data to a User Data object: \(error.localizedDescription)")
                    continue
                  //  return
              
                }

                
            }
            print("Running completed block with \(users.count) users")
            completion!(nil, users)
            
            
        }
        
        
        
    }
    
    
    
    /// Returns the natal chart for a public arbitary user specified by id
    /// - Parameters:
    ///   - id: ID of the user
    ///   - pathTousers: By default 'users' only change if you're collecting the users from a different collection, like `generated_users`
    ///   - isOuterChart: False by default. This will make sure the planets and other luminary bodies returned have the attribute`forSynastry` marked true. (useful for the `NatalChartView`
    ///   - completion: Returns the error and natal chart
    func getNatalChart(from id: String, pathTousers: String = "users", isOuterChart: Bool? = false, completion: ( (_ err: Error?, _ natalChart: NatalChart?) -> Void)?  = nil )  {
        
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
    
        DB.collection(pathTousers).document(id).collection("public").document("natal_chart").getDocument { document, error in
            
            guard error == nil else{
                // Handle these errors....
                
                if let error = AuthErrorCode(rawValue: error?._code ?? 17999){
                    
                    switch error {
                        
                        // Handle Global Errors
                    case .networkError:
                        completion?(GlobalError.networkError, nil )
                    case .tooManyRequests:
                        completion?(GlobalError.tooManyRequests, nil )
                    case .captchaCheckFailed:
                        completion?(GlobalError.captchaCheckFailed, nil )
                    case .quotaExceeded:
                        completion?(GlobalError.quotaExceeded, nil )
                    case .operationNotAllowed:
                        completion?(GlobalError.notAllowed, nil )
                    case .internalError:
                        print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.getUserData()")
                        completion?(GlobalError.internalError, nil )
                        
                        // Handle Account Errors
                    case .expiredActionCode:
                        completion?(AccountError.expiredActionCode, nil )
                    case .sessionExpired:
                        completion?(AccountError.sessionExpired, nil )
                    case .userTokenExpired:
                        completion?(AccountError.userTokenExpired, nil )
                    case .userDisabled:
                        completion?(AccountError.disabledUser, nil )
                    case .wrongPassword:
                        completion?(AccountError.wrong, nil )
                    default:
                        print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.getUserData()")
                        completion?(GlobalError.unknown, nil )
                    }
                    
                   return
                    
                } else{
                    
                    print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.getUserData()")
                    completion?(GlobalError.unknown, nil )
                    return
                }
            
                
                
            }
            
            if let document = document, document.exists {
                
                  
                
                let result = Result {
                    try document.data(as: NatalChart.self)
                }
                
                switch result {
                
                
                case .success(var data):
                    
                    if  data != nil {
                        
                        // Data object contains all of the user's data
                        
                        // Mark all of the planets and angles as being used for synastry...
                        for (index, _) in data.planets.enumerated() {
                            data.planets[index].forSynastry = isOuterChart
                        }
                        
                        for (index, _) in data.angles.enumerated() {
                            data.angles[index].forSynastry = isOuterChart
                        }
                        
                        
                        completion?(nil, data)
                        
                        
                    } else{
                        
                        // Could not retreive the data for some reason
                        completion?(AccountError.doesNotExist, nil )
                    }
                    
                
                case .failure(let error):
                    // Handle errors
                    print("Some error happened trying to convert the user data to a User Data object: \(error.localizedDescription)")
                    completion?(GlobalError.unknown, nil )
              
                }

                
                
                
                } else {
                    // User does not exist
                    completion?(AccountError.doesNotExist, nil )
                }
            
            
            return
        }
        
    }

    
    
    /// Sets and updates user data to the account in the database. Will not override if nil data is provided. 
    /// - Parameters:
    ///   - data: `UserData` object that contains profile information. See `UserData`
    ///   - completion: Will pass an error otherwise nil if it is successful
    ///   - error: Of type `AccountError` or `GlobalError`
    ///   -  Warning: Do not try to add images (with the exception of the profile image) to the Account this way. Use `upload()`.
    ///   - isTheSignedInUser: Default true. Only change this to `false` if this data does not belong (describe) the signed in user but instead you're creating a new amare user data. Typically for custom natal charts that users add
    func set(data: AmareUser, isTheSignedInUser: Bool = true, completion:( (_ error: Error?, _ uid: String?) -> () )? = nil )  {
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
       
         
        
        if let uid = (isTheSignedInUser ? self.user?.uid :  UUID().uuidString)   {
            
         
           
            
            
            do {
                
               
               try DB.collection("users").document(uid).setData(from: data, merge: true) { error in
                    
                   
                   guard error == nil else {
                   // Handling the error
                   if let error = AuthErrorCode(rawValue: error?._code ?? 17999){
                       
                       switch error {
                           
                           // Handle Global Errors
                       case .networkError:
                           completion?(GlobalError.networkError, nil)
                       case .tooManyRequests:
                           completion?(GlobalError.tooManyRequests, nil )
                       case .captchaCheckFailed:
                           completion?(GlobalError.captchaCheckFailed, nil )
                       case .quotaExceeded:
                           completion?(GlobalError.quotaExceeded, nil)
                       case .operationNotAllowed:
                           completion?(GlobalError.notAllowed, nil)
                       case .internalError:
                           print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.set()")
                           completion?(GlobalError.internalError, nil)
                           
                           // Handle Account Errors
                       case .expiredActionCode:
                           completion?(AccountError.expiredActionCode, nil )
                       case .sessionExpired:
                           completion?(AccountError.sessionExpired, nil)
                       case .userTokenExpired:
                           completion?(AccountError.userTokenExpired, nil)
                       case .userDisabled:
                           completion?(AccountError.disabledUser, nil)
                       case .wrongPassword:
                           completion?(AccountError.wrong, nil)
                       default:
                           print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.set()")
                           completion?(GlobalError.unknown, nil)
                       }
                       
                      return
                       
                   } else{
                       
                       print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.set()")
                       completion?(GlobalError.unknown, nil)
                       return
                   }
                   
                    
            
                       
               }
                   
                   completion!(nil, uid)
                }
                
            } catch let error{
                
                if let error = AuthErrorCode(rawValue: error._code ){
                    
                    switch error {
                        
                        // Handle Global Errors
                    case .networkError:
                        completion?(GlobalError.networkError, nil)
                    case .tooManyRequests:
                        completion?(GlobalError.tooManyRequests, nil)
                    case .captchaCheckFailed:
                        completion?(GlobalError.captchaCheckFailed, nil)
                    case .quotaExceeded:
                        completion?(GlobalError.quotaExceeded, nil)
                    case .operationNotAllowed:
                        completion?(GlobalError.notAllowed, nil)
                    case .internalError:
                        print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.login()")
                        completion?(GlobalError.internalError, nil)
                        
                        // Handle Account Errors
                    case .expiredActionCode:
                        completion?(AccountError.expiredActionCode, nil)
                    case .sessionExpired:
                        completion?(AccountError.sessionExpired, nil)
                    case .userTokenExpired:
                        completion?(AccountError.userTokenExpired, nil)
                    case .userDisabled:
                        completion?(AccountError.disabledUser, nil)
                    case .wrongPassword:
                        completion?(AccountError.wrong, nil)
                    default:
                        print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.login()")
                        completion?(GlobalError.unknown, nil)
                    }
                    
                   return
                    
                } else{
                    
                    print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.login()")
                    completion?(GlobalError.unknown, nil)
                    return
                }
                
                
            //    completion?(error)
                
                
                
            }
            
            
            
            
        } else{
            
            completion?(AccountError.notSignedIn, nil)
            
            
        }
        
       
        
    }
    
    
    
    
    /// Saves and updates user data to the account in the database. Will not override if nil data is provided. The difference between this and `set()` is that this uses the `UserData` that the   `Account` object is already holding as its `self.data` property
    /// - Parameters:
    ///   - completion: You do not need to use this as it's optional and you can acheive same functionality by just catching the error that's thrown.Will pass an error otherwise nil if it is successful. This competion block is optional because the function will throw an error of `AccountError` or `GlobalError` type.
    ///  - Throws: `AccountError` or `GlobalError `
    ///  - Note: Just do save(),  and catch for any errors using the completion block is unnecessary.
    ///  - Author: Micheal S. Bingham
    func save( completion:( (_ error: Error?) -> () )? = nil ) throws {
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
        
        if let uid = self.user?.uid{
            
            self.data?.id = uid
         
            
            
            do {
                
                
                try DB.collection("users").document(uid).setData(from: self.data, merge: true) { error in

                   // No error
                    completion?(nil)
                    
                }
                
            } catch let error{
                
                
                if let error = AuthErrorCode(rawValue: error._code ){
                    
                    switch error {
                        
                        // Handle Global Errors
                    case .networkError:
                        completion?(GlobalError.networkError)
                        throw GlobalError.networkError
                    case .tooManyRequests:
                        completion?(GlobalError.tooManyRequests)
                        throw GlobalError.tooManyRequests
                    case .captchaCheckFailed:
                        completion?(GlobalError.captchaCheckFailed)
                        throw GlobalError.captchaCheckFailed
                    case .quotaExceeded:
                        completion?(GlobalError.quotaExceeded)
                        throw GlobalError.quotaExceeded
                    case .operationNotAllowed:
                        completion?(GlobalError.notAllowed)
                        throw GlobalError.notAllowed
                    case .internalError:
                        print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.login()")
                        completion?(GlobalError.internalError)
                        throw GlobalError.internalError
                        
                        // Handle Account Errors
                    case .expiredActionCode:
                        completion?(AccountError.expiredActionCode)
                        throw AccountError.expiredActionCode
                    case .sessionExpired:
                        completion?(AccountError.sessionExpired)
                        throw AccountError.sessionExpired
                    case .userTokenExpired:
                        completion?(AccountError.userTokenExpired)
                        throw AccountError.userTokenExpired
                    case .userDisabled:
                        completion?(AccountError.disabledUser)
                        throw AccountError.disabledUser
                    case .wrongPassword:
                        completion?(AccountError.wrong)
                        throw AccountError.wrong
                    default:
                        print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.login()")
                        completion?(GlobalError.unknown)
                        throw GlobalError.unknown
                    }
                    
                   
                    
                } else{
                    
                    print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.login()")
                    completion?(GlobalError.unknown)
                    throw GlobalError.unknown
                    
                }
                
                
            }
            
            
            
            
        } else{
            
    
            completion?(AccountError.notSignedIn)
            throw AccountError.notSignedIn
            
        }
        
       
        
    }
    
    
	/// Creates  user data to the account in the database. Will not override if nil data is provided. The difference between this and `save()` is that this is for creating user data not updating it. 
	/// - Parameters:
	///   - completion: You do not need to use this as it's optional and you can acheive same functionality by just catching the error that's thrown.Will pass an error otherwise nil if it is successful. This competion block is optional because the function will throw an error of `AccountError` or `GlobalError` type.
	///  - Throws: `AccountError` or `GlobalError `
	///  - Note: Just do save(),  and catch for any errors using the completion block is unnecessary.
	///  - Author: Micheal S. Bingham
	func create( completion:( (_ error: Error?) -> () )? = nil ) throws {
		
		let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
		self.db = DB
		
		
		if let uid = self.user?.uid{
			
			self.data?.id = uid
		 
			
			
			do {
				
				
				try DB.collection("users").document(uid).setData(from: self.data, merge: true) { error in

				   // No error
					completion?(nil)
					
				}
				
            } catch let error{
				
				
                if let error = AuthErrorCode(rawValue: error._code ){
					
					switch error {
						
						// Handle Global Errors
					case .networkError:
						completion?(GlobalError.networkError)
						throw GlobalError.networkError
					case .tooManyRequests:
						completion?(GlobalError.tooManyRequests)
						throw GlobalError.tooManyRequests
					case .captchaCheckFailed:
						completion?(GlobalError.captchaCheckFailed)
						throw GlobalError.captchaCheckFailed
					case .quotaExceeded:
						completion?(GlobalError.quotaExceeded)
						throw GlobalError.quotaExceeded
					case .operationNotAllowed:
						completion?(GlobalError.notAllowed)
						throw GlobalError.notAllowed
					case .internalError:
						print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.login()")
						completion?(GlobalError.internalError)
						throw GlobalError.internalError
						
						// Handle Account Errors
					case .expiredActionCode:
						completion?(AccountError.expiredActionCode)
						throw AccountError.expiredActionCode
					case .sessionExpired:
						completion?(AccountError.sessionExpired)
						throw AccountError.sessionExpired
					case .userTokenExpired:
						completion?(AccountError.userTokenExpired)
						throw AccountError.userTokenExpired
					case .userDisabled:
						completion?(AccountError.disabledUser)
						throw AccountError.disabledUser
					case .wrongPassword:
						completion?(AccountError.wrong)
						throw AccountError.wrong
					default:
						print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.login()")
						completion?(GlobalError.unknown)
						throw GlobalError.unknown
					}
					
				   
					
				} else{
					
					print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.login()")
					completion?(GlobalError.unknown)
					throw GlobalError.unknown
					
				}
				
				
			}
			
			
			
			
		} else{
			
	
			completion?(AccountError.notSignedIn)
			throw AccountError.notSignedIn
			
		}
		
	   
		
	}
    
    /// Uploads an image to the database for the user.
    /// - Parameters:
    ///   - image: UIImage to upload
    ///   - isProfileImage: Whether or not we should set this image as the user's profile image
    ///   - completion: An `AccountError` , `SystemError` or `GlobalError` could be passed here but will be nil if it was a success
    func upload(image: UIImage, isProfileImage: Bool = false, completion: @escaping ( (_ error: Error?) -> () ))  {
        
        guard let userid = self.user?.uid else {
            
            // There is no signed in user, throw error or pass in handler
            completion(AccountError.notSignedIn)
            return
        }
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
       // Get reference to cloud storage
      //  let ref =  (self.storage == nil) ? Storage.storage().reference()   :  self.storage!
        let ref = Storage.storage(url: "gs://findamare.appspot.com").reference()
        self.storage = ref
        
      //  Auth().currentUser?.reauthenticate(with: <#T##AuthCredential#>, completion: <#T##((AuthDataResult?, Error?) -> Void)?##((AuthDataResult?, Error?) -> Void)?##(AuthDataResult?, Error?) -> Void#>)
        let nameOfImage = isProfileImage ? "profile_image_\(UUID.init().uuidString).jpg" : "\(UUID.init().uuidString).jpg"
        
        print("***name of the image .. \(nameOfImage)")
        
        let uploadRef = ref.child("users").child(userid).child("images").child(nameOfImage)
        
        print("***image uplaod ref is ... \(uploadRef)")
        
       
        guard let imageData = image.jpegData(compressionQuality: 1) else { completion(SystemError.imageCompress) ; print("can't get image data"); /* Some error compresing the  image */ return  }
        
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
		
		EasyStorage.put(imageData, to: StorageResource(id: userid)) { url in
			
			guard let url = url else {
				
				Account.shared.signUpData.profile_image_url = "https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cG9ydHJhaXR8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60"

				completion(nil)
				return
			}
			

			Account.shared.signUpData.profile_image_url = url.absoluteString
			completion(nil)
		}
        
   
	
        
        
    }
    
  
    /// Uploads an image to the database and return the link to it
    /// - Parameters:
    ///   - image: UIImage to upload
    ///   - uid: The UID to use for the image url
    ///   - completion: An `AccountError` , `SystemError` or `GlobalError` could be passed here but will be nil if it was a success
    func uploadAnother(image: UIImage, completion: @escaping ( (_ error: Error?, _ url: String?) -> () ))  {
        
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
       // Get reference to cloud storage
      //  let ref =  (self.storage == nil) ? Storage.storage().reference()   :  self.storage!
        let ref = Storage.storage(url: "gs://findamare.appspot.com").reference()
        self.storage = ref
        
      //  Auth().currentUser?.reauthenticate(with: <#T##AuthCredential#>, completion: <#T##((AuthDataResult?, Error?) -> Void)?##((AuthDataResult?, Error?) -> Void)?##(AuthDataResult?, Error?) -> Void#>)
        let nameOfImage =  "profile_image\(UUID().uuidString).jpg"
        
        print("***name of the image .. \(nameOfImage)")
        
        let uploadRef = ref.child("users").child(UUID().uuidString).child("images").child(nameOfImage)
        
        print("***image uplaod ref is ... \(uploadRef)")
        
       
        guard let imageData = image.jpegData(compressionQuality: 1) else { completion(SystemError.imageCompress, nil) ; print("can't get image data"); /* Some error compresing the  image */ return  }
        
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        
    
        
        let taskReference = uploadRef.putData(imageData, metadata: uploadMetaData) { downloadMetaData, error in
            
            if let error = error {
                // some error occured
                print("***Some error uplaoding in task reference ... \(error)")
                completion(AccountError.uploadError, nil)
                return

            }
            
            //  No error, get the image URL
            
            uploadRef.downloadURL { url, error in
                print("***Dowloading url with  error \(error) and url \(url)")
                if error != nil{
                    completion(AccountError.uploadError, nil)
                    return
                }
                
                // No error after getting url
                
                let imageURL = url?.absoluteString
                
                print("***image url is .. \(imageURL)")
                
                if let url = imageURL {
                    completion(nil, url)
                } else{
                    completion(AccountError.uploadError, nil)
                }
                
               
             
                
                
                
                
            }
            
           
            
            
            //
        }
        
        
        // for keepign track of download progress
        taskReference.observe(.progress) { [weak self ] snapshot in
            
            guard  let pctThere = snapshot.progress?.fractionCompleted else { return  }
                
                print("Image upload progress : \(pctThere)")
                
        }
        
        
    }
    
  
    
    /// Listen for real time updates on the user's data in the database. Optional completion block will return the datas
    /// - TODO:  Throw an error when it doesn't work .
	func listen_for_user_data_updates(completion:( (_ data: AmareUser?) -> () )? = nil )  {
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
        guard let userid = self.user?.uid else {
            
            // There is no signed in user, throw error or pass in handler
                // Throw error here
            return
        }
        
        
        
        DB.collection("users").document(userid)
            .addSnapshotListener { documentSnapshot, error in
                
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                  // Throw error
                return
              }
                
              guard let data = document.data() else {
                print("Document data was empty.")
                  // Throw error
                return
              }
                
              
            print("the document data is ... \(data)")
                // Reading the data from the database as a UserData object
            
            let result = Result {
                try document.data(as: AmareUser.self)
            }
            
            switch result {
            
            
            case .success(let data):
                
                if  data != nil{
                    
                    // Data object contains all of the user's data
                    self.data = data
					completion?(data)
                    print("The user data is .. \(data)")
                  //  completion?(nil) .no error.
                    
                    
                } else{
                    
                    // Could not retreive the data for some reason
                    // Throw error
                    completion?(nil)
                }
                
            
            case .failure(let error):
                print("Some error happened trying to convert the user data to a User Data object: \(error.localizedDescription)")
                    completion?(nil) //Throw error
          
            }
                
            }
        
        
        DB.collection("users").document(userid).collection("public").document("natal_chart")
            .addSnapshotListener { documentSnapshot, error in
                
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                  // Throw error
                return
              }
                
              guard let data = document.data() else {
                print("Document data was empty.")
                  // Throw error
                return
              }
                
              
            print("the document data is ... \(data)")
                // Reading the data from the database as a UserData object
            
            let result = Result {
                try document.data(as: NatalChart.self)
            }
            
            switch result {
            
            
            case .success(let natalChart):
                
                if  natalChart != nil {
                    
                    // Data object contains all of the user's data
                    self.data?.natal_chart = natalChart
                    print("The natal chart is .. \(natalChart)")
                  //  completion?(nil) .no error.
                    
                    
                } else{
                    
                    // Could not retreive the data for some reason
                    // Throw error
                    //completion?(AccountError.doesNotExist)
                }
                
            
            case .failure(let error):
                print("Some error happened trying to convert the natal chart data to a natalchart object: \(error.localizedDescription)")
                    // completion?(error) Throw error
          
            }
                
            }
        
        
        
    }
    
    ///When the signed in user adds a custom chart for `userId` (they make a custom natal chart for someone)  use this function to save it in database
    func addCustomChart(from userId: String?) {
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
        guard let id = Auth.auth().currentUser?.uid, let userId = userId else {
            
            return
        }
        self.db?.collection("users").document(id).collection("custom_charts").document(userId).setData(["made_new_chart": true, "time": Date.now])
    }
    
    func sendFriendRequest(to userId: String?,  completion: @escaping ( (_ error: Error?) -> () ) )  {
        
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
        guard let id = Auth.auth().currentUser?.uid, let userId = userId else {
            
            return
        }
        
        
        // The user data should be in the shared instance
        
        guard let myProfilePic = Account.shared.data?.profile_image_url, let isNotable = Account.shared.data?.isNotable, let name = Account.shared.data?.name else {
            
            // if not, load it
            print("Profile picture WAS NOT in the shared instance ")
            self.getUserData { err,user  in
                
                print("the errr \(err) and user is \(user)")
                let image = user?.profile_image_url ?? ""
                let isNotable  = user?.isNotable ?? false
                self.db?.collection("friends").document(userId).collection("requests").document(id).setData(["request_by": id, "time": Date.now, "accepted": false, "profile_image_url": image, "isNotable": isNotable, "name": user?.name ?? ""], completion: { error in
                    
                    completion(error)
                })
                
            }
            return
        }
        
        print("Profile picture WAS in the shared instance ")
        // Suppose Amanda sends a friend request to Micheal
        // - friends
            // - Micheal
                // friend_requests
                    // - amandaID
                    // - accepted: false
        self.db?.collection("friends").document(userId).collection("requests").document(id).setData(["request_by": id, "time": Date.now, "accepted": false, "profile_image_url": myProfilePic, "isNotable": isNotable, "name": name], completion: { error in
            
            completion(error)
        })

        
    }
    
    
    func rejectFriendRequest(from userId: String?, completion: @escaping ( (_ error: Error?) -> () ))  {
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
        guard let id = Auth.auth().currentUser?.uid, let userId = userId else {
            
            return
        }
        //TODO: Make cloud function to accept and add friend to database
        self.db?.collection("friends").document(id).collection("requests").document(userId).delete(completion: { error in
            
            completion(error)
        })
    }
    
    func acceptFriendRequest(from userId: String?, completion: @escaping ( (_ error: Error?) -> () ))  {
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
        guard let id = Auth.auth().currentUser?.uid, let userId = userId else {
            
            return
        }
        //TODO: Make cloud function to accept and add friend to database
        self.db?.collection("friends").document(id).collection("requests").document(userId).updateData(["accepted": true], completion: { error in
            
            completion(error)
        })
    }
    
    func cancelFriendRequest(to userId: String?,  completion: @escaping ( (_ error: Error?) -> () ) )  {
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
        guard let id = Auth.auth().currentUser?.uid, let userId = userId else {
            
            return
        }
        
       
        self.db?.collection("friends").document(userId).collection("requests").document(id).delete(completion: { error in
            completion(error)
        })
            
            
         

        
    }
    
    
    /// Deletes friend from user base
    func removeFriend(removedUserId: String?, completion: @escaping ( (_ error: Error?) -> () ) )  {
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
        guard let me = Auth.auth().currentUser?.uid, let removedIdUser = removedUserId else {
            
            return
        }
        
        
        //Listener on cloud function to delete this '2-way' as well and also remove any possible friend requests by both
        self.db?.collection("friends").document(me).collection("myFriends").document(removedIdUser).delete(completion: { error in
            completion(error)
        })
    }
    
    
    

    ///TODO: Add error handling
    ///winks at a user given the user ID
    func wink(at userId: String?) {
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
        guard let id = Auth.auth().currentUser?.uid, let userId = userId else {
            
            return
        }
        
        guard let myProfilePic = Account.shared.data?.profile_image_url, let isNotable = Account.shared.data?.isNotable, let name = Account.shared.data?.name else {
            
     
            self.getUserData { err, data in
                
                print("Got amare user  with \(err) \(data)")
                if let amareUser = data {
                    
                    self.db?.collection("winks").document(userId).collection("people_who_winked").document(id).setData(["didWink": true, "time": Date.now, "profile_image_url": amareUser.profile_image_url ?? "", "isNotable": amareUser.isNotable ?? false, "name": amareUser.name])
                    
                    
                }
            }
            
            return
            
          
        }
        
        
        self.db?.collection("winks").document(userId).collection("people_who_winked").document(id).setData(["didWink": true, "time": Date.now, "profile_image_url": myProfilePic, "isNotable": isNotable, "name": name])
    }
    
    ///TODO: Add error handling
    ///winks at a user given the user ID
    func unwink(at userId: String?) {
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
        guard let id = Auth.auth().currentUser?.uid, let userId = userId else {
            
            print("Not winking... id \(self.user?.uid) , userid = \(userId)")
            return
        }
        self.db?.collection("winks").document(userId).collection("people_who_winked").document(id).delete(completion: { error in
            //
            
            UserDefaults.standard.set(false, forKey: "showConfetti-\(id)")
            UserDefaults.standard.set(false, forKey: "showWinkConfetti-\(id)")
        })
    }
    
    func deleteCustomProfile(id: String)  {
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
        guard let currentSignedInUserId = Auth.auth().currentUser?.uid  else {
            
        
            return
        }
        
        // Delete from custom charts
        self.db?.collection("users").document(currentSignedInUserId).collection("custom_charts").document(id).delete(completion: {error in
            
        })
        
        // Delete the actual  user
        self.db?.collection("users").document(id).delete(completion: {error in
            
        })
        
        NotificationCenter.default.post(name: NSNotification.deletedCustomUserNatalChart, object: id)
        
        
    }

    /// Returns the notable profiles with the same aspect
    func notablesWithAspect(aspect: Aspect) {
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
        _ = Auth.auth().currentUser?.uid ?? ""
        
        //
          //  - isNotable = True
        //users/uid/public(collection)/natal_chart(document)/aspects(array)/<ASPECT OBJ>
        
        DB.collection("users")
            .whereField("isNotable", isEqualTo: true)
         
        
    }
    
    
    
    func notablesWithPlacement(planet: Planet,   completion: @escaping (_ error: Error?, _ users: [AmareUser]) -> Void )  {
        
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
    
            DB
            .collection("placements")
            .document(planet.name.rawValue)
            .collection(planet.sign.rawValue)
          .whereField("is_notable", isEqualTo: true)
           .limit(to: 4)
            .addSnapshotListener { snapshot, error in
                 
                
                var usersfromdatabase: [AmareUser] = []
                
                print("Getting documents.... \(planet.name.rawValue) : \(planet.sign.rawValue)")
                
                guard error == nil else { completion(error, []); return}
                print("Error getting docs is ... \(error)")
                
                let myGroup = DispatchGroup()
               
                
                for document in snapshot!.documents{
                    
                    myGroup.enter()
                    
                    let doc = document.data()
                    let id = document.documentID
                    _ = doc["is_notable"]
                    
                    print("FOUND FIT: the doc is ... \(doc)")
                    
                    
                    
                    Account().getOtherUser(from: id) { user, error in
                        
                        guard let user = user else {completion(error, []); return}
                        
                        // Append user to the users of similar aspects
                        print("Adding to notable users")
                        usersfromdatabase.append(user)
                        print("now the usersfromdatabase is \(usersfromdatabase)")
                        myGroup.leave()
                        
                    }
                    
                    
                  
                }
                
                myGroup.notify(queue: .main) {
                    
                    completion(nil, usersfromdatabase)
                    }
                
                
                
                
            }

    }
}






extension PhoneAuthCredential{
    func save() {
        
        UserDefaults.standard.set(self, forKey: "authInfo")
    }
    
    class func get() -> PhoneAuthCredential? {
        
        return UserDefaults.standard.object(forKey: "authInfo") as? PhoneAuthCredential
    }
}
