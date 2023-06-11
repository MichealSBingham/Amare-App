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


class OnboardingViewModel: ObservableObject{
    
    @Published var currentPage: OnboardingScreen = .name
    
    @Published var name: String?
    
    
    
    @Published  var progress: Double = 0.0
        
    
    
      
    
    
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
