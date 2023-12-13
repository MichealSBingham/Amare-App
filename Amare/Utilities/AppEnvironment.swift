//
//  AppEnvironment.swift
//  Amare
//
//  Created by Micheal Bingham on 5/28/23.
//

import Foundation
import SwiftUI


struct RGQuizDismissedKey: EnvironmentKey{
	
	static let defaultValue: Binding<Bool>? = nil
	
}


extension EnvironmentValues {
	var rGquizDismissed: Binding<Bool>? {
		get { self[RGQuizDismissedKey.self] }
		set { self[RGQuizDismissedKey.self] = newValue }
	}
}
