//
//  GlobalErrors.swift
//  Love
//
//  Created by Micheal Bingham on 7/8/21.
//

import Foundation

/// Generic errors that can be a result of any class  when dealing with the backend database
enum GlobalError: Error{
    /// A  network error occured
    case networkError
    /// Too many requests to the backend have been sent
    case tooManyRequests
    /// The user failed the captcha check
    case captchaCheckFailed
    /// Wrong input was sent as a request to the database. Could be improper formatting of a specific data type.
    case invalidInput
    /// The project has exceeded its request quota. This is a firebase problem.
    case quotaExceeded
    /// Either there is no authentification, invalid authentification, or admin has restricted privieldges to read or write this request
    case notAllowed
    /// Internal error within the backend, not caused by the user 
    case internalError
    /// This means the verification ID used to authenticate the user was not saved and retreived properly from `User Defaults`
    case cantGetVerificationID
    /// The reason why this error happened it is probably due to an error of a third party framework we are using so look at console for 'Some Error Happened: ' 
    case unknown
}
