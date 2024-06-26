//
//  AppUser.swift
//  Amare
//
//  Created by Micheal Bingham on 7/2/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import SwiftUI
import LoremSwiftum
import FirebaseFirestore
import MapKit

struct AppUser: Codable, Identifiable {
	@DocumentID public var id: String?
	
	var name: String
	var hometown: Place
	var birthday: Birthday
	var knownBirthTime: Bool
	var residence: Place?
	var profileImageUrl: String?
	var images: [String] = []
	var sex: Sex
	var orientation: [Sex] = []
	
	var username: String
	var phoneNumber: String?
	var isReal: Bool = true
	var isNotable: Bool = false
	var reasonsForUse: [ReasonsForUse] = []
    var isForDating: Bool?
    var isForFriends: Bool?
    
    var totalFriendCount: Double?
	
	// For Celebrites Only
	var bio: String?
	var notes: [String]?
	var wikipedia_link: String?
    
    var location: GeoPoint?  // Firestore GeoPoint for latitude and longitude
    var geohash: String?     // Geohash representation of the location
    
    var locationSettings: LocationPrivacySettings? 
    
    var traits: [String] = []
    var statements: [String] = []
    
    var isDiceActive: Bool? = false
    var dashaThreadID: String?
    
    var stars: Int? = 6
    var sentDashaMessages: Int? = 0
    

	enum CodingKeys: String, CodingKey {
		case id
		case name
		case hometown
		case birthday
		case knownBirthTime = "known_time"
		case residence
		case profileImageUrl = "profile_image_url"
		case images
		case sex
		case orientation
		
		case username
		case phoneNumber
		case isReal
		case isNotable
		case reasonsForUse
        case isForDating
        case isForFriends
        case totalFriendCount
		
		case notes
		case wikipedia_link
        
		case bio
        
        case location
        case geohash
        
        case locationSettings
        
        case traits
        case isDiceActive
        
        case statements
        case dashaThreadID
        
        case stars
        case sentDashaMessages
        
	}

	
  

	
	
	///Generates random mock data
	///- Warning: Does not yet generate random images (other than profile image) OR reasons for use ( it just automatically shows all)
	static func generateMockData() -> AppUser {
			// Generating random Place and Birthday instances
			let randomHometown = Place.generateRandomPlace()
			let randomBirthday = Birthday.generateRandomBirthday()
		
		 var femaleURLImages: [String] = ["https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cG9ydHJhaXR8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cG9ydHJhaXR8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
			"https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8cG9ydHJhaXR8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjN8fHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjF8fHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60"]





			 var maleURLImages: [String] = ["https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cG9ydHJhaXR8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1504257432389-52343af06ae3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTV8fHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTR8fHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1528892952291-009c663ce843?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjZ8fHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mzd8fHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60"
			]

			// Generating random values for the other properties
		
		let name = Lorem.fullName
		let sex = [Sex.male, Sex.female].randomElement()!
		let randomOrientation = [[Sex.male, Sex.female].randomElement()!]
		
		let profile_image = sex == .male ? maleURLImages.randomElement()! : femaleURLImages.randomElement()!

		let username = Lorem.firstName.lowercased()

		let randomUserID = "\(arc4random())"
	
			
		let randomNumber = "+1-555-555-\(Int.random(in: 1000...9999))"
		let randomIsReal = Int.random(in: 1...100) <= 80
		let randomIsNotable = Bool.random()
		let randomReasonsForUse: [ReasonsForUse] = [.friendship, .dating, .selfDiscovery]
        
        let traits = PredictedTrait.uniqueTraits.likelyTraitNames()
        let statements = PersonalityStatement.random(n: 10)
        let s = statements.map { state in
            return state.description
        }

			// Creating and returning the AppUser instance
			return AppUser(
				id: randomUserID,
				name: name,
				hometown: randomHometown,
				birthday: randomBirthday,
				knownBirthTime: Bool.random(),
				residence: Place.generateRandomPlace(),
				profileImageUrl: profile_image,
				images: [],
				sex: sex,
				orientation: randomOrientation,
				username: username,
				phoneNumber: randomNumber,
				isReal: randomIsReal,
				isNotable: randomIsNotable,
				reasonsForUse: randomReasonsForUse,
                isForDating: Bool.random(),
                isForFriends: Bool.random(),
                totalFriendCount: Double.random(in: 0..<7000000000),
                locationSettings: [.off, .approximate, .on].randomElement()!,
                traits: traits,
                statements: s,
                isDiceActive: Bool.random()
			)
		}
    
    static func generateMockData(of length: Int) -> [AppUser] {
       return  (1...length).map { _ in AppUser.generateMockData() }
    }
}


enum ReasonsForUse: String, Codable {
    case friendship, dating, selfDiscovery
}


extension AppUser {
    func distance(to otherUser: AppUser) -> CLLocationDistance? {
        guard let myLocation = self.location?.toCLLocation(),
              let otherLocation = otherUser.location?.toCLLocation() else {
            return nil
        }
        return myLocation.distance(from: otherLocation)
    }
}
