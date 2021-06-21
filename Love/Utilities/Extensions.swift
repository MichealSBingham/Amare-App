//
//  Extensions.swift
//  Love
//
//  Created by Micheal Bingham on 6/17/21.
//

import Foundation
import SwiftUI



/// Gets the Verification ID from signing in the phone number
/// - Returns: The verification id string from UserDefaults 
func getVerificationID() -> String? {
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    return verificationID
}

extension String{
    
    /// Saves the verification ID string in UserDefaults
    /// - Returns: Void.
    func save()  {
        
        UserDefaults.standard.set(self, forKey: "authVerificationID")
    }
}


