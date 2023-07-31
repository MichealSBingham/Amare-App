//
//  Birthday.swift
//  Amare
//
//  Created by Micheal Bingham on 6/25/23.
//

import Foundation
import FirebaseFirestore
import Firebase

struct Birthday: Codable{
	
	var timestamp: Timestamp?
var month: String?
	var day: Int?
	var year: Int?
	
	

	
	
	// Function to generate a random Birthday
		static func generateRandomBirthday() -> Birthday {
			// Generate random date
			
			let currentDate = Date()
			let maxAge: TimeInterval = 70 * 365 * 24 * 60 * 60 // Maximum age in seconds (70 years)
			let minAge: TimeInterval = 14 * 365 * 24 * 60 * 60 // Minimum age in seconds (14 years)

			// Calculate the minimum and maximum time intervals based on age
			let maxTimeInterval = currentDate.timeIntervalSince1970 - minAge
			let minTimeInterval = currentDate.timeIntervalSince1970 - maxAge

			// Generate a random time interval within the specified range
			let randomTimeInterval = Double.random(in: minTimeInterval...maxTimeInterval)

			// Create a random date using the generated time interval
			let randomDate = Date(timeIntervalSince1970: randomTimeInterval)

			
			
			// Extract date components
			let calendar = Calendar.current
			let components = calendar.dateComponents([.year, .month, .day], from: randomDate)
			
			// Create Birthday instance
			return Birthday(timestamp: Timestamp(date: randomDate)/*, month: calendar.monthSymbols[components.month! - 1], day: components.day, year: components.year*/)
		}
	
	
	 
	func approximateAgeText() -> String {
			guard let timestamp = timestamp else {
				return "Unknown Age"
			}

			let currentDate = Date()
			let calendar = Calendar.current
			let currentYear = calendar.component(.year, from: currentDate)

			let birthDate = timestamp.dateValue()
			let birthYear = calendar.component(.year, from: birthDate)
			let age = currentYear - birthYear

			if age <= 17 {
				return "\(age)"
			} else if age <= 23 {
				return "early 20s"
			} else if age <= 26 {
				return "mid 20s"
			} else if age <= 29 {
				return "late 20s"
			} else if age <= 39 {
				return "\(age - 20)0s"
			} else if age <= 49 {
				return "early 40s"
			} else if age <= 59 {
				return "late 40s"
			} else if age <= 69 {
				return "\(age - 50)0s"
			} else if age <= 79 {
				return "early 70s"
			} else if age <= 89 {
				return "late 70s"
			} else if age <= 99 {
				return "\(age - 90)0s"
			} else {
				return "100+"
			}
		}

}



