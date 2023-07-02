//
//  FirestoreService.swift
//  Amare
//
//  Created by Micheal Bingham on 6/22/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class FirestoreService {
	
	static let shared = FirestoreService()
	
	private let db = Firestore.firestore()
	
	private init() {}
	
	
	/// Checks if the given username exists.
	///
	/// This function checks the availability of a username based on the application's current environment.
	/// If the environment is set to 'production', it will fetch data from the Firestore database.
	/// Otherwise, for testing or development environment, it will simulate a delay and return a random result.
	///
	/// - Parameter username: The username to check for existence.
	/// - Parameter completion: The completion handler to call when the checking is complete. This completion handler takes a single argument: `Result<Bool, Error>`. On success, it returns `true` if the username exists and `false` otherwise. On failure, it returns `Error`.
	///
	///
	///
	/// - Author: Micheal Bingham
	///
	/// - Returns: Void
	///
	func doesUsernameExist(_ username: String, completion: @escaping (Result<Bool, Error>) -> Void) {
		switch AppConfig.environment {
		case .development:
			DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
				let usernameExists = Bool.random()
				completion(.success(usernameExists))
			}
			
		default:
			
			
			let usernamesRef = self.db.collection("usernames")
			
			usernamesRef.document(username).getDocument { (snapshot, error) in
				if let error = error {
					completion(.failure(error))
				} else {
					let usernameExistsInUsernames = snapshot?.exists ?? false
					
					if usernameExistsInUsernames {
						completion(.success(true))
					} else {
						let notableUsernamesRef = self.db.collection("notable_usernames_not_on_here")
						notableUsernamesRef.document(username).getDocument { (snapshot, error) in
							if let error = error {
								completion(.failure(error))
							} else {
								let usernameExistsInNotableUsernames = snapshot?.exists ?? false
								completion(.success(usernameExistsInNotableUsernames))
							}
						}
					}
				}
			}
		}
	}

	
	
	
}
