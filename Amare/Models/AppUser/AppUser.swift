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


struct AppUser: Codable, Identifiable {
	@DocumentID public var id: String?
	
	var name: String
	var hometown: Place
	var birthday: Birthday
	var knownBirthTime: Bool
	var residence: Place
	var profileImageUrl: String
	var images: [String]
	var sex: Sex
	var orientation: [Sex]
	//var natalChart: NatalChart
	var username: String
	var phoneNumber: String
	var isReal: Bool = true
	var isNotable: Bool = false
	var reasonsForUse: [ReasonsForUse]

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
		//case natalChart = "natal_chart"
		case username
		case phoneNumber
		case isReal
		case isNotable
		case reasonsForUse
	}

	enum ReasonsForUse: String, Codable {
		case friendship, dating, selfDiscovery
	}
}

