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
    /// - Note: In the 'production' environment, actual Firestore query is not yet implemented.
    ///
    /// - Author: Micheal Bingham
    ///
    /// - Returns: Void
    ///
    func doesUsernameExist(_ username: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        switch AppConfig.environment {
        
        case .production:
            
            print("ADD Production code for checking username availability {FirestoreService} ")
            
/*
            let usersRef = db.collection("users").whereField("username", isEqualTo: username)
            
            usersRef.getDocuments { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    if let snapshot = snapshot, snapshot.documents.isEmpty {
                        completion(.success(true))
                    } else {
                        completion(.success(false))
                    }
                }
            }
*/
            
        default:
            

            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let usernameExists = Bool.random()
                completion(.success(usernameExists))
            }
       
        }
       
        }
    
    
    
    
    }
    
    
    

