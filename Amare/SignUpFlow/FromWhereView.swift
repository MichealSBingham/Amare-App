//
//  FromWhereView.swift
//  Love
//
//  Created by Micheal Bingham on 6/19/21.
//

import SwiftUI
import MapKit
import NavigationStack
import MbSwiftUIFirstResponder

struct FromWhereView: View {
    
    @EnvironmentObject private var navigationStack: NavigationStack

    @ObservedObject var settings = Settings.shared

    
    /// id of view
    static let id = String(describing: Self.self)
    
    @EnvironmentObject private var account: Account
    
    @State private var searchedLocation: String = ""
    
    /// Returned locations from when the user attempted to search for their location (Using natural language)
  //  @State private var citiesSearchResult: [MKMapItem] = []
    
    @State private var goToNext: Bool = false 
    
    
    @State var timezone: TimeZone?
    
    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String  = ""
    
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360))
    
    @State private var beginAnimation: Bool = false
    @State private var go: Bool = false


    /// Used for getting the user's location
   // @StateObject var locationManager = LocationWhenInUseManager()
    
    @State var places: [MapAnnotation] = []
    
    @State var isEditing: Bool = false
    
    @State var cityString: String? = nil

    
    @State var firstResponder: FirstResponders? = .city

   /* @State public var selectedCity: CLPlacemark? {
         
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
                  
                  print("Time zone is ... \(placemark?.timeZone)")
                    self.timezone = placemark?.timeZone
                })
                
                
                withAnimation(.easeIn(duration: 10)) {
                    
                    region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 16093.4, longitudinalMeters: 16093.4)
                }
                
                self.places = [annotation]
            }
            
        }
    }
    */
    
    @State public var selectedCity: CLPlacemark?
    
    var body: some View {
        
      
            
       
        ZStack {
            
            
        
                
                       createMap()
               
        
                    
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
                           
                    }.onAppear(perform: {settings.viewType = .FromWhereView })
                    
                
                 
                    
                    
                    
    }
                
                
        
            
          
       
       
    }
    
    
    
    
    func createMap() -> some View {
        
      
        
        return Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: places) {
            
            MapMarker(coordinate: $0.coordinate, tint: .pink)
            
        }//.animation(.easeOut, value: selectedCity)
            .edgesIgnoringSafeArea(.all)
            .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text("Some Error Occured")) })
        .onAppear(perform: {
            beginAnimation.toggle()
        })
           
        //.onAppear { getCurrentLocationAndAnimateMap() }
    }
    
    /// Title of the view text .
    func title() -> some View {
        
    
        
        return Text("Where were you born?")
            .foregroundColor(.white)
            .font(.largeTitle)
            .bold()
            .offset(x: 12)
    }
    
    
    
    
    func searchField() -> some View {
        
     
     
         /*
        if let city = selectedCity?.city, let state = selectedCity?.state  {
            cityString = "\(city), \(state)"
        }
       */
         return TextField(
            /*cityString ??*/ "New York, NY",
             text: $searchedLocation
        ) { isEditing in
            self.isEditing = isEditing
        } onCommit: {
            firstResponder = nil
            searchForCities(searchString: searchedLocation) { cities in
                
                //citiesSearchResult = cities
                //selectedCity = citiesSearchResult.first?.placemark
                
                // Grab the first city of the result
                if let firstCity = cities.first?.placemark{
                    // We have a city returned
                    selectedCity = firstCity
                    
                    if let coordinates = firstCity.location?.coordinate{
                        
                    }
                    
                }
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
        /*
       var status =  locationManager.$locationStatus
        
        /*
        guard status == .authorizedAlways || status == .authorizedWhenInUse else {
            
            // user did not give location permission
            
            print("location denied the status is \(status)")
            locationManager.request()
            
            return
            
        } */
        
        print("location status is .. \(status)")
       
        
        // Gets the current location
        locationManager.lastLocation?.placemark(completion: { placemark, error in
            
            guard error == nil else { return }
            
            selectedCity = placemark
            
            if let city = selectedCity?.city, let state = selectedCity?.state  {
                cityString = "\(city), \(state)"
            }
            locationManager.stop()
            
            
    })
        */
    }
    
    
    /// Call this to get a list of cities that are nearby that the user searched for in the searchedLocation binding string
    func searchForCities(searchString: String, _ completion: @escaping ([MKMapItem]) -> () )  {
        
        // ******************** // Search for city /// ******************** // ********//
        
        guard !searchString.isEmpty else { completion([]); return }

        // Search for city
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchString
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
    
    
    /*
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
    */

    /// Goes back to the login screen
    func goBack()   {
        
        navigationStack.pop()
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
        
        //navigation.hideViewWithReverseAnimation(FromWhereView.id)
        
    }
    
    /// Goes to the next screen / view,. Verification Code Screen
    func goToNextView()  {
        
        guard let timezone = timezone else {
            someErrorOccured = true
            alertMessage = "Please select a city" 
            return
        }
 
        navigationStack.push(EnterBirthdayView(timezone: timezone).environmentObject(account))
       
        
    }
    
    func nextButton() -> some View {
        
        return  Button {
            // Goes to next screen
          
            
            guard  let city = selectedCity else {
                return
            }
            
           
            
            
            
            account.data?.hometown = Place(latitude: city.location?.coordinate.latitude, longitude: city.location?.coordinate.longitude, city: city.city, state: city.state, country: city.country, geohash: city.geohash)
            
            do {
                
                try account.save(completion: { error in
                    guard error == nil else {
                        return
                    }
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
            
          
            
               
        }//.opacity( (likesMen == false  && likesWomen == false ) ? 0.5 : 1.0 )
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
        someErrorOccured=true
        
    }
    
}


struct FromWhereView_Previews: PreviewProvider {
    static var previews: some View {
        
            FromWhereView().environmentObject(Account())
                .preferredColorScheme(.dark)
                //.environmentObject(NavigationModel())
        
        
    }
}



struct MapViewUIKit: UIViewRepresentable {
    // 1.
    let region: MKCoordinateRegion
    let mapType : MKMapType
    
    // 2.
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.setRegion(region, animated: false)
        mapView.mapType = mapType
        return mapView
    }
    
    // 3.
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.mapType = mapType
    }
}
extension MKMapView
{
    public func animatedZoom(to zoomRegion:MKCoordinateRegion,for duration:TimeInterval) -> Void
    {
        MKMapView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIView.AnimationOptions.curveEaseIn, animations:
            { self.setRegion(zoomRegion, animated: true) }, completion: nil)
    }
}

extension CLLocationCoordinate2D: Identifiable {
    public var id: String {
        "\(latitude)-\(longitude)"
    }
}

struct MapAnnotation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

enum FirstResponders: Int {
        case city
    }
