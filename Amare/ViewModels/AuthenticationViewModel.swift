//
//  AuthenticationViewModel.swift
//  Amare
//
//  Created by Micheal Bingham on 5/21/23.
//

import Foundation
import FirebaseAuth


class AuthenticationViewModel: ObservableObject {
	private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?

	@Published var state: AuthState = .loggedOut

	init() {
		authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
			if let user = user {
				self.state = .loggedIn
			} else {
				self.state = .loggedOut
			}
		}
	}

	func signOut() {
		do {
			try Auth.auth().signOut()
		} catch {
			print("Error signing out: \(error.localizedDescription)")
		}
	}
}


enum AuthState {
	case loggedIn
	case loggedOut
}
