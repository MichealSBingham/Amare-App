//
//  Sex+Extensions.swift
//  Amare
//
//  Created by Micheal Bingham on 6/28/23.
//

import Foundation
import SwiftUI


extension Binding where Value == Sex {
	///Creates a mapping so that 'Sex' can be used as a bool
	func mappedToBool(for gender: Sex) -> Binding<Bool> {
		Binding<Bool>(
			get: { self.wrappedValue == gender },
			set: { if $0 { self.wrappedValue = gender } }
		)
	}
}

