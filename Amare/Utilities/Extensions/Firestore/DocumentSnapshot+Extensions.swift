//
//  DocumentSnapshot+Extensions.swift
//  Amare
//
//  Created by Micheal Bingham on 7/30/23.
//

import Foundation
import Firebase

extension DocumentSnapshot {
	/// Converts a document snapshot to an AppUser object
	func toAppUser() -> AppUser? {
        //TODO: Add reasons for use
		guard let  data = self.data() else { return nil}

		let isReal = data["isReal"] as? Bool ?? true
		let residenceData = data["residence"] as? [String: Any] ?? [:]
		let name = data["name"] as? String ?? ""
		let profileImageUrl = data["profile_image_url"] as? String
		let wikipediaLink = data["wikipedia_link"] as? String
		let knownTime = data["known_time"] as? Bool ?? false
		let bio = data["bio"] as? String
		let isNotable = data["isNotable"] as? Bool ?? false
		let notes = data["notes"] as? [String] ?? []
		let images = data["images"] as? [String] ?? []
		let username = data["username"] as? String ?? ""
		let hometownData = data["hometown"] as? [String: Any] ?? [:]
		let sex = data["sex"] as? String ?? ""
		let birthdayData = data["birthday"] as? [String: Any] ?? [:]
		let orientation = data["orientation"] as? [String] ?? []
        let intentions = data["reasonsForUse"] as? [String] ?? []

		let day = birthdayData["day"] as? Int ?? 0
		let month = birthdayData["month"] as? String ?? ""
		let timestamp = birthdayData["timestamp"] as? Timestamp
		let year = birthdayData["year"] as? Int ?? 0

		let birthday = Birthday(timestamp: timestamp, month: month, day: day, year: year)

		let hometown = createPlace(from: hometownData)
		let residence = createPlace(from: residenceData)
        
        let totalFriendCount = data["totalFriendCount"] as? Double
        let isForDating = data["isForDating"] as? Bool
        let isForFriends = data["isForFriends"] as? Bool
        
        
        let locationSettingsString = data["locationSettings"] as? String ?? "OFF"
        let locationSettings = LocationPrivacySettings(rawValue: locationSettingsString)

        let traits = data["traits"] as? [String] ?? []
        let statements = data["statements"] as? [String] ?? []
        let isDiceActive = data["isDiceActive"] as? Bool ?? false
        
        let dashaThreadID = data["dashaThreadID"] as? String ?? ""
        
        let reasonsForUse = intentions.map { ReasonsForUse(rawValue: $0) ?? .dating}
        
        let stars = data["stars"] as? Int ?? 0
        let dashaSentMessages = data["sentDashaMessages"] as? Int ?? 0
        print("locationSettings: \(locationSettings) but data is \(data["locationSettings"])")

		return AppUser(
			id: self.documentID, name: name, hometown: hometown, birthday: birthday,
			knownBirthTime: knownTime, residence: residence, profileImageUrl: profileImageUrl,
			images: images, sex: Sex(rawValue: sex) ?? .none, orientation: orientation.map { Sex(rawValue: $0) ?? .none },
            username: username, isReal: isReal, isNotable: isNotable, reasonsForUse: reasonsForUse,  isForDating: isForDating, isForFriends: isForFriends, totalFriendCount: totalFriendCount, bio: bio,
            notes: notes, wikipedia_link: wikipediaLink, locationSettings: locationSettings, traits: traits, statements: statements, isDiceActive: isDiceActive, dashaThreadID: dashaThreadID, stars: stars, sentDashaMessages: dashaSentMessages
		)
	}
	
	func createPlace(from data: [String: Any]) -> Place {
		let address = data["address"] as? String
		let city = data["city"] as? String
		let country = data["country"] as? String
		let geohash = data["geohash"] as? String
		let latitude = data["latitude"] as? Double
		let longitude = data["longitude"] as? Double
		let state = data["state"] as? String

		return Place(
			latitude: latitude, longitude: longitude, address: address, city: city, state: state, country: country,
			geohash: geohash
		)
	}
}
