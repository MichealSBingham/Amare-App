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
    func searchUsers(matching prefix: String, completion: @escaping (Result<([SearchedUser], [SearchedUser]), Error>) -> Void) {

        let usersQuery = db.collection("usernames").whereField("username", isGreaterThanOrEqualTo: prefix.lowercased()).whereField("username", isLessThanOrEqualTo: prefix.lowercased() + "\u{f8ff}").limit(to: 10)

        let notablesQuery = db.collection("notable_usernames_not_on_here").whereField("username", isGreaterThanOrEqualTo: prefix.lowercased()).whereField("username", isLessThanOrEqualTo: prefix.lowercased() + "\u{f8ff}").limit(to: 10)

        let dispatchGroup = DispatchGroup()

        var usersResult: Result<[SearchedUser], Error>!
        var notablesResult: Result<[SearchedUser], Error>!

        dispatchGroup.enter()
        usersQuery.getDocuments { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                let users = querySnapshot.documents.compactMap { document -> SearchedUser? in
                    try? document.data(as: SearchedUser.self)
                }
                usersResult = .success(users)
            } else if let error = error {
                usersResult = .failure(error)
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        notablesQuery.getDocuments { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                let notables = querySnapshot.documents.compactMap { document -> SearchedUser? in
                    try? document.data(as: SearchedUser.self)
                }
                notablesResult = .success(notables)
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
	
	/// Helper function for listening to user data on a collection. Use `listenForUserDataChanges(userID; String, completion: )`
	private func listenForUserDataChanges(in collection: String, userId: String, completion: @escaping (Result<AppUser, Error>) -> Void) -> ListenerRegistration {
		let listener = db.collection(collection).document(userId).addSnapshotListener { documentSnapshot, error in
			if let error = error {
				print("The error happened from grabbing the data from the listener")
				completion(.failure(error))
				return
			}

			guard let document = documentSnapshot, let data = document.data() else {
				completion(.failure(NSError(domain: "Cannot load data", code: 0, userInfo: nil))) // Or handle the error as needed
				return
			}
			
		
			

			
			if let user = document.toAppUser() {
				completion(.success(user))
			} else {
				completion(.failure(NSError(domain: "Cannot convert to app user", code: 1, userInfo: nil)))
			}

		
		}
		return listener
	}

	
	
	func listenForUser(userId: String, completion: @escaping (Result<AppUser, Error>) -> Void) -> ListenerRegistration? {
		let usersListener = listenForUserDataChanges(in: "users", userId: userId) { [self] result in
			switch result {
			case .success(let user):
				completion(.success(user))
			case .failure(let error):
				print("Error from 'users' collection: \(error)")
				let notablesListener = listenForUserDataChanges(in: "notables_not_on_here", userId: userId) { result in
					switch result {
					case .success(let user):
						completion(.success(user))
					case .failure(let error):
						print("Error from 'notables_not_on_here' collection: \(error)")
					}
				}
				completion(.failure(error))
			}
		}
		return usersListener
	}

	
	
	func fetchNatalChart(userId: String, completion: @escaping (Result<NatalChart, Error>) -> Void) {
		let db = Firestore.firestore()
		
		db.collection("users").document(userId).collection("public").document("natal_chart").getDocument { (document, error) in
			
			
			
			if let document = document, document.exists, let natalChart = try? document.data(as: NatalChart.self) {
				completion(.success(natalChart))
				return
			} else {
				// if not found in 'users', search in 'notables_not_on_here'
				db.collection("notables_not_on_here").document(userId).collection("public").document("natal_chart").getDocument { (document, error) in
					if let error = error {
						completion(.failure(error))
						return
					}
					
					guard let document = document, document.exists, let natalChart = try? document.data(as: NatalChart.self) else {
						completion(.failure(NSError(domain: "Cannot convert to NatalChart", code: 1, userInfo: nil)))
						return
					}
					
					completion(.success(natalChart))
				}
			}
		}
	}
	
	

	/// TODO: maybe make a cloud function to validatie this to make sure the friend request indeed does NOT send if the sending user already has an open friend request FROM them
	/// check if user has open friend request FROM the user they are sending it TO first before allow ing this process
	///    e.g. Micheal sends a friend request to Elizabeth
	func sendFriendRequest(from micheal: AppUser, to elizabeth: String, completion: @escaping (Result<Void, Error>) -> Void) {
		
		guard let micheal_id = micheal.id else { completion(.failure(NSError.init(domain: "Not Signed In", code: 1))); return }
		let now = Timestamp(date: Date())
			
		let outgoingFriendRequest = OutgoingFriendRequest(id: elizabeth, status: .pending, from: micheal_id, to: elizabeth, time: now)
		
		let incomingFriendRequestForOtherUser = IncomingFriendRequest(id: micheal_id, status: .pending, isNotable: micheal.isNotable, name: micheal.name, profileImageURL: micheal.profileImageUrl ?? "", from: micheal_id, time: now)
			
		// Create an outgoing request document.
		db.collection("users").document(micheal_id).collection("outgoingRequests").document(elizabeth)
			.setData(outgoingFriendRequest.asDictionary()) { err in
				if let err = err {
					completion(.failure(err))
				} else {
					// Create an incoming request document for the other user.
					self.db.collection("users").document(elizabeth).collection("incomingRequests").document(micheal_id)
						.setData(incomingFriendRequestForOtherUser.asDictionary()) { err in
							if let err = err {
								completion(.failure(err))
							} else {
								completion(.success(()))
							}
						}
				}
			}
	}

	
	func listenForFriendshipStatus(currentUserID: String, otherUserID: String, completion: @escaping (Result<UserFriendshipStatus, Error>) -> Void) -> [ListenerRegistration] {
		var listeners: [ListenerRegistration] = []

		let outgoingRequestListener = db.collection("users").document(currentUserID).collection("outgoingRequests").document(otherUserID).addSnapshotListener { snapshot, error in
			if let error = error {
				completion(.failure(error))
			} else if let snapshot = snapshot, let data = snapshot.data() {
				let outgoingRequest = try? snapshot.data(as: OutgoingFriendRequest.self)
				completion(.success(outgoingRequest?.status == .friends ? .friends : .requested))
			} else {
				// If there's no outgoing request, check for incoming request
				let incomingRequestListener = self.db.collection("users").document(currentUserID).collection("incomingRequests").document(otherUserID).addSnapshotListener { snapshot, error in
					if let error = error {
						completion(.failure(error))
					} else if let snapshot = snapshot, let data = snapshot.data() {
						let incomingRequest = try? snapshot.data(as: IncomingFriendRequest.self)
						completion(.success(incomingRequest?.status == .friends ? .friends : .awaiting))
					} else {
						completion(.success(.notFriends))
					}
				}
				listeners.append(incomingRequestListener)
			}
		}

		listeners.append(outgoingRequestListener)
		return listeners
	}

	
	func listenForOutgoingRequest(currentUserID: String, otherUserID: String, completion: @escaping (Result<UserFriendshipStatus, Error>) -> Void) -> ListenerRegistration {
		let outgoingRequestListener = db.collection("users").document(currentUserID).collection("outgoingRequests").document(otherUserID).addSnapshotListener { snapshot, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			guard let snapshot = snapshot, let data = snapshot.data() else {
				completion(.success(.notFriends))
				return
			}
			let outgoingRequest = try? snapshot.data(as: OutgoingFriendRequest.self)
			if outgoingRequest?.status == .friends {
				completion(.success(.friends))
			} else {
				completion(.success(.requested))
			}
		}
		return outgoingRequestListener
	}

	func listenForIncomingRequest(currentUserID: String, otherUserID: String, completion: @escaping (Result<UserFriendshipStatus, Error>) -> Void) -> ListenerRegistration {
		let incomingRequestListener = db.collection("users").document(currentUserID).collection("incomingRequests").document(otherUserID).addSnapshotListener { snapshot, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			guard let snapshot = snapshot, let data = snapshot.data() else {
				completion(.success(.notFriends))
				return
			}
			let incomingRequest = try? snapshot.data(as: IncomingFriendRequest.self)
			if incomingRequest?.status == .friends {
				completion(.success(.friends))
			} else {
				completion(.success(.awaiting))
			}
		}
		return incomingRequestListener
	}

	
	func listenForAllIncomingRequests(userId: String, completion: @escaping (Result<[IncomingFriendRequest], Error>) -> Void) -> ListenerRegistration {
		
		let incomingRequestsReference = db.collection("users").document(userId).collection("incomingRequests")

		let listener = incomingRequestsReference.addSnapshotListener { (snapshot, error) in
			if let error = error {
				completion(.failure(error))
				return
			}

			guard let snapshot = snapshot else {
				completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Snapshot is nil"])))
				return
			}

			let incomingFriendRequests: [IncomingFriendRequest] = snapshot.documents.compactMap { document in
				try? document.data(as: IncomingFriendRequest.self)
			}

			completion(.success(incomingFriendRequests))
		}

		return listener
	}


		


	
}
