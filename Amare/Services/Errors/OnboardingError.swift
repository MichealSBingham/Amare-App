//
//  OnboardingError.swift
//  Amare
//
//  Created by Micheal Bingham on 7/10/23.
//

import Foundation


enum OnboardingError: Error{
    case incompleteData
    case dateError
}
enum ImageError: Error {
    case dataConversionFailed
    case uploadFailed
    case notSignedIn
}
