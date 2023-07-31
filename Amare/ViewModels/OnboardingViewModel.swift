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
import FirebaseFirestore
import Firebase


class OnboardingViewModel: ObservableObject{
    
    
    
    @Published var currentPage: OnboardingScreen = .phoneNumber
	
	@Published var phoneNumber: String?
    
    @Published var name: String?
	
    @Published var username: String = ""
	
    @Published var isUsernameAvailable: Bool?
	
	@Published var birthday: Date = Date()
	@Published var birthtime: Date = Date()
	@Published var knowsBirthTime: Bool?
	
	@Published var homeCityTimeZone: TimeZone?
	
	@Published var homeCity: MKPlacemark?
	
	@Published var gender: Sex = .none
    
    @Published var residence: MKPlacemark?
    
    @Published var profileImageUrl: String = URL.randomProfileImageURL(isMale: Bool.random())!.absoluteString
	
	
	@Published var friendshipSelected: Bool = false
	@Published var datingSelected: Bool = false
	@Published var selfDiscoverySelected: Bool = false 
    
    
    @Published  var progress: Double = Double(OnboardingScreen.allCases.firstIndex(of: .phoneNumber) ?? 0) / Double(OnboardingScreen.allCases.count - 1)
	
	@Published var error: Error?
    
	
    //TODO: Handle error handling for `checkUsername` 
    func checkUsername() {
        
    
        print("checking username (onboarding view model)")
        guard  !(username.isEmpty) else { return }
        let database = FirestoreService.shared
        
            database.doesUsernameExist(username) { [weak self] result in
				
				print("The result is \(result)")
                switch result {
                case .success(let exists):
                    DispatchQueue.main.async {
                        
                        self?.isUsernameAvailable = !exists
                    }
                case .failure(let error):
                    // Handle error here
                    print("Could not check if username exists \(error)")
					self?.error = error
                }
            }
        }
        
    func createUser(forUser userID: String, completion: @escaping (Result<Void, Error>) -> Void)  {
        
        // just making sure we have the user data saved otherwise the user needs to be taking back to the sign up onboarding ..
        guard let name = name,
                let knowsBirthTime = knowsBirthTime,
                let tz = homeCityTimeZone,
              let homeCity = homeCity else  {
            
            completion(.failure(OnboardingError.incompleteData))
            return
        }
        
        guard !username.isEmpty &&  gender != .none else {
            completion(.failure(OnboardingError.incompleteData))
            return
        }
        
        let ht = Place(latitude: homeCity.coordinate.latitude, longitude: homeCity.coordinate.longitude, city: homeCity.city, state: homeCity.state, country: homeCity.country, geohash: homeCity.geohash)
        
        let  bd = (knowsBirthTime ?  birthday.combineWithTime(time: birthtime, in: tz) :  birthday.setToNoon(timeZone: tz) )
        
        if bd == nil { completion(.failure(OnboardingError.dateError))}
        
      
        
        let bday = Birthday(timestamp: Timestamp(date: bd!)/*, month: bd!.month(), day: bd!.day(), year: bd!.year()*/)
        
       
        let rs = Place(latitude: homeCity.coordinate.latitude, longitude: homeCity.coordinate.longitude, city: homeCity.city, state: homeCity.state, country: homeCity.country, geohash: homeCity.geohash)
        
        
        
        
        
        
        
        
    // Now create the new user
        
        
        var newUser = AppUser(id: userID, name: name, hometown: ht, birthday: bday, knownBirthTime: knowsBirthTime, residence: rs, profileImageUrl: profileImageUrl, images: [], sex: gender, orientation: [], username: username, phoneNumber: phoneNumber ?? "", reasonsForUse: [])
        
        
        FirestoreService.shared.setOnboardingData(forUser: newUser) { result in
            
            switch result {
            case .success(let success):
                completion(.success(()))
            case .failure(let err):
                self.error = err
                completion(.failure(err))
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
