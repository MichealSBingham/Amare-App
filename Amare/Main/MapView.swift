//
//  MapView.swift
//  Amare
//
//  Created by Micheal Bingham on 8/12/21.
//

import SwiftUI
import MapKit
import CoreLocation

// Sample Data

var sampleNames: [String] = ["Micheal S. Bingham", "John", "Jane", "William Scott"]
var sampleClassifications: [String] = ["Better Off Friends", "Soulmate", "Partner", "Fling", "Enemy", "Stay Away"]
var sampleLatinPhrases: [String] = ["Amor Vincit Omnia", "Enjoy while it lasts, but days of length you shall not have", "Love conquers all.", "This is your soulmate.", "Don't fall in love.", "Beautiful Relationship."]

struct MapView: View {
    @EnvironmentObject private var account: Account
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360))
    
    @State private var someErrorOccured: Bool = false
    
    @StateObject var locationManager = LocationManager()
    
    @State var discoverModeEnabled: Bool = false


    
    @State var places: [MapAnnotation] = []
    
    
    
    var body: some View {
        
        ZStack{
            
            createMap()
          //  textForDeniedLocationServices()
            
            ZStack{
                
            VStack{
                
              //  Toggle("", isOn: $discoverModeEnabled )
              //        .padding()
                
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
                /*
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
                 */
                
           }
                
                // Popup view on person information
                VStack{
                    
                      samplePerson()
                    
                    // Name
                    Text("\(sampleNames.randomElement()!)")
                                .font(.largeTitle)
                                 .bold()
                                 .frame(maxWidth : .infinity, alignment: .center)
                                //.padding(.top)
                                .foregroundColor(Color.primary.opacity(0.4))
                    
                    
                        // Classification
                    Text("\(sampleClassifications.randomElement()!)")
                                        .font(.callout)
                                        .frame(maxWidth : .infinity, alignment: .center)
                                        .foregroundColor(Color.primary.opacity(0.4))
                                        .padding(.bottom)
                                       // .shimmering(duration: 5, bounce: true)
                    
                    // Latin Phrase
                    Text("\(sampleLatinPhrases.randomElement()!)")
                                        .font(.callout)
                                        .frame(maxWidth : .infinity, alignment: .center)
                                        .foregroundColor(Color.primary.opacity(0.4))
                                       // .shimmering(duration: 5, bounce: true)
                    
                    
                    
                }
                            .padding()
                            .background(.ultraThinMaterial)
                            .foregroundColor(Color.primary.opacity(0.35))
                            .foregroundStyle(.ultraThinMaterial)
                            .cornerRadius(20)
                            .padding()
                // End of pop up
                
            }
            
            
            /*
            VStack{
                /*
                HStack{
                    
                    Toggle("", isOn: $discoverModeEnabled )
                        .padding()
                    
                }
                */
                Spacer()
                
            }
            */
            
        }
        
            
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

    func sampleIcon() -> some View {
        
        var peopleImages = ["https://lh3.googleusercontent.com/ogw/ADea4I5VDilLtQfyS7bwoGxcMqXW46dRo_ugPf4ombhR=s192-c-mo", testImages[0],
        
        "https://www.mainewomensnetwork.com/Resources/Pictures/vicki%20aqua%20headshot-smallmwn.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_tBdq4KSetrBr7nGFHxwxMZkrcBVp8SPpDA&usqp=CAU"]
        
        var colors: [Color] = [.gray, .green, .blue, .red, .orange]
        
        return Button {
            
            print("Tapped Icon")
            
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
    
}

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
