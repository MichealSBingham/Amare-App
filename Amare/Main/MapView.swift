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

struct MapView: View {
    @EnvironmentObject private var account: Account
    
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
    
    /*
    // Profile Popup Stuff
    @State var showAddFriend: Bool = true
    @State var showBottomPopup: Bool = false
    @State var infoToShow:String?
    @State private var chart: NatalChart?
    */
    
    
    @StateObject var nearbyUsers: NearbyPeople = NearbyPeople()
    @State var selected_user: AmareUser?
    
    
    var body: some View {
        
        ZStack{
            
            createMap()
                .onTapGesture {
                    withAnimation {
                        print("** Tapped off screen")
                        showProfilePopup = false
                        
                    }
                    
                }
                
            
            
            VStack{
                
             //   HStack{
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        
                        HStack{
                            
                            
                            
                            ForEach(nearbyUsers.users, id: \.interal_ui_use_only_for_iding) { user in
                             
                               
            
                                    //TODO: make this a state variable so it can listen to real time changes
                                Button {
                                 
                                    withAnimation(.easeInOut) {
                                        showProfilePopup = true
                                        selected_user = user
                                    }
                                } label: {
                                    
                                    nearbyUser(user: user)
                                    
                                    /*
                                    var name: String = user.name ?? "noname"
                                    Text(name)
                                        */
                                    
                                        
                                }.onAppear(perform: {
                                
                                    print("should have loaded \(user.name)")
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
            //    }
               
                
                Spacer()
                
                Toggle("", isOn: $discoverModeEnabled )
                    .padding()
            }
            
            
            
            ProfilePopup(user: selected_user)
                .preferredColorScheme(.dark)
                .opacity(showProfilePopup && selected_user != nil ? 1 : 0 )
          //  textForDeniedLocationServices()
            
           /* ZStack{
                
            VStack{
                
          
                
                    ScrollView(.horizontal, showsIndicators: false){
                        
                        HStack{
                            
                            
                            sampleIcon()
                            sampleIcon()
                            sampleIcon()
                            sampleIcon()
                            sampleIcon()
                            sampleIcon()
                            
                        }
                        
                        
                    }
                
                
                Spacer()
                
                
                Toggle("", isOn: $discoverModeEnabled )
                    .padding()
               
                
           }
                
      
                
                profilePopup()
                    .opacity(showProfilePopup ? 1: 0)
                
                
                
                    
                    
                }
               */
               
                
        }.onAppear {
            // Load the nearby users
            account.getALLusers { err, foundusers in
                
                nearbyUsers.users = foundusers
                for user in nearbyUsers.users{
                    var name = user.name
                    print("inside get all users ... nearbyUsers.users is \(name)")
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
        /*
    /// A popup view of a profile from a person clicked on in the map/globe discover view.
    func profilePopup() -> some View {
        
        
        
        // Popup view on person information
        ZStack{
            
            
            
            VStack{
               
                
                ZStack{
                    
                    profileImageForPopup()
                    HStack{
                        Spacer()
                        
                        
                        ZStack{
                            
                            Button {
                                
                                showAddFriend.toggle()
                            } label: {
                                
                                ZStack{
                                    
                                    
                                    Image(systemName: "plus.circle")
                                        .modifier(ConvexGlassView())
                                         .opacity(showAddFriend ? 1: 0 )
                                     
                                    
                                    
                                    Image(systemName: "plus.circle.fill")
                                          .modifier(ConcaveGlassView())
                                          .opacity(showAddFriend == false ? 1 : 0)
                                     
                                }
                                
                               
                                
                                
                                
                            }.offset(x: 10, y: -35.0)
                            
                           
                        }
                        
                        

                              
                      
                    }
                    
                }
                  
                
                // Name
                Text("\(sampleNames.randomElement()!)")
                            .font(.largeTitle)
                             .bold()
                             .frame(maxWidth : .infinity, alignment: .center)
                            //.padding(.top)
                            .foregroundColor(Color.primary.opacity(0.4))
                            .modifier(FadeModifier(control: showProfilePopup))
                
                
                
                
                    // Classification
                Text("\(sampleClassifications.randomElement()!)")
                                    .font(.callout)
                                    .frame(maxWidth : .infinity, alignment: .center)
                                    .foregroundColor(Color.primary.opacity(0.4))
                                    .padding(.bottom)
                                    .modifier(FadeModifier(control: showProfilePopup))
                                   // .shimmering(duration: 5, bounce: true)
                
                
                // Latin Phrase
                Text("\(sampleLatinPhrases.randomElement()!)")
                                    .font(.callout)
                                    .frame(maxWidth : .infinity, alignment: .center)
                                    .foregroundColor(Color.primary.opacity(0.4))
                                    .modifier(FadeModifier(control: showProfilePopup))
                                  
                                   // .shimmering(duration: 5, bounce: true)
                                   // .padding([.bottom, .top])
                TabView{
                    /*
                    HStack{
                        
                        MainPlacementView(planet: .Sun, size: 20).padding(.trailing)
                        
                        MainPlacementView(planet: .Moon, size: 20).padding(.trailing)
                        
                        /// Should be ascendant
                        MainPlacementView(planet: .Jupiter, size: 20).padding(.trailing)
                        
                    }
                        
                    HStack{
                        MainPlacementView(planet: .Mercury, size: 20).padding(.trailing)
                        MainPlacementView(planet: .Venus, size: 20).padding(.trailing)
                        
                
                        MainPlacementView(planet: .Mars, size: 20).padding(.trailing)
                    }
                        
                    HStack{
                        
                        MainPlacementView(planet: .Jupiter, size: 20).padding(.trailing)
                        MainPlacementView(planet: .Saturn, size: 20).padding(.trailing)
                        
                    
                        MainPlacementView(planet: .Uranus, size: 20).padding(.trailing)
                    }
                        
                       
                    HStack{
                        MainPlacementView(planet: .Neptune, size: 20).padding(.trailing)
                        MainPlacementView(planet: .Pluto, size: 20).padding(.trailing)
                        
                        /// Should be ascendant
                        MainPlacementView(planet: .Mars, size: 20).padding(.trailing)
                    }
                        
                        
                        
                     
                        
                        
                        */
                    
                   
                }
             
                .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                .frame(width: .infinity, height: 150)
                .tabViewStyle(.page)
                .padding(.top, -50)
              
                    
                
                                    
                
                // Ring styles for progress circles
                let o_ringstyle: RingStyle = .init(
                    color: .color(.gray),
                    strokeStyle: .init(lineWidth: 10)
                )
                
              
               
                    
                
                
                TabView {
                    
                        
                    
                                
                      // Synastry Score
                                ProgressRing(progress: $synastryscore, axis: .top, clockwise: true, outerRingStyle: o_ringstyle, innerRingStyle: ringStyleFor(progress: "synastry")) { percent in
                                    
                                    
                                    let pcent = Int(round(percent*100))
                                    
                                    VStack{
                                        
                                            
                                        
                                        Text("\(pcent)")
                                                        .font(.title)
                                                        .bold()
                                    }
                                    
                                    
                                }//.animation(.easeInOut(duration: 5))
                                    .frame(width: 150, height: 150)
                                    .onAppear {
                                        
                                        withAnimation(.easeInOut(duration: 3)) {
                                            synastryscore = RingProgress.percent(Double.random(in: 0...1))
                                        }
                                    }
                    
                                  
                                
                                
                 // Chemistry, Love, Sex
                    HStack{
                                ProgressRing(progress: $chemistry, axis: .top, clockwise: true, outerRingStyle: o_ringstyle, innerRingStyle: ringStyleFor(progress: "chemistry")) { percent in
                                    
                                    
                                    let pcent = Int(round(percent*100))
                                    
                                    VStack{
                                        
                                        Text("Chemistry")
                                            .font(.subheadline)
                                            
                                            
                                        
                                        Text("\(pcent)")
                                                        .font(.title)
                                                        .bold()
                                    }
                                    
                                    
                                }
                                    .frame(width: 115, height: 115)
                                    .onAppear {
                                        
                                        withAnimation(.easeInOut(duration: 3)) {
                                            chemistry = RingProgress.percent(Double.random(in: 0...1))

                                        }
                                    }
                                
                                
                                ProgressRing(progress: $love, axis: .top, clockwise: true, outerRingStyle: o_ringstyle, innerRingStyle: ringStyleFor(progress: "love")) { percent in
                                    
                                    
                                    let pcent = Int(round(percent*100))
                                    
                                    VStack{
                                        
                                        Text("Love")
                                            .font(.subheadline)
                                            
                                        
                                        Text("\(pcent)")
                                                        .font(.title)
                                                        .bold()
                                    }
                                    
                                    
                                }
                                    .frame(width: 115, height: 115)
                                    .onAppear {
                                        
                                        withAnimation(.easeInOut(duration: 3)) {
                                            love = RingProgress.percent(Double.random(in: 0...1))

                                        }
                                    }
                                
                                ProgressRing(progress: $sex, axis: .top, clockwise: true, outerRingStyle: o_ringstyle, innerRingStyle: ringStyleFor(progress: "sex")) { percent in
                                    
                                    
                                    let pcent = Int(round(percent*100))
                                    
                                    VStack{
                                        
                                        Text("Sex")
                                            .font(.subheadline)
                                            
                                        
                                        Text("\(pcent)")
                                                        .font(.title)
                                                        .bold()
                                    }
                                    
                                    
                                }
                                    .frame(width: 115, height: 115)
                                    .onAppear {
                                        
                                        withAnimation(.easeInOut(duration: 3)) {
                                            sex = RingProgress.percent(Double.random(in: 0...1))

                                        }
                                    }
                        
                    }
                            
                    Button(action: {
                        print("Tapped natal chart")
                    }) {
                        //usersNatalChart()
                    }
                
                       
                            
                        }
                        
                        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                        .frame(width: .infinity, height: 150)
                        .tabViewStyle(.page)
                
                
                
                     
                     
                }
            
            
            
        }
       
            
            
            
        .padding()
        .background(.ultraThinMaterial)
        .foregroundColor(Color.primary.opacity(0.35))
        .foregroundStyle(.ultraThinMaterial)
        .cornerRadius(20)
        .padding()
        .onAppear {
            /*
            account.getALLusers { err, users in
                
                for user in users {
                }
            } */
        }
            
    }
    */
    /// The profile image for the popup
    func profileImageForPopup() -> some View {
        
        return samplePerson()
    }
    
    func createMap() -> some View {
        
        return Globe()
            .onAppear {
                
                AmareApp().delay(1) {
                    
                    askToTrackLocation()
                }
            }
           // .grayscale((locationManager.authorizationStatus == .authorizedAlways) ? 0 : 1)
            .edgesIgnoringSafeArea(.all)
            
        
        /*
        return Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: places) {
            
            MapMarker(coordinate: $0.coordinate, tint: .pink)
            
        }.onAppear(perform: {
            
            // We delayed because we need to wait for location manager to instanatiate
            AmareApp().delay(1) {
                
                askToTrackLocation()
            }
            
        })
            .grayscale((locationManager.authorizationStatus == .authorizedAlways) ? 0 : 1)
            .edgesIgnoringSafeArea(.top)
            .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text("Some Error Occured")) })
        
        */
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
        
    
            
            
            ImageFromUrl(user.profile_image_url ?? testImages[0])
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(colors.randomElement() ?? .blue, lineWidth: 1))
                .shadow(radius: 15)
                .aspectRatio(contentMode: .fit)
                .padding()
            
        
        
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
            
            ImageFromUrl(user.profile_image_url ?? testImages[0])
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(colors.randomElement() ?? .blue, lineWidth: 1))
                .shadow(radius: 15)
                .aspectRatio(contentMode: .fit)
                .padding()
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
    
 
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        // change the map type here
        mapView.mapType = .hybridFlyover
        mapView.tintColor = UIColor(red: 1.00, green: 0.01, blue: 0.40, alpha: 1.00)
        mapView.showsUserLocation = true
    
        return mapView
    }
    
    
    func updateUIView(_ view: MKMapView, context: Context) {
        /*
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
        */
        
        view.removeAnnotations(view.annotations)
        view.showsUserLocation = true
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 16093400, longitudinalMeters: 16093400)
        
        view.animatedZoom(to: region, for: 3)
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

