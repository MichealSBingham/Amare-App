//
//  MapView.swift
//  Amare
//
//  Created by Micheal Bingham on 8/12/21.
//

import SwiftUI
import MapKit
import CoreLocation
import UICircularProgressRing
import Combine
import URLImage
import URLImageStore
import Firebase
import PushNotifications
// Sample Data

var sampleNames: [String] = ["Micheal S. Bingham", "John", "Jane", "William Scott"]
var sampleClassifications: [String] = ["Better Off Friends", "Soulmate", "Partner", "Fling", "Enemy", "Stay Away"]
var sampleLatinPhrases: [String] = ["Amor Vincit Omnia", "Enjoy while it lasts, but days of length you shall not have", "Love conquers all.", "This is your soulmate.", "Don't fall in love.", "Beautiful Relationship."]

/// Will soon be nearby people but for now just shows all people
class NearbyPeople: ObservableObject{
    @Published var users: [AmareUser]

    init(){
        self.users = []
    }

}

/// Will soon be nearby people but for now just shows all people
class PeopleForGlobe: ObservableObject{
    @Published var users: [AmareUser]

    init(){
        self.users = []
    }

}

struct MapView: View {
    @EnvironmentObject private var account: Account
    let beamsClient = PushNotifications.shared
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360))
    
    @State private var someErrorOccured: Bool = false
    
    @StateObject var locationManager = LocationManager()
    
    @State var discoverModeEnabled: Bool = false
    
    @State var showProfilePopup: Bool = false

    @State var progress = RingProgress.percent(0.235)
    
    
    // Properties for the profile pop up
    @State var synastryscore = RingProgress.percent(0)
    @State var chemistry = RingProgress.percent(0)
    @State var love = RingProgress.percent(0)
    @State var sex = RingProgress.percent(0)
    

    
    @State var places: [MapAnnotation] = []
    
  
    // We only declare it as a same type as NearbyPeople purely because I'm lazy and i've already coded the UI for this.
    @StateObject var customProfiles: NearbyPeople = NearbyPeople()
    
    
    @StateObject var nearbyUsers: NearbyPeople = NearbyPeople()
    @StateObject var usersForGlobe: PeopleForGlobe = PeopleForGlobe()
    @State var selected_user: AmareUser?
   // @State var selected_chart: NatalChart?
    
    // For showing more info popup
    @State var selectedPlanet: Planet?
    
    
    @State var counter = 0
    
    @State var searchedUser: String = ""
    
    @State var returnedSearchedUserData: [QueryDocumentSnapshot] = []
    
    var searchreal: Bool = true
    var body: some View {
        
        let binding = Binding<String>(get: {
                    self.searchedUser
            
            
                }, set: {
                    self.searchedUser = $0
                    // do whatever you want here
                    
                     /*
                    
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
               */ }  )
        ZStack{
            
            createMap()
                .onTapGesture {
                    withAnimation {
                        
                        guard selectedPlanet == nil else {
                            withAnimation{
                                selectedPlanet = nil
                            }
                           
                            return
                        }
                         
                        showProfilePopup = false
                     
                        
                        AmareApp().delay(0.25) {
                            selected_user = nil
                        }
                         
                        
                    }
                    
                }
            
            VStack{
                
                HStack{
                    
                    Image(systemName: "magnifyingglass")
                    
                    
                    
                    TextField(
                       /*cityString ??*/ "Micheal Bingham",
                        text: binding
                    )
                        .onSubmit {
                        
                        }
                        .onReceive(Just(searchedUser), perform: { output in
                            
                            guard !searchedUser.isEmpty else {return }
                            
                            account.db?.collection(!searchreal ? "generated_users": "users")
                                .whereField("name", isGreaterThanOrEqualTo: searchedUser)
                                .getDocuments(completion: { snapshot, error in
                                    
                                    guard error == nil else {return}
                                    
                                    returnedSearchedUserData = snapshot!.documents
                                    
                                    for document in snapshot!.documents{
                                        
                                        var data = document.data()
                                        print("After searching \(searchedUser) the data is \(data["name"])")
                                    }
                                })
                        })
            
                    
                   .foregroundColor(.white)
                   .frame(width: 300, height: 50)
                   .background(
                           RoundedRectangle(cornerRadius: 20)
                               .fill(Color.white.opacity(0.3)
                           ))
                    
                    
                }
                   
                
                Spacer()
                
            }
            
            // VERTICAL NEARBY USERS
            HStack{
                
                // VERTICAL NEARBY USERS
                ScrollView(.vertical, showsIndicators: true) {
                    
                    VStack{
                        
                        
                        
                        ForEach(customProfiles.users, id: \.interal_ui_use_only_for_iding) { user in
                         
                           
        
                                //TODO: make this a state variable so it can listen to real time changes
                            Button {
                             
                                withAnimation(.easeInOut) {
                                    showProfilePopup = true
                                    selected_user = user
                                
                                    account.getNatalChart(from: selected_user?.id ?? "error", pathTousers: "users") { err, natalChart in
                                        
                                        
                            
                                        if let natalChart = natalChart{
                                            selected_user?.natal_chart = natalChart
                                        }
                                    }
                                }
                            } label: {
                                
                                nearbyUser(user: selected_user ?? user)
                                
                               
                                
                                    
                            }.onAppear(perform: {
                            //TODO: this is called way before the image is tapped, that's why the synastry score won't reload
                               
                            })

                       
                                
                                
                            
                        }
                   }
                       
                
                   
                    
                    
                    
                }
                .offset(y: 50)
                
                Spacer()
                // VERTICAL NEARBY USERS
                ScrollView(.vertical, showsIndicators: true) {
                    
                    VStack{
                        
                        
                        
                        ForEach(nearbyUsers.users, id: \.interal_ui_use_only_for_iding) { user in
                         
                           
        
                                //TODO: make this a state variable so it can listen to real time changes
                            Button {
                             
                                withAnimation(.easeInOut) {
                                    showProfilePopup = true
                                    selected_user = user
                                
                                    account.getNatalChart(from: selected_user?.id ?? "error", pathTousers: "users") { err, natalChart in
                                        
                                        
                            
                                        if let natalChart = natalChart{
                                            selected_user?.natal_chart = natalChart
                                        }
                                    }
                                }
                            } label: {
                                
                                nearbyUser(user: selected_user ?? user)
                                
                               
                                
                                    
                            }.onAppear(perform: {
                            //TODO: this is called way before the image is tapped, that's why the synastry score won't reload
                               
                            })

                       
                                
                                
                            
                        }
                   }
                       
                
                   
                    
                    
                    
                }
                .offset(y: 50)
               
      
                
            }
           
            /*
             HORIZONTAL NEARBY USERS
            VStack{
                
            
                Spacer()
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        
                        HStack{
                            
                            
                            
                            ForEach(nearbyUsers.users, id: \.interal_ui_use_only_for_iding) { user in
                             
                               
            
                                    //TODO: make this a state variable so it can listen to real time changes
                                Button {
                                 
                                    withAnimation(.easeInOut) {
                                        showProfilePopup = true
                                        selected_user = user
                                    
                                        account.getNatalChart(from: selected_user?.id ?? "1b162d90b9821b24ca3fe6409c6f54b729b1db4f935b097ac6efe1346b76d12a", pathTousers: "generated_users") { err, natalChart in
                                            
                                            
                                            
                                            if let natalChart = natalChart{
                                                selected_user?.natal_chart = natalChart
                                            }
                                        }
                                    }
                                } label: {
                                    
                                    nearbyUser(user: selected_user ?? user)
                                    
                                    /*
                                    var name: String = user.name ?? "noname"
                                    Text(name)
                                        */
                                    
                                        
                                }.onAppear(perform: {
                                //TODO: this is called way before the image is tapped, that's why the synastry score won't reload
                                   
                                })

                           
                                    
                                 /*   Button {
                                        
                                        print("** Did tap \(user)")
                                        withAnimation(.easeInOut) {
                                            showProfilePopup = true
                                            selected_user = user
                                        }
                                        
                                    } label: {
                                        
                                        
                                        ImageFromUrl(user.profile_image_url ?? testImages[0])
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(colors.randomElement() ?? .blue, lineWidth: 1))
                                            .shadow(radius: 15)
                                            .aspectRatio(contentMode: .fit)
                                            .padding()
                                        
                                    }
                                    */
                                    
                                
                            }
                       }
                           
                    
                       
                        
                        
                        
                    }
          
               
                
        
                
                Toggle("", isOn: $discoverModeEnabled )
                    .padding()
            }
            */
            
            
            ProfilePopup(user: selected_user, account: account)
                .preferredColorScheme(.dark)
                .opacity(showProfilePopup && selected_user != nil ? 1 : 0 )
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.loadUserProfile)) { output in
                    
                    // The id of the selected user
                    if let id = output.object as? String{
                        
                        account.getOtherUser(from: id) { user, err in
                            
                           // print("The user we got was ... \(user) and here the selected user is ... \(selected_user)")
                            
                            searchedUser = ""
                            selected_user = user
                            
                            withAnimation {
                                
                                
                               // print("The selected user is set to \(selected_user) and user is \(user)")
                                showProfilePopup = true
                            }
                            
                        }
                        /*
                        account.getNatalChart(from: id) { err, natalChart in
                            withAnimation {
                                print("the natal chart got is ... \(natalChart)")
                                selected_chart = natalChart
                            }
                        }
                        
                        */
                        
                    }
                    
                }
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.deletedCustomUserNatalChart)) { output in
                    
                    if let id = output.object as? String{
                        withAnimation {
                            
                            showProfilePopup = false
                        }
                        
                    }
                    
                }
          //  textForDeniedLocationServices()
            
            
            MoreInfoOnPlanet(planet: selectedPlanet)
                .opacity(selectedPlanet != nil ? 1 : 0 )
                .padding()

            
            SearchOtherUsersView( persons: returnedSearchedUserData)
                .opacity(returnedSearchedUserData.isEmpty || searchedUser.isEmpty ? 0 : 1)
            
            
            
        
               
                
        }
        .onAppear {
          
            if let id = Auth.auth().currentUser?.uid {
                
                try? self.beamsClient.addDeviceInterest(interest: id)
            }
            counter += 1
            // Will be nearby users in future
            account.getALLusers { err, foundusers in
                
             
                nearbyUsers.users = foundusers
                usersForGlobe.users = foundusers
                /*
                for user in nearbyUsers.users{
                    var name = user.name
                }
                */
                
                
            }
            
            account.getAllCustomUserChartsThisUserMade { err, users in
                
                customProfiles.users = users
                
            }
            
            
            
            
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.wantsMoreInfoFromNatalChart)) { obj in
           
            
            if let sign = obj.object as? ZodiacSign{
                
            }
            
            if let planet = obj.object as? Planet{
                
                withAnimation{
                    selectedPlanet = planet
                }
           
            }
            
            if let house = obj.object as? House{
            }
            
            if let angle = obj.object as? Angle{
                
            }
        
        }
        .onChange(of: searchedUser) { str in
        
            if str.isEmpty{
                AmareApp().dismissKeyboard {
                    
                }
            }
        }
            
           
        }
        
  
    func ringStyleFor(progress: String ) -> RingStyle {
        
        var color: Color = .green
        
        var number = 0.0
    
        switch progress {
        case "synastry":
            number = synastryscore.asDouble ?? 0
        case "chemistry":
            number = chemistry.asDouble ?? 0
        case "sex":
            number = sex.asDouble ?? 0
        case "love":
            number = love.asDouble ?? 0
        default:
            number = 0
        }
        
         number = number*100
        
        if number <= 25.0 { color = .red }
        if number > 25.0 {color = .orange}
        if number >= 40.0  {color = .yellow}
        if number >= 60.0 { color = .green }
        if number >= 85.0 {color = .blue}
        
                
        
       return  .init(
                        color: .color(color),
                        strokeStyle: .init(lineWidth: 5),
                        padding: 2.5)
    }
      
    /// The profile image for the popup
    func profileImageForPopup() -> some View {
        
        return samplePerson()
    }
    
    func createMap() -> some View {
        
        return Globe(people: usersForGlobe)
            .onAppear {
                
                AmareApp().delay(1) {
                    
                    askToTrackLocation()
                }
            }
           
            .edgesIgnoringSafeArea(.all)
           
            
        
        
            }
               
    
    func textForDeniedLocationServices() -> some View  {
        
        return Text("Please set your location permissions to `Always`. ")
            .opacity((locationManager.authorizationStatus == .authorizedAlways) ? 0 : 1)
            .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text("Some Error Occured")) })
    }
    

    func askToTrackLocation()  {
        
       
        if locationManager.authorizationStatus != .authorizedAlways{
            locationManager.requestLocation()
        }
       
        
withAnimation {
            
            if let loc = locationManager.location {
                
        
                region = MKCoordinateRegion(center: loc.coordinate, latitudinalMeters: 16093.4, longitudinalMeters: 16093.4)
            }
           
        }
        
        
        
    }

    /// Nearby user up to that you can tap on
    struct nearbyUser:  View {
        
        @State var user: AmareUser
        
        var body: some View{
        
            URLImage(URL(string: user.profile_image_url ?? testImages[0])!) { image in
                 
                 
                 image
                     .resizable()
                     .aspectRatio(contentMode: .fit)
                     .clipShape(Circle())
                      .overlay(Circle().stroke(colors.randomElement() ?? .blue, lineWidth: 1))
                      .shadow(radius: 15)
                      .frame(width: 100, height: 100)
                      //.padding()
                     .environment(\.urlImageService, URLImageService(fileStore: URLImageFileStore(),
                                                                     inMemoryStore: URLImageInMemoryStore()))
             }
    
            
            /*
            ImageFromUrl(user.profile_image_url ?? testImages[0])
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(colors.randomElement() ?? .blue, lineWidth: 1))
                .shadow(radius: 15)
                .aspectRatio(contentMode: .fit)
                .padding()
            */
            
        
        
    }

    }
    
    func samplePerson() -> some View {
        
        var peopleImages = ["https://lh3.googleusercontent.com/ogw/ADea4I5VDilLtQfyS7bwoGxcMqXW46dRo_ugPf4ombhR=s192-c-mo", testImages[0],
        
        "https://www.mainewomensnetwork.com/Resources/Pictures/vicki%20aqua%20headshot-smallmwn.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_tBdq4KSetrBr7nGFHxwxMZkrcBVp8SPpDA&usqp=CAU"]
        
        var colors: [Color] = [.gray, .green, .blue, .red, .orange]

        
       return ImageFromUrl(peopleImages[Int.random(in: 0...3)])
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .overlay(Circle().stroke(colors.randomElement() ?? .blue, lineWidth: 1))
            .shadow(radius: 15)
            
           

            
    }
    
    ///  A Nearby Person we've detected, these views should be at the top (or bottom) scrollable to select from
    func nearbyPerson(user: AmareUser) -> some View {
        
        var peopleImages = ["https://lh3.googleusercontent.com/ogw/ADea4I5VDilLtQfyS7bwoGxcMqXW46dRo_ugPf4ombhR=s192-c-mo", testImages[0],
        
        "https://www.mainewomensnetwork.com/Resources/Pictures/vicki%20aqua%20headshot-smallmwn.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_tBdq4KSetrBr7nGFHxwxMZkrcBVp8SPpDA&usqp=CAU"]
        
        var colors: [Color] = [.gray, .green, .blue, .red, .orange]
       
        
        return Button {
            
            showProfilePopup = true
        

        } label: {
            
            ImageFromUrl( user.profile_image_url ?? testImages[0])
                //.resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                 .overlay(Circle().stroke(colors.randomElement() ?? .blue, lineWidth: 1))
                 .shadow(radius: 15)
                 .frame(width: 60, height: 60)
                 .padding()
            
           /* URLImage(URL(string: user.profile_image_url ?? testImages[0])!) { image in
                
                
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                     .overlay(Circle().stroke(colors.randomElement() ?? .blue, lineWidth: 1))
                     .shadow(radius: 15)
                     .frame(width: 60, height: 60)
                     .padding()
                    .environment(\.urlImageService, URLImageService(fileStore: URLImageFileStore(),
                                                                    inMemoryStore: URLImageInMemoryStore()))
            } */
            
            
          
        }

    }

    func sampleIcon() -> some View {
        
        var peopleImages = ["https://lh3.googleusercontent.com/ogw/ADea4I5VDilLtQfyS7bwoGxcMqXW46dRo_ugPf4ombhR=s192-c-mo", testImages[0],
        
        "https://www.mainewomensnetwork.com/Resources/Pictures/vicki%20aqua%20headshot-smallmwn.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_tBdq4KSetrBr7nGFHxwxMZkrcBVp8SPpDA&usqp=CAU"]
        
        var colors: [Color] = [.gray, .green, .blue, .red, .orange]
        
        return Button {
            
            withAnimation{
                
                showProfilePopup = true
                
                
                
                
                
            }
           
            withAnimation(.easeInOut(duration: 3)) {
                synastryscore = RingProgress.percent(Double.random(in: 0...1))
            }
                
            
        } label: {
            
            ImageFromUrl(peopleImages[Int.random(in: 0...3)])
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(colors.randomElement() ?? .blue, lineWidth: 1))
                .shadow(radius: 15)
                .padding()
        }
        

        
     
    }
    
    /*
    func usersNatalChart() -> some View {
        
        return SmallNatalChartView()

            .makeSmall(with: chart/*, shownAspect: aspectToGet*/)
            .animation(.easeIn(duration: 3))
            .onReceive(Just(account), perform: { _ in
        
               // guard !didChangeCharts else { return }
                
               // AmareApp().delay(1) {
                    
                    //person1 = account.data?.name ?? ""
                    chart = account.data?.natal_chart
                    print("The chart after delay ... \(chart)")
                 
               // }
                
            })
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.wantsMoreInfoFromNatalChart)) { obj in
               
                showBottomPopup = true
                
                if let sign = obj.object as? ZodiacSign{
                    
                    infoToShow = sign.rawValue
                }
                
                if let planet = obj.object as? Planet{
                    
                    infoToShow = planet.name.rawValue
                }
                
                if let house = obj.object as? House{
                    
                    infoToShow = String(house.ordinality)
                }
                
                if let angle = obj.object as? Angle{
                    
                    infoToShow = angle.name.rawValue
                }
             //   infoToShow = (obj.object as? ZodiacSign)?.rawValue }
            
            }
           
    
            .onAppear(perform: {
                
                
                AmareApp().delay(1) {
                    
                    //person1 = account.data?.name ?? ""
                    withAnimation(.easeIn(duration: 3)) {
                        chart = account.data?.natal_chart
                        print("The chart after delay ... \(chart)")
                    }
                    
                 
                }
            })
            .padding()
    }
    */
    }
    
    
    
