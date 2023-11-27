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
import FirebaseStorage
import CoreLocation
import GeohashKit

class FirestoreService {
    
    static let shared = FirestoreService()
    
    public let db = Firestore.firestore()
    
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
    
    func searchRegularUsers(matching prefix: String, completion: @escaping (Result<[SearchedUser], Error>) -> Void) {
        let usersQuery = db.collection("usernames").whereField("username", isGreaterThanOrEqualTo: prefix.lowercased()).whereField("username", isLessThanOrEqualTo: prefix.lowercased() + "\u{f8ff}").limit(to: 10)

        usersQuery.getDocuments { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                let users = querySnapshot.documents.compactMap { document -> SearchedUser? in
                    try? document.data(as: SearchedUser.self)
                }
                completion(.success(users))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }

    func searchNotableUsersNotOnHere(matching prefix: String, completion: @escaping (Result<[SearchedUser], Error>) -> Void) {
        let notablesQuery = db.collection("notable_usernames_not_on_here").whereField("username", isGreaterThanOrEqualTo: prefix.lowercased()).whereField("username", isLessThanOrEqualTo: prefix.lowercased() + "\u{f8ff}").limit(to: 10)

        notablesQuery.getDocuments { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                let notables = querySnapshot.documents.compactMap { document -> SearchedUser? in
                    try? document.data(as: SearchedUser.self)
                }
                completion(.success(notables))
            } else if let error = error {
                completion(.failure(error))
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
                print("\n\n\n\nthe user friend number is .. \(user.totalFriendCount)") // this is where it is 0
                print("the user data is \(user)\n\n\n")
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
    
    
    
    func listenForNatalChartChanges(userId: String, completion: @escaping (Result<NatalChart, Error>) -> Void) -> ListenerRegistration? {
        let db = Firestore.firestore()
        
       let natalChartListener =  db.collection("users").document(userId).collection("public").document("natal_chart").addSnapshotListener { (document, error) in
            
            
            
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
        return nil
    }
    
    
    
    
    func sendFriendRequest(from micheal: AppUser, to dasha: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let micheal_id = micheal.id else { completion(.failure(NSError.init(domain: "Not Signed In", code: 1))); return }
        let now = Timestamp(date: Date())
        
        let outgoingFriendRequest = OutgoingFriendRequest(id: dasha, status: .pending, from: micheal_id, /*to: dasha,*/ time: now)
        
        let incomingFriendRequestForOtherUser = IncomingFriendRequest(id: micheal_id, status: .pending, isNotable: micheal.isNotable, name: micheal.name, profileImageURL: micheal.profileImageUrl ?? "", from: micheal_id, time: now)
        
        // Create an outgoing request document.
        db.collection("users").document(micheal_id).collection("outgoingRequests").document(dasha)
            .setData(outgoingFriendRequest.asDictionary()) { err in
                if let err = err {
                    completion(.failure(err))
                } else {
                    
                    // Create an incoming request document for the other user.
                    self.db.collection("users").document(dasha).collection("incomingRequests").document(micheal_id)
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
    
    func cancelFriendRequest(to dasha: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        
        
        guard let micheal_id = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError.init(domain: "Not Signed In", code: 1)))
            return
        }
        // Reference to the outgoing request document.
        let outgoingRequestRef = db.collection("users").document(micheal_id).collection("outgoingRequests").document(dasha)
        
        // Delete the outgoing request document.
        outgoingRequestRef.delete() { err in
            if let err = err {
                completion(.failure(err))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func declineFriendRequest(from senderID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        // Ensure the current user isn't trying to decline a request from themselves
        guard let currentSignedInUserID = Auth.auth().currentUser?.uid, senderID != currentSignedInUserID else {
            completion(.failure(NSError.init(domain: "Cannot decline a friend request from yourself", code: 1)))
            
            return
        }
        
        // Reference to the incoming request document.
        let incomingRequestRef = db.collection("users").document(currentSignedInUserID).collection("incomingRequests").document(senderID)
        
        // Delete the incoming request document.
        incomingRequestRef.delete() { err in
            if let err = err {
                completion(.failure(err))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func acceptFriendRequest(from senderID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        // Ensure the current user isn't trying to accept a request from themselves
        guard let currentSignedInUserID = Auth.auth().currentUser?.uid, senderID != currentSignedInUserID else {
            print("Cannot accept a friend request from yourself")
            completion(.failure(NSError.init(domain: "Cannot accept a friend request from yourself", code: 3)))
            return
        }
        
        // Reference to the incoming request document.
        let incomingRequestRef = db.collection("users").document(currentSignedInUserID).collection("incomingRequests").document(senderID)
        
        // Update the status of the incoming request to "friends".
        incomingRequestRef.updateData(["status": "friends"]) { err in
            if let err = err {
                completion(.failure(err))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    func sendWink(from micheal: AppUser, to dasha: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let micheal_id = micheal.id else { completion(.failure(NSError.init(domain: "Not Signed In", code: 1))); return }
        let now = Timestamp(date: Date())
        
        let outgoingWink = OutgoingWink(id: dasha,  from: micheal_id, time: now)
        
        let incomingWink = IncomingWink(id: micheal_id,  isNotable: micheal.isNotable, name: micheal.name, profileImageURL: micheal.profileImageUrl ?? "", from: micheal_id, time: now)
        
        // Create an outgoing request document.
        db.collection("users").document(micheal_id).collection("outgoingWinks").document(dasha)
            .setData(outgoingWink.asDictionary()) { err in
                if let err = err {
                    completion(.failure(err))
                } else {
                    
                    // Create an incoming request document for the other user.
                    self.db.collection("users").document(dasha).collection("incomingWinks").document(micheal_id)
                        .setData(incomingWink.asDictionary()) { err in
                            if let err = err {
                                completion(.failure(err))
                            } else {
                                completion(.success(()))
                            }
                        }
                    
                }
            }
    }
    
    func cancelWink(to dasha: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        
        
        guard let micheal_id = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError.init(domain: "Not Signed In", code: 1)))
            return
        }
        // Reference to the outgoing request document.
        let outgoingWinkRef = db.collection("users").document(micheal_id).collection("outgoingWinks").document(dasha)
        
        // Delete the outgoing request document.
        outgoingWinkRef.delete() { err in
            if let err = err {
                completion(.failure(err))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func listenForIncomingWink(to currentUserID: String, from otherUserID: String, completion: @escaping (Result<IncomingWink?, Error>) -> Void) -> ListenerRegistration {
        let incomingWinksListener = db.collection("users").document(currentUserID).collection("incomingWinks").document(otherUserID).addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let snapshot = snapshot, let data = snapshot.data() else {
                completion(.success(nil))
                return
            }
            let incomingWink = try? snapshot.data(as: IncomingWink.self)
            
            completion(.success(incomingWink))
        }
        return incomingWinksListener
    }
    
    
    
    
    
    
    func listenForFriendshipStatus(currentUserID: String, otherUserID: String, completion: @escaping (Result<UserFriendshipStatus, Error>) -> Void) -> [ListenerRegistration] {
        var listeners: [ListenerRegistration] = []
        
        let outgoingRequestListener = db.collection("users").document(currentUserID).collection("outgoingRequests").document(otherUserID).addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot, let data = snapshot.data() {
                
                let outgoingRequest = try? snapshot.data(as: OutgoingFriendRequest.self)
                print("completion listenForFriendshipStatus: data: \(data)\n and status: \(outgoingRequest)")
                completion(.success(outgoingRequest?.status == .friends ? .friends : .requested))
            } else {
                // If there's no outgoing request, check for incoming request
                let incomingRequestListener = self.db.collection("users").document(currentUserID).collection("incomingRequests").document(otherUserID).addSnapshotListener { snapshot, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let snapshot = snapshot, let data = snapshot.data() {
                        let incomingRequest = try? snapshot.data(as: IncomingFriendRequest.self)
                        print("completion listenForFriendshipStatus: data: \(data)\n and status: \(incomingRequest)")
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
            }.filter { $0.status != .friends }
            
            
            
            completion(.success(incomingFriendRequests))
        }
        
        return listener
    }
    
    
    
    func listenForAllCustomProfiles(for userId: String, completion: @escaping (Result<[AppUser], Error>) -> Void) -> ListenerRegistration {
        
        let customProfilesRef = db.collection("users").document(userId).collection("customProfiles")
        
        let listener = customProfilesRef.addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Snapshot is nil"])))
                return
            }
            
            let customProfiles: [AppUser] = snapshot.documents.compactMap { document in
                try? document.data(as: AppUser.self)
            }
            
            completion(.success(customProfiles))
        }
        
        return listener
    }
    
    func listenForAllFriends(for userId: String, completion: @escaping (Result<[Friend], Error>) -> Void) -> ListenerRegistration {
        
        let friends = db.collection("users").document(userId).collection("myFriends")
        
        let listener = friends.addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Snapshot is nil"])))
                return
            }
            
            let friends: [Friend] = snapshot.documents.compactMap { document in
                try? document.data(as: Friend.self)
            }
            
            completion(.success(friends))
        }
        
        return listener
    }
    
    
    func listenForInterpretations(for userId: String, completion: @escaping (Result<[String: String], Error>) -> Void) -> ListenerRegistration {
        
        let natalChartRef = db.collection("users").document(userId).collection("public").document("natal_chart")
        
        let listener = natalChartRef.addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Snapshot is nil"])))
                return
            }
            
            guard let data = snapshot.data() else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data is nil"])))
                return
            }
            
            if let interpretations = data["interpretations"] as? [String: String] {
                completion(.success(interpretations))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Interpretations not found"])))
            }
        }
        
        return listener
    }
    
    
    func createCustomUser(forUser userID: String, with data: AppUser, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let uniqueID = UUID().uuidString
        
        
        
        do {
            try self.db.collection("users").document(userID).collection("customProfiles").document(uniqueID).setData(from: data) { error in
                if let error = error {
                    
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
    
    
    
    
    func uploadImageToFirebaseStorage(imageData: Data, completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard let userID = Auth.auth().currentUser?.uid else {
            // user is not signed in
            completion(.failure(AccountError.notSignedIn))
            return
        }
        
        let storageRef = Storage.storage().reference().child("users/\(userID)/pictures/profileImage.jpg")
        
        // Set the content type to image/jpeg
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload the file to the path "/users/{userID}/pictures/profileImage.jpg"
        storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            guard metadata != nil else {
                // Handle error
                completion(.failure(error!))
                return
            }
            
            // Get the download URL
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Handle error
                    completion(.failure(error!))
                    return
                }
                completion(.success(downloadURL))
            }
        }
    }
    
    func updateCurrentUserLocation(_ location: CLLocation, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "FirestoreService", code: 0, userInfo: [NSLocalizedDescriptionKey: "User ID not found"]))
            return
        }
        
        if let geohashObject = Geohash(coordinates: (location.coordinate.latitude, location.coordinate.longitude), precision: 9) {
            let geohashString = String(describing: geohashObject.geohash)
            let locationData: [String: Any] = [
                "location": GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
                "geohash": geohashString,  // Storing as a String
                "geohash6": location.geohash(precision: 6) ?? ""
            ]
            
            db.collection("users").document(userId).updateData(locationData) { error in
                if let error = error {
                    print("Error updating location: \(error)")
                    completion(error)
                } else {
                    print(" \(geohashString) Location successfully updated for user \(userId)")
                    completion(nil)
                }
            }
        } else {
            let error = NSError(domain: "FirestoreService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Geohash generation failed"])
            completion(error)
        }
    }
    
    func updateGeohashEntryExit(newGeohash: String, oldGeohash: String, location: CLLocation, completion: ((Error?) -> Void)? = nil) {
            guard let userId = Auth.auth().currentUser?.uid, !userId.isEmpty else {
                completion?(NSError(domain: "FirestoreService", code: 0, userInfo: [NSLocalizedDescriptionKey: "User ID not found"]))
                return
            }

            let timestamp = Timestamp(date: Date())

            // Handle the old geohash being empty (e.g., first time location update)
            if !oldGeohash.isEmpty && oldGeohash != newGeohash {
                let oldUserRef = db.collection("encounters").document(oldGeohash).collection("users").document(userId)
                oldUserRef.updateData(["exitTimestamp": timestamp]) { error in
                    completion?(error)
                }
            }

            // Always update the entry timestamp for the new geohash
            let newUserRef = db.collection("encounters").document(newGeohash).collection("users").document(userId)
            newUserRef.setData(["enterTimestamp": timestamp], merge: true) { error in
                completion?(error)
            }

            // Update user's current 9-digit geohash location
            let geohash9 = location.geohash(precision: 9) ?? ""
            let locationData: [String: Any] = [
                "location": GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
                "geohash": geohash9
            ]
            db.collection("users").document(userId).updateData(locationData) { error in
                completion?(error)
            }
        }
    func listenForUsers(near geohash: String, completion: @escaping (Result<[AppUser], Error>) -> Void) -> ListenerRegistration? {
        print("FirestoreService.listenForUsers near geohash \(geohash)")
            guard !geohash.isEmpty else {
                completion(.failure(NSError(domain: "FirestoreService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Geohash is empty"])))
                return nil
            }

            guard let geohashObject = Geohash(geohash: geohash) else {
                completion(.failure(NSError(domain: "FirestoreService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Geohash generation failed"])))
                return nil
            }

            let neighbors = geohashObject.neighbors
            let allGeohashes = (neighbors?.all.map { $0.geohash } ?? []) + [geohash]
        
            print("all geohases: \(allGeohashes)")

            let usersListener = db.collection("users")
                .whereField("geohash6", in: allGeohashes)
                .addSnapshotListener { snapshot, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    guard let documents = snapshot?.documents else {
                        print("could not get documents for nearby users .. \(snapshot?.documents)")
                        completion(.success([]))
                        return
                    }
                    print("the documents are ... \(snapshot?.documents)")
                    let users = documents.compactMap { try? $0.data(as: AppUser.self) }
                    completion(.success(users))
                }
            
            return usersListener
        }
}
