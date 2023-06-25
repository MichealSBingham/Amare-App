//
//  OnboardingViewModel.swift
//  Amare
//
//  Created by Micheal Bingham on 6/9/23.
//

import Foundation


import Foundation
import SwiftUI
import Combine
import MapKit

class OnboardingViewModel: ObservableObject{
    
    @Published var currentPage: OnboardingScreen = .name
    
    @Published var name: String?
	
    @Published var username: String = ""
	
    @Published var isUsernameAvailable: Bool?
	
	@Published var birthday: Date = Date()
	@Published var birthtime: Date = Date()
	@Published var knowsBirthTime: Bool?
	
	@Published var homeCityTimeZone: TimeZone?
	
	@Published var homeCity: MKPlacemark?
    
    
    @Published  var progress: Double = Double(OnboardingScreen.allCases.firstIndex(of: .name) ?? 0) / Double(OnboardingScreen.allCases.count - 2)
    
    //TODO: Handle error handling for `checkUsername` 
    func checkUsername() {
        
    
        
        guard  !(username.isEmpty) else { return }
        let database = FirestoreService.shared
        
            database.doesUsernameExist(username) { [weak self] result in
                switch result {
                case .success(let isAvailable):
                    DispatchQueue.main.async {
                        
                        self?.isUsernameAvailable = isAvailable
                    }
                case .failure(let error):
                    // Handle error here
                    print("Could not check if username exists \(error)")
                }
            }
        }
        
    
    
      
    
    
}



class OnboardingViewModelCHATGPT: ObservableObject {
    // Published properties to bind with SwiftUI views
    @Published var birthday: Date = Date()
    @Published var birthTime: Date = Date()
    @Published var birthTimeKnown: Bool = false
    //@Published var selectedTraits: [Trait] = []
    //@Published var relationshipGoal: RelationshipGoal?
    //@Published var loveLanguage: LoveLanguage?
    @Published var profileImage: UIImage?
    @Published var selectedHometown: String?
    
    // Services
    /*
    private let authService: AuthService
    private let firestoreService: FirestoreService
     */
    
    // Initializer
    init(/*authService: AuthService, firestoreService: FirestoreService*/) {
        /*
        self.authService = authService
        self.firestoreService = firestoreService
    */
    }
    
    // Function to handle user onboarding process
    /*
    func completeOnboarding(completion: @escaping (Result<Void, Error>) -> Void) {
        // Retrieve the authenticated user
        guard let user = authService.currentUser else {
            completion(.failure(NSError(domain: "No authenticated user", code: -1, userInfo: nil)))
            return
        }
        
        // Create a user profile object with the collected data
        let userProfile = UserProfile(
            id: user.uid,
            birthday: birthday,
            birthTime: birthTime,
            birthTimeKnown: birthTimeKnown,
            traits: selectedTraits.map { $0.id },
            relationshipGoal: relationshipGoal?.id,
            loveLanguage: loveLanguage?.id,
            profileImageURL: nil, // You need to handle uploading the image and getting the URL
            hometown: selectedHometown
        )
        
        // Save the user profile to Firestore
        firestoreService.saveUserProfile(userProfile) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
     */
}
