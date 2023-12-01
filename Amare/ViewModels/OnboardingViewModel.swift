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
	
    @Published var gender: Sex = .none {
        didSet{
                self.generateTraits { result in
                    
                }
        }
    }
    
    @Published var residence: MKPlacemark?
    
    @Published var profileImageUrl: String = ""
    @Published var images: [String] = []
    @Published var extraImages: [String] = []
	
	@Published var friendshipSelected: Bool = false
	@Published var datingSelected: Bool = false
	@Published var selfDiscoverySelected: Bool = false 
    
   
    
    var reasonsForUse: [AppUser.ReasonsForUse] = []
    
    @Published var womenSelected: Bool = false
    @Published var menSelected: Bool = false
    @Published var TmenSelected: Bool = false
    @Published var TwomenSelected: Bool = false
    @Published var nonBinarySelected: Bool = false
    
    var orientation: [Sex] = []
    
    
	
    
    @Published  var progress: Double = Double(OnboardingScreen.allCases.firstIndex(of: .phoneNumber) ?? 0) / Double(OnboardingScreen.allCases.count - 1)
	
	@Published var error: Error?
    
    
    //MARK: - Properties for Trait Prediction
    
    
    @Published var predictedTraits: [PredictedTrait]  =   [] // PredictedTrait.uniqueTraits // []
    
    // Tracking user feedback
    @Published var traitFeedback: [String: Bool] = [:] // Trait name as key, and feedback as Bool
    
    var correctTraitGuesses: Int {
        traitFeedback.filter { (trait, userFeedback) -> Bool in
            guard let traitDetails = predictedTraits.first(where: {$0.name == trait}) else { return false }
            switch traitDetails.category {
                case .likely, .unlikely:
                    return userFeedback // true if user agrees with AI's 'likely' or 'unlikely'
                case .neutral:
                    return !userFeedback // true if user disagrees with AI's 'neutral' (since neutral is unsure)
            }
        }.count
    }
    
    var correctnessPercentage: Double {
        let total = traitFeedback.count
        return total > 0 ? (Double(correctTraitGuesses) / Double(total))  : 0
    }
    
   //MARK: - Properties for Personality Prediction
    
    @Published var predictedPersonalityStatements: [PersonalityStatement]  =  PersonalityStatement.random(n: 10)// []
    
    // Tracking user feedback
    @Published var personalityStatementsFeedback: [String: Bool] = [:]
    
    var correctPersonalityGuesses: Int {
        personalityStatementsFeedback.filter { (statement, userFeedback) -> Bool in
            guard let traitDetails = predictedPersonalityStatements.first(where: {$0.description == statement}) else { return false }
            return userFeedback
        }.count
    }
    
    var correctnessPercentageForPersonality: Double {
        let total = personalityStatementsFeedback.count
        return total > 0 ? (Double(correctPersonalityGuesses) / Double(total))  : 0
    }
    
    func resetData() {
            currentPage = .phoneNumber
            phoneNumber = nil
            name = nil
            username = ""
            isUsernameAvailable = nil
            birthday = Date()
            birthtime = Date()
            knowsBirthTime = nil
            homeCityTimeZone = nil
            homeCity = nil
            gender = .none
            residence = nil
            profileImageUrl = ""
            images.removeAll()
            friendshipSelected = false
            datingSelected = false
            selfDiscoverySelected = false
            reasonsForUse = []
            womenSelected = false
            menSelected = false
            TmenSelected = false
            TwomenSelected = false
            nonBinarySelected = false
            orientation = []
            progress = Double(OnboardingScreen.allCases.firstIndex(of: .phoneNumber) ?? 0) / Double(OnboardingScreen.allCases.count - 1)
            error = nil
            predictedTraits = []
            traitFeedback = [:]
            predictedPersonalityStatements = []
            personalityStatementsFeedback = [:]
        
        }
    //MARK: - Functions
    
	
    //TODO: Handle error handling for `checkUsername` 
    func checkUsername() {
        
    
        guard  !(username.isEmpty) else { return }
        let database = FirestoreService.shared
        
            database.doesUsernameExist(username) { [weak self] result in
				
                switch result {
                case .success(let exists):
                    DispatchQueue.main.async {
                        
                        self?.isUsernameAvailable = !exists
                    }
                case .failure(let error):
                    // Handle error here
					self?.error = error
                }
            }
        }
        
	/// set `isCustom` to true if it's a custom profile
	func createUser(forUser userID: String, completion: @escaping (Result<Void, Error>) -> Void)  {
        
        // just making sure we have the user data saved otherwise the user needs to be taking back to the sign up onboarding ..
        guard let name = name,
                let knowsBirthTime = knowsBirthTime,
                let tz = homeCityTimeZone,
              let homeCity = homeCity
             
                else  {
            
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
        
        // MARK: - adding reasons for use and the user's sexual orientation
        
        reasonsForUse.removeAll()

                // Check each selection and append to the array if true
                if friendshipSelected {
                    reasonsForUse.append(.friendship)
                }
                if datingSelected {
                    reasonsForUse.append(.dating)
                }
                if selfDiscoverySelected {
                    reasonsForUse.append(.selfDiscovery)
                }
        
        orientation.removeAll()

                // Check each selection and append to the array if true
                if womenSelected {
                    orientation.append(.female)
                }
                if menSelected {
                    orientation.append(.male)
                }
                if TmenSelected {
                    orientation.append(.transmale)
                }
                if TwomenSelected {
                    orientation.append(.transfemale)
                }
                if nonBinarySelected {
                    orientation.append(.non_binary)
                }
        
        
        
        var images = images
        images.append(contentsOf: extraImages)
        
        let myProfileImage = profileImageUrl
        
        let posTraits = getPositiveFeedbackTraits(predictedTraits: predictedTraits, traitFeedback: traitFeedback)
        print("posTraits: \(posTraits)")
        let traits = posTraits.likelyTraitNames()
        print("traits: \(traits)")
        
        
    // MARK: - Now create the new user
        
        
        var newUser = AppUser(id: userID, name: name, hometown: ht, birthday: bday, knownBirthTime: knowsBirthTime, residence: rs, profileImageUrl: myProfileImage, images: images, sex: gender, orientation: orientation, username: username, phoneNumber: phoneNumber ?? "", reasonsForUse: reasonsForUse, traits: traits)
        
        AuthService.shared.fetchStreamTokenFromFirebase(andUpdate: name, profileImageURL: myProfileImage, username: username)
        
        FirestoreService.shared.setOnboardingData(forUser: newUser) { result in
            
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let err):
                self.error = err
                completion(.failure(err))
            }
        }
        
                
                
    }
	
	
	func createCustomProfile(forUser userID: String? = Auth.auth().currentUser?.uid, completion: @escaping (Result<Void, Error>) -> Void)  {
		
		// just making sure we have the user data saved otherwise the user needs to be taking back to the sign up onboarding ..
		guard let name = name,
				let knowsBirthTime = knowsBirthTime,
				let tz = homeCityTimeZone,
			  let homeCity = homeCity, let id = userID else  {
			
			completion(.failure(OnboardingError.incompleteData))
			return
		}
		
		
		
		let ht = Place(latitude: homeCity.coordinate.latitude, longitude: homeCity.coordinate.longitude, city: homeCity.city, state: homeCity.state, country: homeCity.country, geohash: homeCity.geohash)
		
		let  bd = (knowsBirthTime ?  birthday.combineWithTime(time: birthtime, in: tz) :  birthday.setToNoon(timeZone: tz) )
		
		if bd == nil { completion(.failure(OnboardingError.dateError))}
		
	  
		
		let bday = Birthday(timestamp: Timestamp(date: bd!)/*, month: bd!.month(), day: bd!.day(), year: bd!.year()*/)
		
	   
		let rs = Place(latitude: homeCity.coordinate.latitude, longitude: homeCity.coordinate.longitude, city: homeCity.city, state: homeCity.state, country: homeCity.country, geohash: homeCity.geohash)
		
		
		
		
        
		
		
		
		
	// Now create the new user
		
		
		var customUser = AppUser( name: name, hometown: ht, birthday: bday, knownBirthTime: knowsBirthTime, residence: rs, profileImageUrl: profileImageUrl, images: [], sex: .none, orientation: [], username: "none", phoneNumber: "", reasonsForUse: [])
		
		
		FirestoreService.shared.createCustomUser(forUser: id, with: customUser) { result in
			
			switch result {
            case .success(_):
				completion(.success(()))
			case .failure(let err):
				self.error = err
				completion(.failure(err))
			}
		}
		
				
				
	}
	
