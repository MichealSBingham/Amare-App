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

    
    /// Do not use this. Use `setOnboardingData(forUser appUser)` instead.
    func setOnboardingData(forUser userId: String, username: String, withData data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        let group = DispatchGroup()
        
        group.enter()
        db.collection("users").document(userId).setData(data) { error in
            if let error = error {
                completion(.failure(error))
            }
            group.leave()
        }
        
        group.enter()
        db.collection("usernames").document(username).setData(["isNotable": false, "userId": userId, "username": username]) { error in
            if let error = error {
                completion(.failure(error))
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion(.success(()))
        }
    }

	
    
    // TODO: Handle the case where a username is added to the "usernames" collection
    // but the corresponding user data is not added to the "users" collection.
    // You might want to periodically check the "usernames" collection and remove
    // any documents that don't have corresponding documents in the "users" collection.
    // Consider implementing this in a Cloud Function for efficiency.
    func setOnboardingData(forUser appUser: AppUser, completion: @escaping (Result<Void, Error>) -> Void) {
        
        // Preparing the username data
        let usernameData = ["isNotable": appUser.isNotable, "userId": appUser.id, "username": appUser.username] as [String : Any]
        
        // Writing to "usernames" collection first
        db.collection("usernames").document(appUser.username).setData(usernameData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                // If "usernames" write operation is successful, then proceed to write to "users" collection
                do {
                    try self.db.collection("users").document(appUser.id!).setData(from: appUser) { error in
                        if let error = error {
                            // If "users" write operation fails, then delete the data from "usernames" collection
                            self.db.collection("usernames").document(appUser.username).delete() { error in
                                if let error = error {
                                    print("Error removing document: \(error)")
                                }
                            }
                            completion(.failure(error))
                        } else {
                            completion(.success(()))
                        }
                    }
                } catch {
                    print("Error: \(error)")
                    completion(.failure(error))
                }
            }
        }
    }

    
    
    
    /**
    Searches both the 'usernames' and 'notables_not_on_here' collections for usernames that match or start with a given prefix.

    - Parameter prefix: The string to match usernames against.
    - Parameter completion: A closure which is called when the search operation is completed. If successful, this closure returns a tuple of two arrays containing `QueryDocumentSnapshot` objects from the 'usernames' and 'notables_not_on_here' collections, respectively. If an error occurred, the closure returns an `Error` object.

    - Important: This method performs two asynchronous operations. The completion handler may not be called on the main queue. Make sure to dispatch back to the main queue if you're planning to perform UI operations inside the completion handler.
    */
    func searchUsers(matching prefix: String, completion: @escaping (Result<([QueryDocumentSnapshot], [QueryDocumentSnapshot]), Error>) -> Void) {
        
        
        let usersQuery = db.collection("usernames").whereField("username", isGreaterThanOrEqualTo: prefix.lowercased()).whereField("username", isLessThanOrEqualTo: prefix.lowercased() + "\u{f8ff}").limit(to: 10)
        
        let notablesQuery = db.collection("notable_usernames_not_on_here").whereField("username", isGreaterThanOrEqualTo: prefix.lowercased()).whereField("username", isLessThanOrEqualTo: prefix.lowercased() + "\u{f8ff}").limit(to: 10)
        
        let dispatchGroup = DispatchGroup()
        
        var usersResult: Result<[QueryDocumentSnapshot], Error>!
        var notablesResult: Result<[QueryDocumentSnapshot], Error>!
        
        dispatchGroup.enter()
        usersQuery.getDocuments { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                usersResult = .success(querySnapshot.documents)
            } else if let error = error {
                usersResult = .failure(error)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        notablesQuery.getDocuments { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                notablesResult = .success(querySnapshot.documents)
            } else if let error = error {
                notablesResult = .failure(error)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            switch (usersResult, notablesResult) {
            case (.success(let users), .success(let notables)):
                completion(.success((users, notables)))
            case (.failure(let error), _), (_, .failure(let error)):
                completion(.failure(error))
            default:
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil))) // Use your preferred way to handle errors
            }
        }
    }

	
    
    
    /**
     Retrieves all friend requests for a given user from Firestore.

     - Parameters:
        - userId: The ID of the user for whom to fetch friend requests.
        - inPreview: set to true if you are showing this in preview to show mock data
        - completion: A closure called when the retrieval is complete, containing the result of the operation. The result is either an array of `FriendRequest` objects on success or an error on failure.
     

     - Note:
        The function fetches all friend requests from the Firestore collection "friends/{userId}/requests" and provides real-time updates using a snapshot listener.

     - Important:
        Make sure to handle errors appropriately in the completion closure.

     - Example usage:
        ```
        FirestoreService.shared.getAllFriendRequests(for: "user123") { result in
            switch result {
            case .success(let friendRequests):
                // Process the retrieved friend requests
            case .failure(let error):
                // Handle the error
            }
        }
        ```
     */

    func getAllFriendRequests(for userId: String, inPreview: Bool = false, completion: @escaping (Result<[FriendRequest], Error>) -> Void) {
        let collectionPath = "friends/\(userId)/requests"
        
        
        guard !inPreview else {
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                            let sampleData = FriendRequest.randomList(count: 15)
                            DispatchQueue.main.async {
                                completion(.success(sampleData))
                            }
                        }
            
            return
        }
        
        db.collection(collectionPath).addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            var friendRequests: [FriendRequest] = []
            
            for document in snapshot?.documents ?? [] {
                if let request = try? document.data(as: FriendRequest.self) {
                    friendRequests.append(request)
                }
            }
            
            completion(.success(friendRequests))
        }
    }

	
}
