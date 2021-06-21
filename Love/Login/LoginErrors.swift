//
//  LoginErrors.swift
//  Love
//
//  Created by Micheal Bingham on 6/20/21.
//

import Foundation


enum LoginError: Error{
    
    case wrongVerificationCode
    case accountDisabled
    case InvalidInput
    case Unknown
    case CantGetVerificationID
}