/*
struct ConcaveGlassView: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .padding()
                .frame(height: 50)
                .background(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(.linearGradient(colors:[.black,.white.opacity(0.75)], startPoint: .top, endPoint: .bottom), lineWidth: 2)
                        .blur(radius: 2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(.radialGradient(Gradient(colors: [.clear,.black.opacity(0.1)]), center: .bottomLeading, startRadius: 300, endRadius: 0), lineWidth: 15)
                        .offset(y: 5)
                )
                .cornerRadius(14)
        } else {
            // Fallback on earlier versions
            content
                .padding()
                .frame(height: 50)
                .cornerRadius(14)
                .shadow(color: .white, radius: 3, x: -3, y: -3)
                .shadow(color: .black, radius: 3, x: 3, y: 3)
        }
    }
}
 */
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(Account())
           // .preferredColorScheme(.dark)
    }
}




class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?


    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }

    func requestLocation() {
        manager.requestAlwaysAuthorization()
    }
    
    func stop()  {
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let loc = locations.last else {return }
        location = loc
        
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
    }
    
    var statusString: String {
        guard let status = authorizationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
}


struct Globe: UIViewRepresentable{
    
    @StateObject var people: PeopleForGlobe = PeopleForGlobe()

    /// Pass a state variable here and when it changes, the map will fly to this location
   // @Binding var locationToGoTo: CLPlacemark? = nil
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        
       
    
        
        
        // change the map type here
        mapView.mapType = .hybridFlyover
        mapView.tintColor = UIColor(red: 1.00, green: 0.01, blue: 0.40, alpha: 1.00)
        mapView.showsUserLocation = true
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 16093400, longitudinalMeters: 16093400)
        
        mapView.animatedZoom(to: region, for: 3)
        
        mapView.delegate = context.coordinator
        
        mapView.register(UserAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(UserAnnotation.self))
        
        return mapView
    }
    
    
    func updateUIView(_ view: MKMapView, context: Context) {
        

        for user in people.users {
            
           
       
            if let lat = user.residence?.latitude, let lon =  user.residence?.longitude{
                
               // print("*** the lat and lon are .. \(lat) and \(lon)")
                // make a pins
              //  let pin = MKPointAnnotation()
                let pin = UserAnnotation()
                
                pin.user = user
                
                // set the coordinates
               // pin.coordinate =  loc
                pin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                //pin.setValue(user.profile_image_url, forKey: "profile_image")
                
                // set the title
              //  pin.title = location.name
              
                
                view.showsUserLocation = false
                // add to map
               // view.addAnnotation(pin)
            }
       
            
        }
        
       
        
        
    }
    
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        class Coordinator: NSObject, MKMapViewDelegate {
            var parent: Globe

            init(_ parent: Globe) {
                self.parent = parent
            }
            
          
            
            /// The map view asks `mapView(_:viewFor:)` for an appropiate annotation view for a specific annotation.
            /// - Tag: CreateAnnotationViews
            func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
                
                guard annotation.isKind(of: UserAnnotation.self) else {
                    // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
                    print("***Not a type of user annotation..")
                    return nil
                }
                
                print("***inside mapView(_:)")
                var annotationView: MKAnnotationView?
                
                if let annotation = annotation as? UserAnnotation {
                    annotationView = setupUserAnnotation(for: annotation, on: mapView)
                }
                
                return annotationView
                    
            }
            
            
            /// The map view asks `mapView(_:viewFor:)` for an appropiate annotation view for a specific annotation. The annotation
            /// should be configured as needed before returning it to the system for display.
            /// - Tag: ConfigureAnnotationViews
            private func setupUserAnnotation(for annotation: UserAnnotation, on mapView: MKMapView) -> MKAnnotationView {
                let reuseIdentifier = NSStringFromClass(UserAnnotation.self)
                let flagAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)
                
                flagAnnotationView.canShowCallout = false
                
                // Provide the annotation view's image.
                //let image = #imageLiteral(resourceName: "flag")
               // flagAnnotationView.image = image
                let image = UIImage(systemName: "lasso")!
                flagAnnotationView.image = image
       
                // Provide the left image icon for the annotation.
                flagAnnotationView.leftCalloutAccessoryView = UIImageView(image: image)
                
                //UIImageView(image: #imageLiteral(resourceName: "sf_icon"))
                
                // Offset the flag annotation so that the flag pole rests on the map coordinate.
               // let offset = CGPoint(x: image.size.width / 2, y: -(image.size.height / 2) )
                //flagAnnotationView.centerOffset = offset
                
              //  flagAnnotationView.tintColor = .green
                
                return flagAnnotationView
            }
            
            
        }
    
    
}