/// Generates traits that might describe the user based on their astrological profile+basic info using large language model
	func generateTraits(completion: @escaping (Result<Any, Error>) -> Void){
		// just making sure we have the user data saved otherwise the user needs to be taking back to the sign up onboarding ..
		print("Generating Traits")
		guard let name = name,
				let knowsBirthTime = knowsBirthTime,
				let tz = homeCityTimeZone,
			  let homeCity = homeCity else  {
			completion(.failure(OnboardingError.incompleteData))
			return
		}
		
		
		guard  gender != .none else {
			completion(.failure(OnboardingError.incompleteData))
			return
		}
		
		let ht = Place(latitude: homeCity.coordinate.latitude, longitude: homeCity.coordinate.longitude, city: homeCity.city, state: homeCity.state, country: homeCity.country, geohash: homeCity.geohash)
		
		let  bd = (knowsBirthTime ?  birthday.combineWithTime(time: birthtime, in: tz) :  birthday.setToNoon(timeZone: tz) )
		
		if bd == nil { completion(.failure(OnboardingError.dateError))}
		
		
		
		// Now send the gender, name, birthday utc timestamp seconds, and lat/long to api.
		print("\n\n\n================Sending the data to api to generate traits: ")
		print(name)
		print(gender.rawValue)
		print("time interval: \(bd!.timeIntervalSince1970)")
		print("timestamp: \(Timestamp(date: bd!).seconds)")
		print("lat: \(homeCity.coordinate.latitude)")
		print("long: \(homeCity.coordinate.longitude)")
		
		let data = UserTraitsData(name: name, gender: gender.rawValue, latitude:homeCity.coordinate.latitude, longitude: homeCity.coordinate.longitude, birthdayInSecondsSince1970: bd!.timeIntervalSince1970, knowsBirthtime: knowsBirthTime)
        
        DispatchQueue.global(qos: .userInitiated).async{
            APIService.shared.predictTraitsFrom(data: data) { result in
                switch result {
                case .success(let traits):
                    
                    DispatchQueue.main.async {
                        // TODO: check if this is proper because publishing changing from background threads is not allowed.
                        let traitsDictionary = traits as? [String : String] ?? [:]
                        
                        // Convert to an array of 'Trait'
                        let traits = traitsDictionary.map { (key, value) -> PredictedTrait in
                            // Here, 'key' is the trait name, and 'value' is the category as a string
                            if let category = TraitCategory(rawValue: value) {
                                return PredictedTrait(name: key, category: category)
                            } else {
                                // Handle the case where the category does not match any case of the enum
                                // This should not happen if your API guarantees only those three values
                                // Here, we default to 'neutral' for safety, or you could throw an error
                                return PredictedTrait(name: key, category: .neutral)
                            }
                        }
                        
                        self.predictedTraits = traits
                        print("traits are ... \(self.predictedTraits)")
                        
                        completion(.success(traits))
                    }
                    
                case .failure(let failure):
                    print("FAILED predicting traits \(failure)")
                    completion(.failure(failure))
                }
            }
            
        }
		
	}
      
    func generatePersonality(){
        self.predictedPersonalityStatements = PersonalityStatement.random(n: 10)
    }
    
    private func getPositiveFeedbackTraits(predictedTraits: [PredictedTrait], traitFeedback: [String: Bool]) -> [PredictedTrait] {
        return predictedTraits.filter { predictedTrait in
            traitFeedback[predictedTrait.name] == true
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
