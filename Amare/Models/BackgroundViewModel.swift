//
//  BackgroundViewModel.swift
//  Amare
//
//  Created by Micheal Bingham on 7/1/23.
//

import Foundation
import SwiftUI


class BackgroundViewModel: ObservableObject {
	@Published var colors: [Color] = [
		Color(UIColor(red: 1.00, green: 0.01, blue: 0.40, alpha: 1.00)),
		Color(UIColor(red: 0.94, green: 0.16, blue: 0.77, alpha: 1.00))
	]
	@Published var opacity: Double = 1
	@Published var isSolidColor: Bool = false
	@Published var solidColor: Color = .white
}
