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
import LoremSwiftum

/// Helper class we're using to store and read data from our backend. All user data properties read from database are here.
public struct AmareUser: Codable, Equatable, Hashable, Identifiable{
    
    
    
        ///Unique user id of the user.
    @DocumentID public var id: String?
    
    var name: String? = nil
    var hometown: Place? = nil
    var birthday: Birthday? = nil
    var known_time: Bool? = nil
    var residence: Place? = nil
    var profile_image_url: String? = nil
    private(set) var images: [String]? = nil
    var sex: Sex? = nil  // male , female, non-binary, transfemale, transmale || or something else the user enters as a custom gender
    var orientation: [Sex]? = nil // M, F, MF (male and female), or A (everything)
  //  var natal_chart: NatalChart? = nil
    var username: String? = nil
    /// Default true, is only false if this isn't a real user that has downloaded the app. i.e., custom user profile that a user has added or mock data. 
    var isReal: Bool? = true
    var isNotable: Bool? = false

    let interal_ui_use_only_for_iding: UUID = UUID()
    
    /// Synastry score between the current user and this user. Set this so that the synastry score can be shown on a popup view. This is not grabbed from the database. 
    var _synastryScore: Double = 0
    
    var _chemistryScore: Double = 0
    var _sexScore: Double = 0
    var _loveScore: Double = 0
    
    /// Whether or not the current signed in user is friends with this user. 
    var areFriends: Bool? 
    
    /// Whether or not a friend request was sent to this user or not 
    var requested: Bool?
    
    /// Whether or not the singed in user should respond to a friend request from this user 
    var openFriendRequest: Bool = false 
    
    /// Whether or not the signed in user (me) winked to this user
    var winkedTo: Bool?
    
    /// Whether or not the user winked at me (the signed in user) 
    var winkedAtMe: Bool?
    
    var image: Data?
    
    var deviceID: String?
    
    var synastry_classification: String?
    var synastry_latin_phrase: String?
    
    /// Whether or not this user is within proximity of the user via geolocation, bluetooth, or multipeer 
    var isNearby: Bool? = false
	
	var supportsNearbyInteraction: Bool? 
    
	
	static private var femaleURLImages: [String] = ["https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cG9ydHJhaXR8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cG9ydHJhaXR8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
		"https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8cG9ydHJhaXR8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjN8fHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjF8fHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60"]





		static private var maleURLImages: [String] = ["https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cG9ydHJhaXR8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1504257432389-52343af06ae3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTV8fHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTR8fHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1528892952291-009c663ce843?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjZ8fHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mzd8fHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60"
		]
    
    enum CodingKeys: String, CodingKey {
        case name
        case hometown
        case known_time
        case birthday
        case residence
        case profile_image_url
        case images
        case sex
        case orientation
        case username
        case isReal
        case isNotable
		case supportsNearbyInteraction
        
       
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    /// Returns the downloaded profile image 
     func downloadProfileImage() -> Data? {

        guard self.profile_image_url != nil else { return nil  }
        
        guard image == nil else {return nil }
        
        let url = URL(string: profile_image_url!)!

        
        if let data = try? Data(contentsOf: url) {
                // Create Image and Update Image View
            //imageView.image = UIImage(data: data)
           return data
            
        } else { return  nil }
    }
    
    //TODO: Should only need username or id to distinguish 
    public static func == (lhs: AmareUser, rhs: AmareUser) -> Bool {
        
        return lhs.id == rhs.id
        
       // return (lhs.name == rhs.name && lhs.known_time == rhs.known_time && lhs.profile_image_url == rhs.profile_image_url && lhs.username == rhs.username )
    }
    
    
    /// Returns if all user data attributes for the sign up flow are completed. Or if the user completed the sign up flow, i.e. the UserData object is complete
    func isComplete() -> Bool {
        
        return (self.name != nil && self.birthday != nil && self.hometown != nil && self.residence != nil && self.profile_image_url != nil && self.sex != nil && self.orientation != nil && self.username != nil )
    }
    
    /// Returns the SignUpState the user should be sent to. So let's say the user did not complete their birthday, this will return .birthday. This is a helper function to determine what part of the sign up flow to direct the user if they failed to finish the sign up process before going to thier program. Usually it's because they logged out, got unauthenticated, or quit the app during sign up. It's important to keep the signupflow in its set order otherwise this will not work. Returns nil if nothing is nil (user compeleted sign up)
    func getFirstNilInSignUpState() -> SignUpState? {
        
        if self.isComplete() { return .done}
        
        if self.name == nil { return .name }
        
        if self.username == nil { return .name }
        
        else if self.sex == nil { return .sex}
        
        else if self.orientation == nil { return .orientation}
        
        else if self.hometown == nil{ return .hometown }
        
        
        else if self.birthday == nil { return .birthday }
        
        
        else if self.residence == nil{ return .residence }
        
        else if self.profile_image_url == nil { return .imageUpload}
        
        return nil
    
    }
    
    
	/// Generates a random user to use for UI testing
		static func random() -> AmareUser {


			let name = Lorem.fullName
			let sex = [Sex.male, Sex.female].randomElement()!

			let profile_image = sex == .male ? maleURLImages.randomElement()! : femaleURLImages.randomElement()!

			let username = Lorem.firstName

			let id = UUID().uuidString

			return AmareUser(id: id, name: name, profile_image_url: profile_image, sex: sex , username: username)
		}
    
    
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
