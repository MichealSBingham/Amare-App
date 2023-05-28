//
//  ContentView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/21/23.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var authViewModel: AuthenticationViewModel

	var body: some View {
		Group {
			switch authViewModel.state {
			case .loggedIn:
				HomeView() // your home screen
			case .loggedOut:
				SignInView()// login/sign up screen
			}
		}
	}
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
