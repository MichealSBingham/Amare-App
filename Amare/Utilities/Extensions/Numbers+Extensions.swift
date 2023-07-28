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
