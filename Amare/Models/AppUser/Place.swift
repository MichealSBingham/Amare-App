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
	
	var address: String?
	var city: String?
	var state: String?
	var country: String?
	
	var geohash: String?
	
	static func == (lhs: Place, rhs: Place) -> Bool {
			return
				lhs.latitude == rhs.latitude &&
				lhs.longitude == rhs.longitude
		}
	
	// Function to generate a random Place
		static func generateRandomPlace() -> Place {
			let places = [
				Place(latitude: 37.7749, longitude: -122.4194, city: "San Francisco", state: "California", country: "United States", geohash: "9q8yy"),
				Place(latitude: 40.7128, longitude: -74.0060, city: "New York", state: "New York", country: "United States", geohash: "dr5ru"),
				Place(latitude: 51.5074, longitude: -0.1278, city: "London", state: nil, country: "United Kingdom", geohash: "gcpv4"),
				Place(latitude: 48.8566, longitude: 2.3522, city: "Paris", state: nil, country: "France", geohash: "u09tv"),
				Place(latitude: 35.6895, longitude: 139.6917, city: "Tokyo", state: nil, country: "Japan", geohash: "xn775"),
				Place(latitude: 41.3851, longitude: 2.1734, city: "Barcelona", state: nil, country: "Spain", geohash: "sp3e1"),
				Place(latitude: 52.5200, longitude: 13.4050, city: "Berlin", state: nil, country: "Germany", geohash: "u33db"),
				Place(latitude: 37.7749, longitude: -122.4185, city: "Berkeley", state: "California", country: "United States", geohash: "9q8yy"),
				Place(latitude: 34.0522, longitude: -118.2437, city: "Los Angeles", state: "California", country: "United States", geohash: "9q5cm"),
				Place(latitude: 40.4168, longitude: -3.7038, city: "Madrid", state: nil, country: "Spain", geohash: "ezkrt"),
				Place(latitude: 59.3293, longitude: 18.0686, city: "Stockholm", state: nil, country: "Sweden", geohash: "ud9vx"),
				Place(latitude: 41.9028, longitude: 12.4964, city: "Rome", state: nil, country: "Italy", geohash: "srwcg"),
				Place(latitude: 52.3702, longitude: 4.8952, city: "Amsterdam", state: nil, country: "Netherlands", geohash: "u178j"),
				Place(latitude: 35.6894, longitude: 139.6922, city: "Osaka", state: nil, country: "Japan", geohash: "xn775"),
				Place(latitude: 37.7749, longitude: -122.4192, city: "Oakland", state: "California", country: "United States", geohash: "9q8yy"),
				Place(latitude: 37.7749, longitude: -122.4180, city: "San Mateo", state: "California", country: "United States", geohash: "9q8yy"),
				Place(latitude: 37.7749, longitude: -122.4165, city: "Fremont", state: "California", country: "United States", geohash: "9q8yy"),
				Place(latitude: 37.7750, longitude: -122.4192, city: "Alameda", state: "California", country: "United States", geohash: "9q8yy"),
				Place(latitude: 37.3363, longitude: -121.8907, city: "San Jose", state: "California", country: "United States", geohash: "9q8yt"),
				Place(latitude: 34.0522, longitude: -118.2437, city: "San Diego", state: "California", country: "United States", geohash: "9q5cm"),
				Place(latitude: 37.7749, longitude: -122.4194, city: "San Francisco", state: "California", country: "United States", geohash: "9q8yy"),
				Place(latitude: 37.7749, longitude: -122.4194, city: "San Francisco", state: "California", country: "United States", geohash: "9q8yy"),
				Place(latitude: 37.7749, longitude: -122.4194, city: "San Francisco", state: "California", country: "United States", geohash: "9q8yy"),
				Place(latitude: 37.7749, longitude: -122.4194, city: "San Francisco", state: "California", country: "United States", geohash: "9q8yy"),
				Place(latitude: 37.7749, longitude: -122.4194, city: "San Francisco", state: "California", country: "United States", geohash: "9q8yy"),
				// Add more places here...
			]
			return places.randomElement()!
		}
	
}
