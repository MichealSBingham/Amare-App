//
//  String+Extensions.swift
//  Amare
//
//  Created by Micheal Bingham on 6/27/23.
//

import Foundation


extension String {
	var firstName: String {
		return self.components(separatedBy: " ").first ?? ""
	}
}


extension String {
	
	/// -  WARNING: Does not work for international numbers , need a better phone number validator
	func isValidPhoneNumber() -> Bool {
		if self.count < 12 { return false }
		let regEx = "^\\+(?:[0-9]?){6,14}[0-9]$"
        
		let phoneCheck = NSPredicate(format: "SELF MATCHES[c] %@", regEx)
		return phoneCheck.evaluate(with: self)
	}
	
	
	/// Converts a formatted number to a number computer can read (917) 699 0590  ~> +19176990590. The country code is selected from the View and not included in 'self'
	func computerReadable(countryCode: String) -> String {
		
		var number_to_check = (countryCode+self)
		number_to_check =  String(number_to_check.filter { !" \n\t\r".contains($0) })
		 number_to_check = number_to_check.replacingOccurrences(of: ")", with: "")
		number_to_check = number_to_check.replacingOccurrences(of: "(", with: "")
		
		return number_to_check

		
	}
	
	/// Formats phone number and returns string of formatted number
	func applyPatternOnNumbers(pattern: String, replacementCharacter: Character) -> String {
		var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
		for index in 0 ..< pattern.count {
			guard index < pureNumber.count else { return pureNumber }
			let stringIndex = String.Index(utf16Offset: index, in: pattern)
			let patternCharacter = pattern[stringIndex]
			guard patternCharacter != replacementCharacter else { continue }
			pureNumber.insert(patternCharacter, at: stringIndex)
		}
		return pureNumber
	}

	
	
}


extension String {
	
	var Digits: [Int] {
		var result = [Int]()
		
		for char in self {
			if let number = Int(String(char)) {
				result.append(number)
			}
		}
		
		return result
	}
	
}
