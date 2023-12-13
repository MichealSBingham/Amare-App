//
//  NextButtonView.swift
//  Amare
//
//  Created by Micheal Bingham on 6/24/23.
//

import SwiftUI

struct NextButtonView: View {
	var action: () -> Void
    var text: String = "Next"
	
	
	var body: some View {
		Button(action: {
			self.action()
		}) {
			Text(text)
					   .font(.headline)
					   .foregroundColor(.white)
					   .padding()
					   .frame(maxWidth: .infinity)
					   .background(Color.amare)
					   .clipShape(Capsule())
					   .padding(.horizontal)
		}
		
	}
}


struct NextButtonView_Previews: PreviewProvider {
    static var previews: some View {
		NextButtonView(action: {
		print("hello")})
		
    }
}
