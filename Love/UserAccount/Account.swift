//
//  Account.swift
//  Love
//
//  Created by Micheal Bingham on 6/19/21.
//

import Foundation
import Firebase
import FirebaseAuth

/// Class for handling user account related things such as signing in, signing out, etc.
class Account {


    
    /// Sends a verification code to the user's phone number to be used to login or create an account
    /// - Parameters:
    ///   - phoneNumber: Must include country code, ex:  "+19176990590"
    ///   - onSuccess: Completion block to run after code is succesfully sent
    ///   - onFailure: Completion block to run if some error occured. Error is passed in this closure
    ///
    /// - Author: Micheal S. Bingham
    /// - TODO: Handle Errors
    class func sendVerificationCode(to phoneNumber: String,
                                    andifItWorks onSuccess: (() -> Void)? = nil,
                                    butIfSomeError onFailure: ((LoginError) -> Void)? = nil ) {
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            
            if let error = error{
                
                // - TODO: Handle errors
                print("An error happened \(error.localizedDescription)")
                
                onFailure!(LoginError.Unknown)
            
                return
            }
            
            guard let vID = verificationID else{
                
                onFailure!(LoginError.Unknown)
                return
            }
            
            vID.save()
            
            onSuccess?()
            
            
           
        }
    }
    
    
    
    
    /// Logs in the user with the verification code sent via SMS.
    /// - Parameters:
    ///   - verification_code: Verification code SMS sent
    ///   - couldNotLogin: LoginError passed in completion block if some error happened attemtping to sign in
    ///   - didLogIn: Completion block for when the user successfully signed in.  FirebaseAuth.User object is passed here
    ///   - onFirstSignIn: Completion block for if either it is the user's first sign in, or they did not complete the sign up flow and should
    ///
    /// - Author: Micheal S. Bingham
    /// - TODO: Handle Login Errors, Detect if it is first sign In
    class func login(with verification_code: String,
               failedToLogin couldNotLogin: ((LoginError) -> Void)? = nil ,
               afterSuccess  didLogIn: @escaping (User) -> Void,
               onFirstSignIn shouldSignUp: (() -> Void)? = nil ) {
        
        // Sign in User
        guard let verificationID = getVerificationID() else{
        
            print("Some Error happened. Can't grab Verification ID.  ")
            
            couldNotLogin!(LoginError.CantGetVerificationID)
            
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verification_code)
        
  
        
        Auth.auth().signIn(with: credential) { authData, error in
            
            if let error = error { // Some error happened
                
                print("Some Error Happened Signing In : \(error.localizedDescription)")
                
                // TODO: Handle Login Errors
                
                couldNotLogin!(LoginError.Unknown)
                
                return
            }
            
            if let  user = authData?.user{
                
                // User logged in
                
                didLogIn(user)
                
            } else{
                
                // Unknown Why
                
                print("Error... for some reason, auth().signIn returned an empty FIRUser object. ")
                
                couldNotLogin!(LoginError.Unknown)
                
            }
            
            
            
            
            
    }
    

   
    
}
    
    
    /// Signs the user out
    /// - Parameters:
    ///   - didSignOut: Completion block for when sign out succeeds
    ///   - failure: Complettion block for when sign out fails
    /// - Author: Micheal S. Bingham
    /// - Remark: A `NSError` is passed in the `cantSignOut ` block. If sign out fails, it is most likely just a network error.
    class func signOut(success didSignOut: () -> Void,
                 cantSignOut failure: (NSError) -> Void) {
        
        let firebaseAuth = Auth.auth()
    do {
        
      try firebaseAuth.signOut()
        didSignOut()
        
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
        failure(signOutError)
    }
      
    }
    
}
