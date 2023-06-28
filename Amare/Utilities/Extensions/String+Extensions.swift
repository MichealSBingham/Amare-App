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
