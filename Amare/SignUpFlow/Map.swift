import SwiftUI
import MapKit
import MbSwiftUIFirstResponder
import NavigationStack


struct ContentView: View {
    
    /// To manage navigation
    @EnvironmentObject private var navigationStack: NavigationStack
    /// id of view
    static let id = String(describing: Self.self)
    
    @EnvironmentObject private var account: Account
    
    // add locations here
    @State var locationsForAnnotation: [CLPlacemark]  = []
    
    
    @State var searchedLocation: String = ""
    
    @State var firstResponder: FirstResponders? = .city
    
    @State private var beginAnimation: Bool = false
    @State var isEditing: Bool = false
    
    
    @State public var selectedCity: CLPlacemark?
    
    var body: some View {
        
        let binding = Binding<String>(get: {
                    self.searchedLocation
                }, set: {
                    self.searchedLocation = $0
                    // do whatever you want here
                    
                    searchForCities(searchString: $0) { cities in
                        
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
                })
        
        return
            
            
                
                ZStack{
                
                GlobeView(locationToGoTo: $selectedCity, locations: $locationsForAnnotation)
                    .ignoresSafeArea()
                
                
                    
                    
                    VStack{
                        
                        HStack(alignment: .top){
                            
                            backButton()
                            title()
                          //  Spacer()
                        }//.offset(y: 45)
                        .padding()
                        
                        TextField(
                           /*cityString ??*/ "New York, NY",
                            text: binding
                       )
                            .firstResponder(id: FirstResponders.city, firstResponder: $firstResponder)
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
                       
                        
                        Spacer()
                    }
               
            }
            
            
           
        
        
    }
    /*
    func searchField() -> some View {
        
     
        
        
         return TextField(
            /*cityString ??*/ "New York, NY",
             text: $searchedLocation
        ) /* { isEditing in
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
                    
                  //  if let coordinates = firstCity.location?.coordinate{
                        
                        // }
                    
                }
            }
            
        } */
         .firstResponder(id: FirstResponders.city, firstResponder: $firstResponder)
        .foregroundColor(.white)
        .frame(width: 300, height: 50)
        .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.3)
                ))
        
            
            

        
        
        
   
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
        
    
        
        return Text("Where were you born?")
            .foregroundColor(.white)
            .font(.largeTitle)
            .bold()
            .offset(x: 12)
    }
}

struct LocationForMapView {
    var title: String
    var latitude: Double
    var longitude: Double
}


struct GlobeView: UIViewRepresentable {
    
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
            
            view.animatedZoom(to: region, for: 3)
            
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
            
            view.animatedZoom(to: region, for: 3)
            
           
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView()
           

       
    }
}


class MyPointAnnotation : MKPointAnnotation {
    var pinTintColor: UIColor?
}
