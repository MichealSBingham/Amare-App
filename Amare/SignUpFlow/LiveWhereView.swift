//
//  LiveWhereView.swift
//  Love
//
//  Created by Micheal Bingham on 6/19/21.
//

import SwiftUI
import MapKit

@available(iOS 15.0, *)
struct LiveWhereView: View {
    
    @EnvironmentObject private var account: Account
    
    @State private var searchedLocation: String = ""
    
    
    /// Returned locations from when the user attempted to search for their location (Using natural language)
    @State private var citiesSearchResult: [MKMapItem] = []
    
    @State private var goToNext: Bool = false
    

    
    @State private var alertMessage: String  = ""
    @State private var someErrorOccured: Bool = false


var body: some View {
    

        
        ZStack{
            
            // Background Image
            SetBackground()
            
            
            // ******* ======  Transitions -- Navigation Links =======
            //                                                      //
            //                Goes to the Profile                   //
            //                                                      //
         /* || */           NavigationLink(                       /* || */
        /* || */   destination: ImageUploadView().environmentObject(account),
        /* || */           isActive: $goToNext,                  /* || */
        /* || */           label: {  EmptyView()  })             /* || */
        /* || */                                                 /* || */
        /* || */                                                 /* || */
            // ******* ================================ **********
            
            
            
            VStack{
                
              
                MakeButtonForSelectingCity()
                MakeTextFieldForSearchingLocation()
                
                
            }
            
            
            
            
        }
        .onAppear {
            doneWithSignUp(state: false)
        }
        
    
   
}
    
    
    
    
    // ===********************************************************** // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\//\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\/
    
    
    // ===********************************************************** // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\//\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\/
    
    
    // ===********************************************************** // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\//\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\/
    
    
    // ===********************************************************** // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\//\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\/
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
// // /// // /// /// / /// /// =================  /// // SETTING UP  Up UI // //  /// =============================
    // PUT ALL FUNCTIONS RELATED TO BUILDING THE UI HERE.
    
    
    
    
    

    
    
    func SetBackground() -> some View {
        
        return Image("backgrounds/background1")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("Where do you live?")
            .navigationBarColor(backgroundColor: .clear, titleColor: .white)
            .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
    }
    
    
    func MakeTextFieldForSearchingLocation() -> some View {
        
        return   TextField("New York, NY", text: $searchedLocation, onCommit:  {
            
            searchForCitiesAction { cities in
                
                citiesSearchResult = cities
            }
        })

    }
    
    
    
    func MakeButtonForSelectingCity() -> some View {
        
        let cityNameAndState = "\(citiesSearchResult.first?.placemark.city ?? ""), \(citiesSearchResult.first?.placemark.state ?? "")"
        
        let city = citiesSearchResult.first
        
        return Button(cityNameAndState) {
            
            guard city != nil else {
                
                return
            }
            didSelectCityAction(city: city)
            
           
            
        }
    }
    
    
    
    // // /// // /// /// / /// /// =================  /// // SETTING UP  Up UI // //  /// =============================

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // // /// // /// /// / /// /// =================  /// // SETTING UP  Functionality  // //  /// =============================
        // PUT ALL FUNCTIONS RELATED TO Actions and functionality of THE UI HERE.
        
    
    /// Call this to get a list of cities that are nearby that the user searched for in the searchedLocation binding string
    func searchForCitiesAction(_ completion: @escaping ([MKMapItem]) -> () )  {
        
        // ******************** // Search for city /// ******************** // ********//

        // Search for city
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchedLocation
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            
            guard let response = response else {
                
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                        return
            }

            let cities = response.mapItems
            completion(cities)
            return
        }
        

    }
    
    
    
    func didSelectCityAction(city: MKMapItem?)  {
        
        goToNext = true
         
         account.data?.residence = Place(latitude: city?.placemark.coordinate.latitude, longitude: city?.placemark.coordinate.longitude, city: city?.placemark.city, state: city?.placemark.state, country: city?.placemark.country, geohash: city?.placemark.geohash)
        
        do {
            
            try account.save()
            
        } catch (let error){
            goToNext = false
            handle(error)
        }
         
       
        
    }
    
    // // /// // /// /// / /// /// =================  /// //  // //  /// =============================

        
    
    
    
        
    func handle(_ error: Error)  {
        
        // Handle Error
        if let error = error as? AccountError{
            
            switch error {
            case .doesNotExist:
                alertMessage = "You do not exist."
            case .disabledUser:
                alertMessage = "Sorry, your account is disabled."
            case .expiredVerificationCode:
                alertMessage = "Your verification code has expired."
            case .wrong:
                alertMessage = "You entered the wrong code"
            case .notSignedIn:
                alertMessage = "You are not signed in."
            case .uploadError:
                alertMessage = "There was some upload Error"
            case .notAuthorized:
                alertMessage = "You are not authorized to do this."
            case .expiredActionCode:
                alertMessage = "The action code has expired"
            case .sessionExpired:
                alertMessage = "The session has expired"
            case .userTokenExpired:
                alertMessage = "The user token has expired"
            }
        }
        
        if let error = error as? GlobalError{
            
            switch error {
            case .networkError:
                alertMessage = "There is a network error. Lost internet connection"
            case .tooManyRequests:
                alertMessage = "You're trying too many times to ping our servers. Wait a bit."
            case .captchaCheckFailed:
                alertMessage = "You might be a robot because you failed the captcha check and that's quite rare. Goodbye."
            case .invalidInput:
                alertMessage = "You entered something wrong with the wrong format."
            case .quotaExceeded:
                alertMessage = "This isn't your fault. We need to scale to be able to withstand the current quota. Just try again in a bit."
            case .notAllowed:
                alertMessage = "You are not allowed to do that."
            case .internalError:
                alertMessage = "There was some internal error with us. Not your fault."
            case .cantGetVerificationID:
                alertMessage = "This isn't an end-user error and you honestly should not be seeing this. If you did, something is broken. Report it to us because your verification ID is not being saved."
            case .unknown:
                alertMessage = "I'm not sure what this error is, lol."
            }
        }
        
        
        // Handle Error
        
    }
    
    
    
}

@available(iOS 15.0, *)
struct LiveWhereView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            
            LiveWhereView().environmentObject(Account()).preferredColorScheme(.dark)
                

        }
    }
}
