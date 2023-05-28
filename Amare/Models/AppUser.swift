//
//  AppUser.swift
//  Amare
//
//  Created by Micheal Bingham on 5/21/23.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI
import Firebase

 struct AppUser: Codable, Identifiable {
	@DocumentID var id: String?
	 
	var name: String
	var username: String
	var hometown: Place
	var residence: Place
	var birthday: Birthday
	var isNotable: Bool
	var isReal: Bool
	var orientation: [Sex]?
	var profileImageURL: String?
	var sex: Sex
	var traits: [String]?  // Assuming traits is an array of string descriptors
	var relationshipGoals: String?
	var loveLanguage: String?
	var gallery: [String]?  // Assuming this is an array of image URLs or video URLs
	var isBirthTimeKnown: Bool
	var relationshipStatus: RelationshipStatus
	// Add more fields as necessary

	enum CodingKeys: String, CodingKey {
		case id
		case name
		case username
		case birthday
		case hometown
		case residence
		case isNotable
		case isReal
		case orientation
		case profileImageURL = "profile_image_url"
		case sex
		case traits
		case relationshipGoals = "relationship_goals"
		case loveLanguage = "love_language"
		case gallery
		case isBirthTimeKnown = "is_birth_time_known"
		case relationshipStatus = "relationship_status"
		
	}
}


struct Birthday: Codable{
	
	var timestamp: Timestamp
	var month: String?
	var day: Int?
	var year: Int?
	
}

struct Place: Codable, Equatable  {
	
	
	var latitude: Double
	var longitude: Double
	
	var city: String?
	var state: String?
	var country: String?
	
	var geohash: String?
	
	static func == (lhs: Place, rhs: Place) -> Bool {
			return
				lhs.latitude == rhs.latitude &&
				lhs.longitude == rhs.longitude
		}
	
	
}

enum Sex: String, Codable  {
	case male
	case female
	case transfemale
	case transmale
	case non_binary
	
	func string() -> String {
		
		switch self {
		case .male:
			return "male"
		case .female:
			return "female"
		case .transfemale:
			return "transfemale"
		case .transmale:
			return  "transmale"
		case .non_binary:
			return "non binary"
		}
	}

}



enum RelationshipStatus: String, Codable{
	
	case single
	case in_a_relationship
	case open_relationship
	case complicated
	case perfer_not_to_say
	
	
	enum CodingKeys: String, CodingKey {
		case single
		case in_a_relationship = "in_a_relationship"
		case open_relationshiop = "open_relationship"
		case complicated
		case prefer_not_to_say = "perfer_not_to_say"
		
	}
	
}
