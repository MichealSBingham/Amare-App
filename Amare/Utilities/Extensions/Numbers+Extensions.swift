//
//  Numbers+Extensions.swift
//  Amare
//
//  Created by Micheal Bingham on 7/27/23.
//

import Foundation

extension BinaryFloatingPoint {
	/// Converts decimal degrees to degrees, minutes, seconds
	var dms: String {
		var seconds = Int(self * 3600)
		let degrees = seconds / 3600
		seconds = abs(seconds % 3600)
		
		let minutes = seconds / 60
		let Seconds = seconds % 60
		
		
		return "\(degrees)°\(minutes)'\(Seconds)\""
		
	}
	
	var dm: String {
		var seconds = Int(self * 3600)
		let degrees = seconds / 3600
		seconds = abs(seconds % 3600)
		
		let minutes = seconds / 60
		let Seconds = seconds % 60
		
		
		return "\(degrees)°\(minutes)'"
		
	}
	
	
}

extension Double {
    func formattedWithAbbreviations() -> String {
        let number = abs(self)
        let sign = (self < 0) ? "-" : ""

        func format(_ value: Double) -> String {
            if floor(value) == value {
                // Return as an integer if there's no fractional part
                return "\(Int(value))"
            } else {
                // Return as a floating point number with fractional part
                return "\(value)"
            }
        }

        switch number {
        case 1_000_000_000_000...:
            let formattedNumber = (number / 1_000_000_000_000).rounded(toPlaces: 1)
            return "\(sign)\(format(formattedNumber))T"
        case 1_000_000_000...:
            let formattedNumber = (number / 1_000_000_000).rounded(toPlaces: 1)
            return "\(sign)\(format(formattedNumber))B"
        case 1_000_000...:
            let formattedNumber = (number / 1_000_000).rounded(toPlaces: 1)
            return "\(sign)\(format(formattedNumber))M"
        case 1_000...:
            let formattedNumber = (number / 1_000).rounded(toPlaces: 1)
            return "\(sign)\(format(formattedNumber))K"
        default:
            // Use the format function to handle numbers less than 1000
            return "\(sign)\(format(self))"
        }
    }
}

// Rest of the extension and protocol remains the same


// Rest of the extension and protocol remains the same


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


protocol FormattableNumber {
    func formattedWithAbbreviations() -> String
}

extension FormattableNumber where Self: CVarArg {
    func formattedWithAbbreviations() -> String {
        let number = Double("\(self)") ?? 0
        return number.formattedWithAbbreviations() // Reuse the Double extension logic
    }
}

// Make Double, Int, Float conform to FormattableNumber
extension Double: FormattableNumber {}
extension Int: FormattableNumber {}
extension Float: FormattableNumber {}

 
