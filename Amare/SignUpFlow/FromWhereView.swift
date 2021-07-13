//
//  FromWhereView.swift
//  Love
//
//  Created by Micheal Bingham on 6/19/21.
//

import SwiftUI
import MapKit

@available(iOS 15.0, *)
struct FromWhereView: View {
    
    @EnvironmentObject private var account: Account
    
    @State private var searchedLocation: String = ""
    
    /// Returned locations from when the user attempted to search for their location (Using natural language)
    @State private var citiesSearchResult: [MKMapItem] = []
    
    @State private var goToNext: Bool = false 
    
    
    @State var timezone: TimeZone?
    
    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String  = ""
    
    var body: some View {
        
      
            
            ZStack{
                
                
                setBackground()
                
                
                // ******* ======  Transitions -- Navigation Links =======
                //                                                      //
                //                Goes to the Profile                   //
                //                                                      //
             /* || */           NavigationLink(                       /* || */
                /* || */  destination: EnterBirthdayView(timezone: $timezone).environmentObject(account),
            /* || */                                                /* || */
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
    
    
    /// Sets the background of the view and also the modifiers for the navigation view also does basic configuration like setting the title of the navigation view and showing popup view at error
    func setBackground() -> some View {
        
        // Background Image
        return Image("backgrounds/background1")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            .navigationBarColor(backgroundColor: .clear, titleColor: .white)
            .navigationTitle("Where are you from?")
            .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text("Some Error Occured")) })

    }
    
    func MakeTextFieldForSearchingLocation() -> some View {
        
        
        return   TextField("New York, NY", text: $searchedLocation, onCommit:  {
            
            searchForCitiesAction { cities in
                
                citiesSearchResult = cities
            }
        })

    }
    
    
    
    func MakeButtonForSelectingCity() -> some View {
        
        print("Making button for selecting city ... ")
        
        let cityNameAndState = "\(citiesSearchResult.first?.placemark.city ?? ""), \(citiesSearchResult.first?.placemark.state ?? "")"
        
        let city = citiesSearchResult.first
        
        return Button(cityNameAndState) {
            
          
            guard city != nil else {
                
                return
            }
            
            didSelectCityAction(city: city!)
            
           
            
        }
    }
    
   
    
// // /// // /// /// / /// /// =================  /// // SETTING UP  Up UI // //  /// =============================
    //
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // // /// // /// /// / /// /// =================  /// // Functionality  // //  /// =============================
    
        // Put all code relevant to functionality of the app/UI here. Such as sending verification codes or responding to user taps and thigns  like that.
    
    
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
    
    
    
    func didSelectCityAction(city: MKMapItem)  {
        
        // Pass the time zone to the next view
        self.timezone = city.timeZone
        
        
        goToNext = true
         
         account.data?.hometown = Place(latitude: city.placemark.coordinate.latitude, longitude: city.placemark.coordinate.longitude, city: city.placemark.city, state: city.placemark.state, country: city.placemark.country, geohash: city.placemark.geohash)
         
        
        do{
            
            try account.save()
            
        } catch (let error){
            
            goToNext = false
            handle(error)
            
        }
        
        
         
        
    }
    
    
    
    
    // // /// // /// /// / /// /// =================  /// // End of Functionality  // //  /// =============================
    
        //
    
    
    
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
struct FromWhereView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView{
            FromWhereView().environmentObject(Account())
                .preferredColorScheme(.dark)
        }
        
    }
}
