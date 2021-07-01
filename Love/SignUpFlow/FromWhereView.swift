//
//  FromWhereView.swift
//  Love
//
//  Created by Micheal Bingham on 6/19/21.
//

import SwiftUI
import MapKit

struct FromWhereView: View {
    
    @EnvironmentObject private var account: Account
    
    @State private var searchedLocation: String = ""
    
    /// Returned locations from when the user attempted to search for their location (Using natural language)
    @State private var citiesSearchResult: [MKMapItem] = []
    
    @State private var goToNext: Bool = false 
    
    @State private var someErrorOccured: Bool = false
    
    @State var timezone: TimeZone?
    
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
        
        print("self.timzeone is ... \(self.timezone)")
        
        goToNext = true
         
         account.data?.hometown = Place(latitude: city.placemark.coordinate.latitude, longitude: city.placemark.coordinate.longitude, city: city.placemark.city, state: city.placemark.state, country: city.placemark.country, geohash: city.placemark.geohash)
         
        print("the data is after didselectcity... \(account.data)")
        
         account.save { error in
             
             guard error == nil else {
                 print("The error trying to save the data is ... \(error)")
                 goToNext = false
                 return
             }
             
         }
         
        
    }
    
    
    
    
    // // /// // /// /// / /// /// =================  /// // End of Functionality  // //  /// =============================
    
        //
    
    
    
    
    
}

struct FromWhereView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView{
            FromWhereView().environmentObject(Account())
                .preferredColorScheme(.dark)
        }
        
    }
}
