import SwiftUI
import MapKit
import MbSwiftUIFirstResponder
import NavigationStack


struct SelectLocationForResidenceView: View {
    
   
    /// To manage navigation
    /// id of view
    static let id = String(describing: Self.self)
    
    @EnvironmentObject private var account: Account
    
    // add locations here
    @State var locationsForAnnotation: [CLPlacemark]  = []
    
    
    @State var searchedLocation: String = ""
    

    
    @State private var beginAnimation: Bool = false
    @State var isEditing: Bool = false
    
    
    @State public var selectedCity: CLPlacemark?
    
    @State var timezone: TimeZone?
    
    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String  = ""
    
    var body: some View {
        
        let binding = Binding<String>(get: {
                    self.searchedLocation
            
            
                }, set: {
                    self.searchedLocation = $0
                    // do whatever you want here
                    
                    guard !searchedLocation.isEmpty else {selectedCity = nil ; print("Empty search"); return }
                    
                    searchForCities(searchString: $0) { cities in
                        
                       
                        
                        // Grab the first city of the result
                        if let firstCity = cities.first?.placemark{
                            // We have a city returned
                            
                            selectedCity = firstCity
                            timezone = cities.first?.timeZone
                            
                          //  if let coordinates = firstCity.location?.coordinate{
                                
                                // }
                            
                        } else { selectedCity = nil }
                    }
                })
        
        return
            
            
                
                ZStack{
                
                GlobeView2(locationToGoTo: $selectedCity, locations: $locationsForAnnotation)
                    .ignoresSafeArea()
                    .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
                
                
                    
                    
                    VStack{
                        
                        HStack(alignment: .top){
                            
                            backButton().padding()
                            title().padding()
                            Spacer()
                        }//.offset(y: 45)
                      //  .padding()
                        
                        ZStack{
                            
                            TextField(
                               /*cityString ??*/ "New York, NY",
                                text: binding
                           )
                              
                                .onSubmit {
                                    
                                    print("Did tap submit")
                                  //  self.searchedLocation = $0
                                    // do whatever you want here
                                    
                                    searchForCities(searchString: self.searchedLocation) { cities in
                                        
                                        //citiesSearchResult = cities
                                        //selectedCity = citiesSearchResult.first?.placemark
                                        
                                        // Grab the first city of the result
                                        if let firstCity = cities.first?.placemark{
                                            // We have a city returned
                                            
                                            selectedCity = firstCity
                                            
                                          //  if let coordinates = firstCity.location?.coordinate{
                                                
                                                // }
                                            
                                        } else { selectedCity = nil }
                                    }
                                }
                            
                           .foregroundColor(.white)
                           .frame(width: 300, height: 50)
                           .background(
                                   RoundedRectangle(cornerRadius: 20)
                                       .fill(Color.white.opacity(0.3)
                                   ))
                        
                            
                            
                            HStack{
                                Spacer()
                                nextButton().padding()
                            }
                            
                        }
                        
                      
                       
                        
                        Spacer()
                    }
               
            }
            
            
           
        
        
    }
    
    /// Goes to the next screen / view,. Verification Code Screen
    func goToNextView()  {
        //navigationStack.push(ImageUploadView().environmentObject(account))
        
    }
    
    func nextButton() -> some View {
        
        return  Button {
            // Goes to next screen
          
            
            guard  let city = selectedCity else {
                someErrorOccured = true
                alertMessage = "Please select a city."
                return
            }
            
            
           
            
                
			Account.shared.signUpData.residence = Place(latitude: city.location?.coordinate.latitude, longitude: city.location?.coordinate.longitude, city: city.city, state: city.state, country: city.country, geohash: city.geohash)
            
            
          
            goToNextView()
            
            
        } label: {
            
           
                
            
            Image("RootView/right-arrow")
               .resizable()
               .scaledToFit()
               .frame(width: 33, height: 66)
               .offset(x: beginAnimation ? -15: 0, y: 0)
               .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: beginAnimation)
               .onAppear { withAnimation { beginAnimation = true }; doneWithSignUp(state: false) }
            
          
            
               
        }.opacity(selectedCity == nil ? 0 : 1 )
    }
    
    /// Goes back to the login screen
    func goBack()   {
        
       
            
        //navigationStack.pop(to: .view(withId: SelectLocationView.id))
        
        
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
                .offset(x: beginAnimation ? 7: 0)
                .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: beginAnimation)
                .onAppear { withAnimation { beginAnimation = true } }
                
            
              
        }

       
            
            
            
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
    
    /// Title of the view text .
    func title() -> some View {
        
    
        
        return Text("Where do you live?")
            .foregroundColor(.white)
            .font(.largeTitle)
            .bold()
           // .offset(x: 12)
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



struct GlobeView2: UIViewRepresentable {
    
    /// Pass a state variable here and when it changes, the map will fly to this location
    @Binding var locationToGoTo: CLPlacemark?
    
    /// This will keep track of annotations to place on the map, without animations.
    @Binding var locations: [CLPlacemark]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        // change the map type here
        mapView.mapType = .hybridFlyover
        mapView.tintColor = UIColor(red: 1.00, green: 0.01, blue: 0.40, alpha: 1.00)
        mapView.showsUserLocation = true
    
        return mapView
    }
    
    
    func updateUIView(_ view: MKMapView, context: Context) {
        
        for location in locations {
            
            if let loc = location.location?.coordinate{
                
                // make a pins
                let pin = MKPointAnnotation()
                
                // set the coordinates
                pin.coordinate =  loc
                
                // set the title
                pin.title = location.name
            
                view.showsUserLocation = false
                // add to map
                view.addAnnotation(pin)
            }
       
            
        }
        
        if let goToLoc =  locationToGoTo?.location?.coordinate{
            
            // Animate to the location
            
          //  let loc = CLLocationCoordinate2D(latitude: goToLoc.latitude, longitude: goToLoc.longitude)
            
            
            let  region = MKCoordinateRegion(center: goToLoc, latitudinalMeters: 1609340, longitudinalMeters: 1609300)
            
           // view.animatedZoom(to: region, for: 3)
            
            // make a pins
            let pin = MKPointAnnotation()
            
            // set the coordinates
            pin.coordinate = goToLoc
            
            // set the title
          
           // pin.title = "\(locationToGoTo?.city ?? ""), \(locationToGoTo?.country ?? "")"
            pin.title = locationToGoTo?.name ?? ""
           
            
           // view.annotations
            
            view.removeAnnotations(view.annotations)
            view.showsUserLocation = false
            // add to map
            view.addAnnotation(pin)
            
        }
        
        else {
            
            view.removeAnnotations(view.annotations)
            view.showsUserLocation = true
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 16093400, longitudinalMeters: 16093400)
            
           // view.animatedZoom(to: region, for: 3)
            
           
        }
    }
}

struct SelectLocationForResidenceView_Previews: PreviewProvider {
    static var previews: some View {
        
        SelectLocationForResidenceView()
           

       
    }
}


