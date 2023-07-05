//
//  Place.swift
//  Amare
//
//  Created by Micheal Bingham on 6/25/23.
//

import Foundation

struct Place: Codable, Equatable  {
	
	
	var latitude: Double?
	var longitude: Double?
	
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
