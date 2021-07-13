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
    var profile_image_url: String? = nil
    private(set) var images: [String]? = nil
    var sex: String? = nil  // M , F, or something else the user enters as a custom gender
    var orientation: String? = nil // M, F, MF (male and female), or A (everything) 
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case hometown
        case birthday
        case residence
        case profile_image_url
        case images
        case sex
        case orientation
    }
    
    /// Returns if all user data attributes for the sign up flow are completed. Or if the user completed the sign up flow, i.e. the UserData object is complete
    func isComplete() -> Bool {
        
        return (self.name != nil && self.birthday != nil && self.hometown != nil && self.residence != nil && self.profile_image_url != nil && self.sex != nil && self.orientation != nil)
    }
    
    /// Returns the SignUpState the user should be sent to. So let's say the user did not complete their birthday, this will return .birthday. This is a helper function to determine what part of the sign up flow to direct the user if they failed to finish the sign up process before going to thier program. Usually it's because they logged out, got unauthenticated, or quit the app during sign up. It's important to keep the signupflow in its set order otherwise this will not work. Returns nil if nothing is nil (user compeleted sign up)
    func getFirstNilInSignUpState() -> SignUpState? {
        
        if self.isComplete() { return .done}
        
        if self.name == nil { return .name }
        
        else if self.sex == nil { return .sex}
        
        else if self.orientation == nil { return .orientation}
        
        else if self.hometown == nil{ return .hometown }
        
        
        else if self.birthday == nil { return .birthday }
        
        
        else if self.residence == nil{ return .residence }
        
        else if self.profile_image_url == nil { return .imageUpload}
        
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
    
    /// Go to EnterNameView.
    case name
    /// Go to EnterGenderView
    case sex
    /// Go to EnterOrientationView
    case orientation
    /// Go to EnterHome
    case hometown
    /// Go to EnterBirthdayView
    case birthday
    /// Go to LiveWhereView
    case residence
    /// Go to ImageUploadView
    case imageUpload
    /// Go to the home/profile screen because the user has completed the Sign up process. 
    case done
    
}
