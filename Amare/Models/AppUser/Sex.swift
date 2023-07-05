//
//  Sex.swift
//  Amare
//
//  Created by Micheal Bingham on 6/28/23.
//

import Foundation


enum Sex: String, Codable  {
	case male
	case female
	case transfemale
	case transmale
	case non_binary
	case none //  only used for purposes of creating a binding... this value will never be in the database
	
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
		case .none:
			return "none"
		case .non_binary:
			return "non binary"
		}
	}

}
