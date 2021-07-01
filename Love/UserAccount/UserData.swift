//
//  UserData.swift
//  Love
//
//  Created by Micheal Bingham on 6/23/21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

/// Helper class we're using to store and read data from our backend. All user data properties read from database are here.
public struct UserData: Codable{
    
        ///Unique user id of the user.
    @DocumentID var id: String?
    
    var name: String? = nil
    var hometown: Place? = nil
    var birthday: Birthday? = nil
    var residence: Place? = nil
    
    
    
    
    
    
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case hometown
        case birthday
        case residence 
    }
    
    /// Returns if all user data attributes for the sign up flow are completed. Or if the user completed the sign up flow, i.e. the UserData object is complete
    func isComplete() -> Bool {
        
        return (self.name != nil && self.birthday != nil && self.hometown != nil && self.residence != nil)
    }
    
    /// Returns the SignUpState the user should be sent to. So let's say the user did not complete their birthday, this will return .birthday. This is a helper function to determine what part of the sign up flow to direct the user if they failed to finish the sign up process before going to thier program. Usually it's because they logged out, got unauthenticated, or quit the app during sign up. It's important to keep the signupflow in its set order otherwise this will not work. Returns nil if nothing is nil (user compeleted sign up)
    func getFirstNilInSignUpState() -> SignUpState? {
        
        if self.name == nil {
            return .name
        }
        
        else if self.hometown == nil{
            return .hometown
        }
        
        else if self.birthday == nil {
            return .birthday
        }
        
       
        
        else if self.residence == nil{
            return .residence
        }
        
        return nil
    
    }
    
}


struct Birthday: Codable{
    
    var timestamp: Timestamp?
    
    
    var month: String?
    var day: Int?
    var year: Int?
    
    
}



struct Place: Codable  {
    
    var latitude: Double?
    var longitude: Double?
    
    var city: String?
    var state: String?
    var country: String?
    
    var geohash: String?
    
    
    
}


/// Part of sign up flow  user did not complete
enum SignUpState{
    case name
    case birthday
    case hometown
    case residence
}
