//
//  MapView.swift
//  Amare
//
//  Created by Micheal Bingham on 8/12/21.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @EnvironmentObject private var account: Account
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360))
    
    @State private var someErrorOccured: Bool = false
    
    @StateObject var locationManager = LocationManager()

    
    @State var places: [MapAnnotation] = []
    
    var body: some View {
        
        ZStack{
            
            createMap()
            textForDeniedLocationServices()
            
        }
        
            
    }
    
    
    
    func createMap() -> some View {
        
        
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
            }
               
    
    func textForDeniedLocationServices() -> some View  {
        
        return Text("Please set your location permissions to `Always`. ")
            .opacity((locationManager.authorizationStatus == .authorizedAlways) ? 0 : 1)
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

    

    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(Account())
            .preferredColorScheme(.dark)
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

