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
	
}



