//
//  AccountErrors.swift
//  Love
//
//  Created by Micheal Bingham on 6/23/21.
//

import Foundation


/// Errors that can result of calling any method in the Accound class 
enum AccountError: Error {
    /// The user does not exist in the database.
    case doesNotExist
    /// The user has been disabeled. 
    case disabledUser
    /// The verification code is expired. Resend it.
    case expiredVerificationCode
    /// A wrong verification code, password, or authentification was entered
    case wrong
    /// The user is not authenticated (signed-in). 
    case notSignedIn
    ///  Some error uploading to the storage but we don't know exactly why but it's likely a network error of some sort
    case uploadError
    /// Not authorized to add data here. Check security rules.
    case notAuthorized
    ///
    case expiredActionCode
    ///
    case sessionExpired
    ///
    case userTokenExpired

    
}
