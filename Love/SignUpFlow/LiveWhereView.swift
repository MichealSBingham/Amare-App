//
//  LiveWhereView.swift
//  Love
//
//  Created by Micheal Bingham on 6/19/21.
//

import SwiftUI
import MapKit

struct LiveWhereView: View {
    
    @EnvironmentObject private var account: Account
    
    @State private var searchedLocation: String = ""
    
    
    /// Returned locations from when the user attempted to search for their location (Using natural language)
    @State private var citiesSearchResult: [MKMapItem] = []
    
    @State private var goToNext: Bool = false
    
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
        /* || */   destination: ProfileView().environmentObject(account),
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
         
         account.save { error in
             
             guard error == nil else {
                 goToNext = false
                 return
             }
             
         }
         
        
    }
    
    // // /// // /// /// / /// /// =================  /// //  // //  /// =============================

        
    
    
    
        
    
    
    
    
}

struct LiveWhereView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            
            LiveWhereView().environmentObject(Account()).preferredColorScheme(.dark)
                

        }
    }
}