struct FlatGlassView : ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .padding()
                .frame(height: 50)
                .background(.ultraThinMaterial)
                .cornerRadius(14)
        } else {
            // Fallback on earlier versions
            content
                .padding()
                .frame(height: 50)
                .cornerRadius(14)
        }
    }
}

class UserAnnotation: NSObject, MKAnnotation {
    
    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic var coordinate = CLLocationCoordinate2D(latitude: 37.779_379, longitude: -122.418_433)
    
    // Required if you set the annotation view's `canShowCallout` property to `true`
   // var title: String? = NSLocalizedString("SAN_FRANCISCO_TITLE", comment: "SF annotation")
    
    // This property defined by `MKAnnotation` is not required.
  //  var subtitle: String? = NSLocalizedString("SAN_FRANCISCO_SUBTITLE", comment: "SF annotation")
    
    var user: AmareUser?
    
}


class UserAnnotationView: MKMarkerAnnotationView {
    static let glyphImage: UIImage = {
        let rect = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))
        return UIGraphicsImageRenderer(bounds: rect).image { _ in
            let radius: CGFloat = 11
            let offset: CGFloat = 7
            let insetY: CGFloat = 5
            let center = CGPoint(x: rect.midX, y: rect.maxY - radius - insetY)
            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi, clockwise: true)
            path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.minY + insetY), controlPoint: CGPoint(x: rect.midX - radius, y: center.y - offset))
            path.addQuadCurve(to: CGPoint(x: rect.midX + radius, y: center.y), controlPoint: CGPoint(x: rect.midX + radius, y: center.y - offset))
            path.close()
            UIColor.white.setFill()
            path.fill()
        }
    }()

    override var annotation: MKAnnotation? {
        didSet { configure(for: annotation) }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        if let annotation = annotation as? UserAnnotation{
        
            var image = ImageFromUrl(annotation.user?.profile_image_url ?? "")
            glyphImage =  Self.glyphImage//image.image()
        }
       
      //  markerTintColor = #colorLiteral(red: 0.005868499167, green: 0.5166643262, blue: 0.9889912009, alpha: 1)
        
        var colors: [UIColor] = [.blue, .red, .orange, .yellow, .green, .systemPink]
        markerTintColor = colors.randomElement()!

        configure(for: annotation)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for annotation: MKAnnotation?) {
        displayPriority = .required

        // if doing clustering, also add
        // clusteringIdentifier = ...
    }
    
    
}
struct ConcaveGlassView: ViewModifier {
    func body(content: Content) -> some View {
        
        
        if #available(iOS 15.0, *) {
            content
                .padding()
                .frame(height: 15)
                .background(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(.linearGradient(colors:[.black,.white.opacity(0.75)], startPoint: .top, endPoint: .bottom), lineWidth: 2)
                        .blur(radius: 2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(.radialGradient(Gradient(colors: [.clear,.black.opacity(0.1)]), center: .bottomLeading, startRadius: 300, endRadius: 0), lineWidth: 15)
                        .offset(y: 5)
                )
                //.cornerRadius(14)
                .clipShape(Circle())
        } else {
            // Fallback on earlier versions
            content
                .padding()
                .frame(height: 15)
                // .cornerRadius(14)
                .clipShape(Circle())
                .shadow(color: .white, radius: 3, x: -3, y: -3)
                .shadow(color: .black, radius: 3, x: 3, y: 3)
        }
    }
}

struct ConvexGlassView: ViewModifier {
    
   
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .padding()
                .frame(height: 15)
                .background(.ultraThinMaterial)
                .overlay(
                    LinearGradient(colors: [.clear,.black.opacity(0.2)], startPoint: .top, endPoint: .bottom))
              //  .cornerRadius(14)
            
                .clipShape(Circle())
                .shadow(color: .white.opacity(0.65), radius: 1, x: -1, y: -2)
                .shadow(color: .black.opacity(0.65), radius: 2, x: 2, y: 2)
        } else {
            // Fallback on earlier versions
            content
                .padding()
                .frame(height: 15)
                // .cornerRadius(14)
                .clipShape(Circle())
                .shadow(color: .white, radius: 3, x: -3, y: -3)
                .shadow(color: .black, radius: 3, x: 3, y: 3)
        }
    }
}

