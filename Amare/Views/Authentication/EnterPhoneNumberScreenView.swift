//
//  EnterPhoneNumberScreenView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/21/23.
//

import SwiftUI

struct EnterPhoneNumberScreenView: View {
	
	@State var number: String = ""
	
    var body: some View {

		Text("Hello World")
			.navigationTitle(Text("Enter Your Phone Number"))
	}
}

struct EnterPhoneNumberScreenView_Previews: PreviewProvider {
    static var previews: some View {
        EnterPhoneNumberScreenView()
    }
}
