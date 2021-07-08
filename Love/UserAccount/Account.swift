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
    ///   - onSuccess: Completion block to run after code is succesfully sent
    ///   - onFailure: Completion block to run if some error occured. Error is passed in this closure
    ///   - error: `LoginError` passed if `onFailure` completion block is ran
    ///
    /// - Author: Micheal S. Bingham
     func sendVerificationCode(to phoneNumber: String,
                                    andifItWorks onSuccess: (() -> Void)? = nil,
                                    butIfSomeError onFailure: ((_ error: AuthentificationError) -> Void)? = nil ) {
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            
// ============================================  Handling Errors ==============================================================================
            if let error = error{
                
              
                print("\n\nAn error happened when trying to send verification code to phone \(error.localizedDescription)")
                
                if let error = AuthErrorCode(rawValue: error._code){
                    
                    switch error {
                    case .networkError:
                        onFailure!(AuthentificationError.networkError)
                    case .tooManyRequests:
                        onFailure!(AuthentificationError.tooManyRequests)
                    case .captchaCheckFailed:
                        onFailure!(AuthentificationError.captchaCheckFailed)
                    case .userDisabled:
                        onFailure!(AuthentificationError.accountDisabled)
                    case .invalidPhoneNumber:
                        onFailure!(AuthentificationError.invalidInput)
                    default:
                        onFailure!(AuthentificationError.unknown)
                    }
                    
                    return
                    
                } else{
                    
                    onFailure!(AuthentificationError.unknown)
                    return
                }
            
// ============================================  Handling Errors ==============================================================================

                
            
                
            }
            
            guard let vID = verificationID else{
                
                onFailure!(AuthentificationError.cantGetVerificationID)
                
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
                     failedToLogin couldNotLogin: ((_ error: AuthentificationError) -> Void)? = nil ,
                     afterSuccess  didLogIn: @escaping (_ user: User) -> Void,
                     onFirstSignIn shouldSignUp: (() -> Void)? = nil ) {
        
        // Sign in User
        guard let verificationID = getVerificationID() else{
        
            print("Some Error happened. Can't grab Verification ID.  ")
            
            couldNotLogin!(AuthentificationError.cantGetVerificationID)
            
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
                        couldNotLogin!(AuthentificationError.networkError)
                    case .tooManyRequests:
                        couldNotLogin!(AuthentificationError.tooManyRequests)
                    case .captchaCheckFailed:
                        couldNotLogin!(AuthentificationError.captchaCheckFailed)
                    case .userDisabled:
                        couldNotLogin!(AuthentificationError.accountDisabled)
                    case .wrongPassword:
                        couldNotLogin!(AuthentificationError.wrongVerificationCode)
                    case .invalidVerificationCode:
                        couldNotLogin!(AuthentificationError.wrongVerificationCode)
                    default:
                        couldNotLogin!(AuthentificationError.unknown)
                    }
                    
                    return
                    
                } else{
                    
                    couldNotLogin!(AuthentificationError.unknown)
                    return
                }
            
                
// ============================================  Handling Errors ==============================================================================

                                
                
            }
            
            if let  user = authData?.user{
                
                // User logged in
                
                print("Inside login function we just set the new user ....  with ID\(user.uid)")
                self.user = user
                self.data?.id = user.uid
                
                if self.isListening{
                     self.isSignedIn = true
                        
                 }
                
                self.getUserData { error in
                    
                    print("The error getting user data is ... \(error)")
                    print("The data is ... \(self.data)")
                    
                    
                    if let error = error as? AccountError {
                        // There was some error getting user data
                        print("There was some accounteerror getting user data")
                        
                        switch error {
                        case .doesNotExist: // It is probably the user's first sign in
                                // self.data = nil no need to do this, this may be causing an error on FromWhereView.
                            shouldSignUp!()
                            
                            return
                        }
                        // competion
                        
                        
                        
                    }
                    
                    if let error = error as? AuthentificationError {
                        // there was an authentification error instead
                        print("There was some auth error getting user data")
                        couldNotLogin!(error)
                        
                        return
                        
                    }
                    
                    
                    if let error = error {
                        print("There was some other error getting user data")
                        couldNotLogin!(AuthentificationError.unknown)
                        return
                    }
               
            // No error passed ...
                  
                    guard (self.data?.isComplete())! else{
                        
                        shouldSignUp!()
                        
                        return
                        
                    }
                   
                  
                   didLogIn(user)
                    
                   return
                }
                
                
               
                
          // \\//\\     // Check if it is user's first sign in or not \\//\\//\\//\\//\\//\\/
                
                //didLogIn(user)
                
            } else{
                
                // Unknown Why
                
                print("Error... for some reason, auth().signIn returned an empty FIRUser object. ")
                
                couldNotLogin!(AuthentificationError.unknown)
                return
                
            }
            
            
            
            
            
    }
    

   
    
}
    
    
    /// Signs the user out
    /// - Parameters:
    ///   - didSignOut: Completion block for when sign out succeeds
    ///   - failure: Complettion block for when sign out fails
    ///   - error: A `NSError` is passed in the `cantSignOut ` block. If sign out fails, it is most likely just a network error.
    /// - Author: Micheal S. Bingham
     func signOut(success didSignOut: (() -> Void)? = nil,
                       cantSignOut failure: ((_ error: AuthentificationError) -> Void)? = nil) {
        
        let firebaseAuth = Auth.auth()
    do {
        
      try firebaseAuth.signOut()
        //self.isSignedIn = false  will casue an error because of navigation links and $boolean values
        if  self.isListening{
            self.isSignedIn = false
        }
        didSignOut!()
        
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
        let e = AuthErrorCode(rawValue: signOutError.code)
        switch e {
        case .networkError:
            failure!(AuthentificationError.networkError)
        default:
            failure!(AuthentificationError.unknown)
        }
        
        failure!(AuthentificationError.unknown)
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
    
    /// Reads the user data once from the database and saves it in the object. The completion block is ran with no error if successful. Assigns a `UserData` object to `self.data`
    /// - Parameter completion: Possible errors that can be passed are...
    /// - TODO: Error Handling ...
    func getUserData(completion:( (_ err: Error?) -> Void)?  = nil )  {
        
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
    
        
        guard let id  = self.user?.uid else {
            
            completion!(AuthentificationError.notSignedIn)
            
            return
        }
        
        DB.collection("users").document(id).getDocument { document, error in
            
            guard error == nil else{
                completion!(error!)
                return
            }
            
            if let document = document, document.exists {
                
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("User  data retreived once : \(dataDescription)")
                
                    // Reading the data from the database as a UserData object
                
                let result = Result {
                    try document.data(as: UserData.self)
                }
                
                switch result {
                
                
                case .success(let data):
                    
                    if let data = data{
                        
                        // Data object contains all of the user's data
                        self.data = data
                        completion!(nil)
                        
                        
                    } else{
                        
                        // Could not retreive the data for some reason
                        completion!(AccountError.doesNotExist)
                    }
                    
                
                case .failure(let error):
                    print("Some error happened trying to convert the user data to a User Data object: \(error.localizedDescription)")
                    completion!(error)
              
                }

                
                
                
                } else {
                    print("Document does not exist")
                    // User does not exist
                    completion!(AccountError.doesNotExist)
                }
            
            
            return
        }
        
    }
    
    
    /// Sets and updates user data to the account in the database. Will not override if nil data is provided. 
    /// - Parameters:
    ///   - data: `UserData` object that contains profile information. See `UserData`
    ///   - completion: Will pass an error (TODO) otherwise nil if it is successful
    func set(data: UserData, completion:( (_ error: Error?) -> () )? = nil )  {
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
        
        if let uid = self.user?.uid{
            
         
            
            
            do {
                
               
               try DB.collection("users").document(uid).setData(from: data, merge: true) { error in
                    
                   print("The error setting data is ... \(error)")
                   
                    completion!(error)
                }
                
            } catch let error{
                
                print("Error writing data to Firestore: \(error)")
                completion!(error)
            }
            
            
            
            
        } else{
            
            completion!(AuthentificationError.notSignedIn)
            
            
        }
        
       
        
    }
    
    
    
    
    /// Saves and updates user data to the account in the database. Will not override if nil data is provided. The difference between this and `set()` is that this uses the `UserData` that the   `Account` object is already holding as its `self.data` property
    /// - Parameters:
    ///   - completion: Will pass an error (TODO) otherwise nil if it is successful
    func save( completion:( (_ error: Error?) -> () )? = nil )  {
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
        
        if let uid = self.user?.uid{
            
            self.data?.id = uid
         
            
            
            do {
                
                
                try DB.collection("users").document(uid).setData(from: self.data, merge: true) { error in
                    
                   print("The error setting data is ... \(error)")
                   
                    completion!(error)
                }
                
            } catch let error{
                
                print("Error writing data to Firestore: \(error)")
                completion!(error)
            }
            
            
            
            
        } else{
            
            completion!(AuthentificationError.notSignedIn)
            
            
        }
        
       
        
    }
    
    
    
    func upload(image: UIImage, isProfileImage: Bool = false, completion: ( (_ error: Error?) -> () )? = nil)  {
        
        guard let userid = self.user?.uid else {
            
            // There is no signed in user, throw error or pass in handler
            completion!(AuthentificationError.notSignedIn)
            return
        }
        
        let DB =  (self.db == nil) ? Firestore.firestore()   :  self.db!
        self.db = DB
        
       // Get reference to cloud storage
        let ref =  (self.storage == nil) ? Storage.storage().reference()   :  self.storage!
        self.storage = ref
        
        
        let nameOfImage = isProfileImage ? "profile_image.jpg" : "\(UUID.init().uuidString).jpg"
        
        let uploadRef = ref.child("users").child(userid).child("images").child(nameOfImage)
        
       
        guard let imageData = image.jpegData(compressionQuality: 1) else {  /* Some error compresing the  image */ return  }
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        
    
        
        let taskReference = uploadRef.putData(imageData, metadata: uploadMetaData) { downloadMetaData, error in
            
            if let error = error {
                // some error occured
                completion!(error)

            }
            
            //  No error, get the image URL
            
            uploadRef.downloadURL { url, error in
                
                if let error = error{
                    completion!(error)
                }
                
                // No error after getting url
                
                let imageURL = url?.absoluteString
                
                // Set the url link in the database
                
                if isProfileImage{  self.data?.profile_image_url = imageURL }

                // Now add it to the images array
                //****************************
               
             //  let data =  UserData(id: self.user?.uid, images: [imageURL!])
                
                DB.collection("users").document(userid).updateData(["images": FieldValue.arrayUnion([imageURL!])]) { error in
                    
                    if let error = error {
                        completion!(error)
                    } // else completion success
                    
                    
                    completion!(nil)
                    
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
                  //  completion!(nil) .no error.
                    
                    
                } else{
                    
                    // Could not retreive the data for some reason
                    // Throw error
                    //completion!(AccountError.doesNotExist)
                }
                
            
            case .failure(let error):
                print("Some error happened trying to convert the user data to a User Data object: \(error.localizedDescription)")
                    // completion!(error) Throw error
          
            }
                
            }
        
    }
    

    
    
    
}




