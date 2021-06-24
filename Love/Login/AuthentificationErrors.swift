//
//  LoginErrors.swift
//  Love
//
//  Created by Micheal Bingham on 6/20/21.
//

import Foundation


enum AuthentificationError: Error{
    
    case networkError
    case tooManyRequests
    case captchaCheckFailed
    case wrongVerificationCode
    case accountDisabled
    case invalidInput
    case unknown
    case cantGetVerificationID
    case notSignedIn
}
