//
//  LiveWhereView.swift
//  Love
//
//  Created by Micheal Bingham on 6/19/21.
//

import SwiftUI
import MapKit
import NavigationStack


struct LiveWhereView: View {
    
    @EnvironmentObject private var navigationStack: NavigationStack

    
    /// id of view
    static let id = String(describing: Self.self)
    
    @ObservedObject var settings = Settings.shared

    
    @EnvironmentObject private var account: Account
    
    @State private var searchedLocation: String = ""
    
    /// Returned locations from when the user attempted to search for their location (Using natural language)
    @State private var citiesSearchResult: [MKMapItem] = []
    
    @State private var goToNext: Bool = false
    
    
    @State var timezone: TimeZone?
    
    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String  = ""
    
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360))
    
    @State private var beginAnimation: Bool = false
    @State private var go: Bool = false

    @State private var isEditing: Bool = true
    /// Used for getting the user's location
    @StateObject var locationManager = LocationWhenInUseManager()
    
    @State var places: [MapAnnotation] = []

    @State public var selectedCity: CLPlacemark? {
         
         didSet{
             
            if let coordinates = selectedCity?.location?.coordinate{
                
                var annotation = MapAnnotation(name: selectedCity?.name ?? "", coordinate: coordinates)
                
                
                if let city = selectedCity?.city, let state = selectedCity?.state  {
                    searchedLocation = "\(city), \(state)"
                }
                
              CLLocation(latitude: selectedCity?.location?.coordinate.latitude ?? 0 , longitude: selectedCity?.location?.coordinate.longitude ?? 0).placemark(completion: { placemark, error in
                    
                    guard error == nil else {
                        print("error getting placemark \(error)")
                        return
                    }
                    self.timezone = placemark?.timeZone
                })
                
                
                withAnimation {
                    
                    region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 16093.4, longitudinalMeters: 16093.4)
                }
                
                self.places = [annotation]
            }
            
        }
    }
    
    enum FirstResponders: Int {
            case city
        }
    @State var firstResponder: FirstResponders? = .city
    
    var body: some View {
        
      
            
        
           
                    
                
               
                    let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()
                    
                    
                
                       
                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: places) {
                    
                    
                    MapMarker(coordinate: $0.coordinate, tint: .pink)
                    
                }.animation(.easeInOut, value: selectedCity)
                    .edgesIgnoringSafeArea(.all)
                    .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text("Some Error Occured")) })
                    .onReceive(timer) { _ in  withAnimation { beginAnimation.toggle() }; /*getCurrentLocationAndAnimateMap();*/ timer.upstream.connect().cancel()}
                    .onAppear { getCurrentLocationAndAnimateMap() }
        
                    
                    VStack(alignment: .center){
                     
                       
                        HStack(alignment: .top){
                            
                            backButton()
                            title()
                            Spacer()
                        }.offset(y: 45)
                        
                        ZStack{
                            searchField().offset(y: 45)
                            
                           
                            
                              
                            HStack{
                                Spacer()
                                nextButton()
                              
                            }
                           
                        }
                        
                        
                    
                        Spacer()
                           
                    }.onAppear(perform: {settings.viewType = .LiveWhereView})
                    
                
                 
                    
                    
                    
                    
                
        
            
          
       
       
    }
    
    
    
    
    
    /// Title of the view text .
    func title() -> some View {
        
    
        
        return Text("Where do you live?")
            .foregroundColor(.white)
            .font(.largeTitle)
            .bold()
            .offset(x: 12)
    }
    
    
    
    
    func searchField() -> some View {
        
     
     
        var cityString: String? = nil
        
        if let city = selectedCity?.city, let state = selectedCity?.state  {
            cityString = "\(city), \(state)"
        }
        /* if iOS 15
        return TextField(cityString ?? "New York, NY", text: $searchedLocation)
            
            .foregroundColor(.clear)
            .frame(width: 300, height: 50)
            .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.3)
                    ))
            .onSubmit {
                
                searchForCities { cities in
                    
                    citiesSearchResult = cities
                    selectedCity = citiesSearchResult.first?.placemark 
                    
               
    
                    
                }
                
            } */
        
        // ios < 15
        return TextField(
            cityString ?? "New York, NY",
             text: $searchedLocation
        ) { isEditing in
            self.isEditing = isEditing
        } onCommit: {
            firstResponder = nil
            searchForCities { cities in
                
                citiesSearchResult = cities
                selectedCity = citiesSearchResult.first?.placemark
            }
        }
        .firstResponder(id: FirstResponders.city, firstResponder: $firstResponder)
        .foregroundColor(.white)
        .frame(width: 300, height: 50)
        .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.3)
                ))
        
            
            

        
        
        
   
    }
    
    
    
    /// *** *
    /// -TODO: NEED TO FIX THIS!!!!
    func viewWillAppear()  {
        getCurrentLocationAndAnimateMap()
    }
  
   

    func getCurrentLocationAndAnimateMap()  {
        
        print("Getting current lcoation and animating map...")
        
        // Gets the current location
        locationManager.lastLocation?.placemark(completion: { placemark, error in
            
            guard error == nil else { return }
            
            selectedCity = placemark
            
    })
        
    }
    
    
    /// Call this to get a list of cities that are nearby that the user searched for in the searchedLocation binding string
    func searchForCities(_ completion: @escaping ([MKMapItem]) -> () )  {
        
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
    
  

    /// Goes back to the login screen
    func goBack()   {
        
        navigationStack.pop(to: .view(withId: FromWhereView.id))
        
    }
    
    /// Left Back Button
    func backButton() -> some View {
        
       return Button {
            
            goBack()
            
        } label: {
            
             Image("RootView/right-arrow")
                .resizable()
                .scaledToFit()
                .rotationEffect(.degrees(180))
                .frame(width: 33, height: 66)
                .offset(x: beginAnimation ? 7: 0, y: -10)
                .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: beginAnimation)
                .onAppear { withAnimation { beginAnimation = true } }
                
            
              
        }

       
            
            
            
    }
    
    /// Comes back to this view since an error occured.
    func comeBackToView()  {
        
        //navigation.hideViewWithReverseAnimation(LiveWhereView.id)
        
    }
    
    /// Goes to the next screen / view,. Verification Code Screen
    func goToNextView()  {
        navigationStack.push(ImageUploadView().environmentObject(account))
       
        
    }
    
    func nextButton() -> some View {
        
        return  Button {
            // Goes to next screen
          
            guard  let city = selectedCity else {
                return
            }
            
          
            
            
            
            
            account.data?.residence = Place(latitude: city.location?.coordinate.latitude, longitude: city.location?.coordinate.longitude, city: city.city, state: city.state, country: city.country, geohash: city.geohash)
            
            do {
                
                try account.save(completion: { error in
                    guard error == nil else {return }
                    goToNextView()
                })
                
                
            } catch (let error) {
              
                handle(error)
            }
            
            
        } label: {
            
           
                
            
            Image("RootView/right-arrow")
               .resizable()
               .scaledToFit()
               .frame(width: 33, height: 66)
               .offset(x: beginAnimation ? -15: 0, y: 0)
               .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: beginAnimation)
               .onAppear { withAnimation { beginAnimation = true } }
            
          
            
               
        }
    }
    
    
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
        someErrorOccured = true
    }
    
}


struct LiveWhereView_Previews: PreviewProvider {
    static var previews: some View {
        
            LiveWhereView().environmentObject(Account())
                .preferredColorScheme(.dark)
                //.environmentObject(NavigationModel())
        
        
    }
}



