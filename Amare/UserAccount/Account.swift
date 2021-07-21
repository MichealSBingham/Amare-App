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


/// Class for handling user account related things such as signing in, signing out, listening for auth changes, adding and reading from the database, etc. An account is associated with one user.
///
///  - Warning: If unexpected behavior occurs, set handle, didChange to public
class Account: ObservableObject {

   
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
    private var db: Firestore?
    
    /// Reference to cloud storage (firebase)
    private var storage: StorageReference?
    
    
    
    
    /// User Data saved to an account object. This won't always have the user's saved data as it is stored in the `Account` object so you must pull the UserData from the dataset first before expecting this attribute to have the updated information.
    @Published var data: UserData? = UserData()
    
    
    
    
    /// Sends a verification code to the user's phone number to be used to login or create an account
    /// - Parameters:
    ///   - phoneNumber: Must include country code, ex:  "+19176990590"
    ///   - runThisClosure: Closure to run after the verification code was sent (or attempted) with an optional error passed.
    ///   - error: Of type `AccountError`or `GlobalError`. This will be `nil` if a verification code was successfully sent.
    ///
    /// - Author: Micheal S. Bingham
     func sendVerificationCode(to phoneNumber: String,
                               andAfter  runThisClosure: ((_ error: Error?) -> Void)? = nil ) {
         
         Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            
            
            
            
// ============================================  Handling Errors ==============================================================================
            if let error = error{
                
                              
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
                        runThisClosure!(GlobalError.networkError, nil, nil)
                    case .tooManyRequests:
                        runThisClosure!(GlobalError.tooManyRequests, nil, nil)
                    case .captchaCheckFailed:
                        runThisClosure!(GlobalError.captchaCheckFailed, nil, nil)
                    case .invalidPhoneNumber:
                        runThisClosure!(GlobalError.invalidInput, nil, nil)
                    case .quotaExceeded:
                        runThisClosure!(GlobalError.quotaExceeded, nil, nil)
                    case .operationNotAllowed:
                        runThisClosure!(GlobalError.notAllowed, nil, nil)
                    case .internalError:
                        runThisClosure!(GlobalError.internalError, nil, nil)
                        
                        // Handle Account Errors
                    case .expiredActionCode:
                        runThisClosure!(AccountError.expiredActionCode, nil, nil)
                    case .sessionExpired:
                        runThisClosure!(AccountError.sessionExpired, nil, nil)
                    case .userTokenExpired:
                        runThisClosure!(AccountError.userTokenExpired, nil, nil)
                    case .userDisabled:
                        runThisClosure!(AccountError.disabledUser, nil, nil)
                    case .wrongPassword:
                        runThisClosure!(AccountError.wrong, nil, nil)
                    case .invalidVerificationCode:
                        runThisClosure!(AccountError.wrong, nil, nil )
                    case .missingVerificationCode:
                        runThisClosure!(AccountError.wrong, nil , nil )
                    default:
                        print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.login()")
                        runThisClosure!(GlobalError.unknown, nil, nil)
                    }
                    
                   return
                    
                } else{
                    
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
                
                self.getUserData { [self] error in
                    
                    guard error == nil else {
                        // Handle Errors Now...
                        
                        
                      
                        // Check if it's an AccountError or global error
                        
                        if let error = error as? AccountError{
                            // It's an account error
                            if error == .doesNotExist{ // it's the user's first sign in
                                runThisClosure!(nil, user, .name)
                                return
                            } else {
                                // It was some other account error
                                runThisClosure!(error, nil, nil)
                                return
                            }
                        }
                        
                        
                        
                        
                        if let error = error as? GlobalError{
                            // It's a global error so pass the error
                           runThisClosure!(error, nil, nil )
                            return
                        }
                            
                        
                        print("There was some error get user data .. \(error?.localizedDescription) ")
                        runThisClosure!(GlobalError.unknown, nil, nil)

                        // Otherwise we don't know what error it is so just let it be a global error
                        
                        return
                        
                    }
                    
                    
                    // No Error occured
                  
                  
                    guard (self.data?.isComplete())! else{
                        
                        // The user data isn't complete so should go to the sign up state
                        // Means the user did not finish signing up
                        self.data = data
                        runThisClosure!(nil, user, data?.getFirstNilInSignUpState())
    
                        return
                        
                    }
                   
                  // Otherwise sign in the user. False because it finished signing up and doesn't need to be taken to the sign up state
                    self.data = data
                    runThisClosure!(nil, user, .done )
                    
                   return
                }
                
                
               
                
            } else{
                
                // Unknown Why
                
                print("\n\n Some error happened. Error... for some reason, auth().signIn returned an empty FIRUser object. Unknown Global Error")
                
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
        completion?(nil)
        
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
    }
      
    }
    
    
    
    /// Monitors for authentification changes by adding an observer to `.isSignedIn`. Uses Firebase. Call this before expecting `.isSignedIn`. to update in realtime.
    /// - Author: Micheal S. Bingham
    func listen () {
            // monitor authentication changes using firebase
        self.isListening = true
            handle = Auth.auth().addStateDidChangeListener { (auth, user) in
                if let user = user {
                    // if we have a user, create a new user model
                    self.user = user
                    if self.isListening{
                        self.isSignedIn = true
                    }
                  
                    
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
    
    /// Reads the user data once from the database and saves it in the object (Saves it to `account.data`). l. Assigns a `UserData` object to `self.data`
    /// - Parameter completion: Completion block ran after an attempt to fetch the user data beloning to the `Account`
    /// - Parameter error: Will be nil if it was successful or an error of type `AccountError` or `GlobalError` will be passed.
    /// - Author: Micheal S. Bingham
    func getUserData(completion:( (_ err: Error?) -> Void)?  = nil )  {
        
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
    
        
        guard let id  = self.user?.uid else {
            
            completion?(AccountError.notSignedIn)
            
            return
        }
        
        DB.collection("users").document(id).getDocument { document, error in
            
            guard error == nil else{
                // Handle these errors....
                
                if let error = AuthErrorCode(rawValue: error?._code ?? 17999){
                    
                    switch error {
                        
                        // Handle Global Errors
                    case .networkError:
                        completion?(GlobalError.networkError)
                    case .tooManyRequests:
                        completion?(GlobalError.tooManyRequests)
                    case .captchaCheckFailed:
                        completion?(GlobalError.captchaCheckFailed)
                    case .quotaExceeded:
                        completion?(GlobalError.quotaExceeded)
                    case .operationNotAllowed:
                        completion?(GlobalError.notAllowed)
                    case .internalError:
                        print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.getUserData()")
                        completion?(GlobalError.internalError)
                        
                        // Handle Account Errors
                    case .expiredActionCode:
                        completion?(AccountError.expiredActionCode)
                    case .sessionExpired:
                        completion?(AccountError.sessionExpired)
                    case .userTokenExpired:
                        completion?(AccountError.userTokenExpired)
                    case .userDisabled:
                        completion?(AccountError.disabledUser)
                    case .wrongPassword:
                        completion?(AccountError.wrong)
                    default:
                        print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.getUserData()")
                        completion?(GlobalError.unknown)
                    }
                    
                   return
                    
                } else{
                    
                    print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.getUserData()")
                    completion?(GlobalError.unknown)
                    return
                }
            
                
                
            }
            
            if let document = document, document.exists {
                
                  
                
                let result = Result {
                    try document.data(as: UserData.self)
                }
                
                switch result {
                
                
                case .success(let data):
                    
                    if let data = data{
                        
                        // Data object contains all of the user's data
                        self.data = data
                        completion?(nil)
                        
                        
                    } else{
                        
                        // Could not retreive the data for some reason
                        completion?(AccountError.doesNotExist)
                    }
                    
                
                case .failure(let error):
                    // Handle errors
                    print("Some error happened trying to convert the user data to a User Data object: \(error.localizedDescription)")
                    completion?(GlobalError.unknown)
              
                }

                
                
                
                } else {
                    // User does not exist
                    completion?(AccountError.doesNotExist)
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
    func set(data: UserData, completion:( (_ error: Error?) -> () )? = nil )  {
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
        
        if let uid = self.user?.uid{
            
         
            
            
            do {
                
               
               try DB.collection("users").document(uid).setData(from: data, merge: true) { error in
                    
                   
                   guard error == nil else {
                   // Handling the error
                   if let error = AuthErrorCode(rawValue: error?._code ?? 17999){
                       
                       switch error {
                           
                           // Handle Global Errors
                       case .networkError:
                           completion?(GlobalError.networkError)
                       case .tooManyRequests:
                           completion?(GlobalError.tooManyRequests)
                       case .captchaCheckFailed:
                           completion?(GlobalError.captchaCheckFailed)
                       case .quotaExceeded:
                           completion?(GlobalError.quotaExceeded)
                       case .operationNotAllowed:
                           completion?(GlobalError.notAllowed)
                       case .internalError:
                           print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.set()")
                           completion?(GlobalError.internalError)
                           
                           // Handle Account Errors
                       case .expiredActionCode:
                           completion?(AccountError.expiredActionCode)
                       case .sessionExpired:
                           completion?(AccountError.sessionExpired)
                       case .userTokenExpired:
                           completion?(AccountError.userTokenExpired)
                       case .userDisabled:
                           completion?(AccountError.disabledUser)
                       case .wrongPassword:
                           completion?(AccountError.wrong)
                       default:
                           print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.set()")
                           completion?(GlobalError.unknown)
                       }
                       
                      return
                       
                   } else{
                       
                       print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.set()")
                       completion?(GlobalError.unknown)
                       return
                   }
                   
                    
            
                       
               }
                   
                   
                }
                
            } catch let error{
                
                if let error = AuthErrorCode(rawValue: error._code ?? 17999){
                    
                    switch error {
                        
                        // Handle Global Errors
                    case .networkError:
                        completion?(GlobalError.networkError)
                    case .tooManyRequests:
                        completion?(GlobalError.tooManyRequests)
                    case .captchaCheckFailed:
                        completion?(GlobalError.captchaCheckFailed)
                    case .quotaExceeded:
                        completion?(GlobalError.quotaExceeded)
                    case .operationNotAllowed:
                        completion?(GlobalError.notAllowed)
                    case .internalError:
                        print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.login()")
                        completion?(GlobalError.internalError)
                        
                        // Handle Account Errors
                    case .expiredActionCode:
                        completion?(AccountError.expiredActionCode)
                    case .sessionExpired:
                        completion?(AccountError.sessionExpired)
                    case .userTokenExpired:
                        completion?(AccountError.userTokenExpired)
                    case .userDisabled:
                        completion?(AccountError.disabledUser)
                    case .wrongPassword:
                        completion?(AccountError.wrong)
                    default:
                        print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.login()")
                        completion?(GlobalError.unknown)
                    }
                    
                   return
                    
                } else{
                    
                    print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.login()")
                    completion?(GlobalError.unknown)
                    return
                }
                
                
            //    completion?(error)
                
                
                
            }
            
            
            
            
        } else{
            
            completion?(AccountError.notSignedIn)
            
            
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
                
                
                if let error = AuthErrorCode(rawValue: error._code ?? 17999){
                    
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
    func upload(image: UIImage, isProfileImage: Bool = false, completion: ( (_ error: Error?) -> () )? = nil)  {
        
        guard let userid = self.user?.uid else {
            
            // There is no signed in user, throw error or pass in handler
            completion?(AccountError.notSignedIn)
            return
        }
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
       // Get reference to cloud storage
        let ref =  (self.storage == nil) ? Storage.storage().reference()   :  self.storage!
        self.storage = ref
        
        
        let nameOfImage = isProfileImage ? "profile_image.jpg" : "\(UUID.init().uuidString).jpg"
        
        let uploadRef = ref.child("users").child(userid).child("images").child(nameOfImage)
        
       
        guard let imageData = image.jpegData(compressionQuality: 1) else { completion?(SystemError.imageCompress) ;/* Some error compresing the  image */ return  }
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        
    
        
        let taskReference = uploadRef.putData(imageData, metadata: uploadMetaData) { downloadMetaData, error in
            
            if let error = error {
                // some error occured
                completion?(AccountError.uploadError)

            }
            
            //  No error, get the image URL
            
            uploadRef.downloadURL { url, error in
                
                if let error = error{
                    completion?(AccountError.uploadError)
                }
                
                // No error after getting url
                
                let imageURL = url?.absoluteString
                
                // Set the url link in the database
                
                if isProfileImage{  self.data?.profile_image_url = imageURL }

                // Now add it to the images array
                //****************************
               
             //  let data =  UserData(id: self.user?.uid, images: [imageURL!])
                
             
                
                DB.collection("users").document(userid).updateData(["images": FieldValue.arrayUnion([imageURL!])]) { error in
                    
                    
                    guard error == nil else {
                        // There is an error when trying to update the data
                        
                        if let error = StorageErrorCode(rawValue: error?._code ?? 17999){
                            // We try to read the error

                            
                            switch error {
                                
                                // Handle Global Errors
                            case .quotaExceeded:
                                completion?(GlobalError.quotaExceeded)
                            case .unauthorized:
                                completion?(AccountError.notAuthorized)
                            case .unauthenticated:
                                completion?(AccountError.notSignedIn)
                            case .objectNotFound:
                                // There is no object located here so we need to create one and add it.
                                DB.collection("users").document(self.data?.id ?? self.user!.uid).setData(["images": []]) { error in
                                    
                                    
                                   guard error == nil else  {
                                        print("We failed to upload it in the databases, we tried to set the images data to an empty array but it dind't work")
                                        completion?(GlobalError.unknown)
                                       return
                                    }
                                    
                                    // It worked so let's just try again
                                    self.upload(image: image, isProfileImage: isProfileImage) { error in
                                        
                                        guard error == nil else {
                                            // It didn't work so just try again
                                            print("We failed trying to recursiviely upload the image if .objectNotfound with error \(error!.localizedDescription)")
                                            completion?(GlobalError.unknown)
                                            return
                                            
                                        }
                                        // It worked.
                                        
                                        self.set(data: self.data ?? UserData(profile_image_url: imageURL)) { error in
                                            
                                            guard error == nil else {
                                                completion?(error)
                                                return
                                            }
                                            completion?(nil)
                                        }
                                    }
                                }
                           
                            default:
                                print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.upload()")
                                completion?(GlobalError.unknown)
                            }
                            
                            
                        }
                        
                        // it's some other error , unknown to us
                        print("\n\nSome error happened, global \(error?.localizedDescription) happened at the end of upload ")
                        completion?(GlobalError.unknown)
                        return
                    }
                   
                    
                    // It worked
                    completion?(nil)
                    // Set the profile image url to the user data as well
                    
                    self.set(data: self.data ?? UserData(profile_image_url: imageURL)) { error in
                        
                        guard error == nil else {
                            completion?(error)
                            return
                        }
                        completion?(nil)
                    }

                    
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
    
  
    
    /// Listen for real time updates on the user's data in the database.
    /// - TODO:  Throw an error when it doesn't work .
    func listen_for_user_data_updates()  {
        
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
                
              
                
                // Reading the data from the database as a UserData object
            
            let result = Result {
                try document.data(as: UserData.self)
            }
            
            switch result {
            
            
            case .success(let data):
                
                if let data = data{
                    
                    // Data object contains all of the user's data
                    self.data = data
                  //  completion?(nil) .no error.
                    
                    
                } else{
                    
                    // Could not retreive the data for some reason
                    // Throw error
                    //completion?(AccountError.doesNotExist)
                }
                
            
            case .failure(let error):
                print("Some error happened trying to convert the user data to a User Data object: \(error.localizedDescription)")
                    // completion?(error) Throw error
          
            }
                
            }
        
    }
    

    
    
    
}




