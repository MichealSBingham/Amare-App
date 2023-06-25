//
//  UsernameAvailabilityView.swift
//  Amare
//
//  Created by Micheal Bingham on 6/24/23.
//

import SwiftUI

///This is just the view that shows a loading symbol or a check or cross when checking if the username is available or not 
struct UsernameAvailabilityView: View {
	@Binding var isUsernameAvailable: Bool?
	
	var body: some View {
		Group {
			if isUsernameAvailable == nil {
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle())
					.foregroundColor(.blue)
			} else if isUsernameAvailable == true {
				Image(systemName: "checkmark.circle")
					.foregroundColor(.green)
			} else {
				Image(systemName: "xmark.circle")
					.foregroundColor(.red)
			}
		}
	}
}


struct UsernameAvailabilityView_Previews: PreviewProvider {
    static var previews: some View {
		UsernameAvailabilityView(isUsernameAvailable: .constant(Bool(.random())))
    }
}
