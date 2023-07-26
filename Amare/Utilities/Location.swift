//
//  Location.swift
//  Love
//
//  Created by Micheal Bingham on 6/23/21.
//

import Foundation
import CoreLocation
import MapKit
import Contacts
//import GeoFire
import Combine


class Location {
    
    var latitude: Double?
    var longitude: Double?
    
    var city: String?
    var state: String?
    var country: String? 
    
    var placemark: CLPlacemark?
    

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        
        
        
        CLLocation(latitude: latitude, longitude: longitude).placemark { placemark, error in
            
            guard let mark = placemark else{
                
                return
            }
            
            self.city = mark.city
            self.state = mark.state
            self.country = mark.country
            return
            
        }
    }
    
    
    
   
}


extension CLPlacemark {
    /// street name, eg. Infinite Loop
    var streetName: String? { thoroughfare }
    /// // eg. 1
    var streetNumber: String? { subThoroughfare }
    /// city, eg. Cupertino
    var city: String? { locality }
    /// neighborhood, common name, eg. Mission District
    var neighborhood: String? { subLocality }
    /// state, eg. CA
    var state: String? { administrativeArea }
    /// county, eg. Santa Clara
    var county: String? { subAdministrativeArea }
    /// zip code, eg. 95014
    var zipCode: String? { postalCode }
    /// postal address formatted
    @available(iOS 11.0, *)
    var postalAddressFormatted: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter().string(from: postalAddress)
    }
    
    /// Returns the Geohash string of the location
    var geohash: String  { return "FIX THIS"
        
    }/* { return GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: self.location?.coordinate.latitude ?? 0, longitude: self.location?.coordinate.longitude ?? 0) ) } */
}

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}

/// We add a published variable here so we can listen for location updates and locations permissions status updates 
class LocationWhenInUseManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func request()  {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func stop()  {
        locationManager.stopUpdatingLocation()
    }

   
    
    var statusString: String {
        guard let status = locationStatus else {
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

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        print(#function, location)
    }
}

/// We add a published variable here so we can listen for location updates and locations permissions status updates. This will let you get the user location always
/*
class LocationAlwaysManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }

    func request()  {
        
        locationManager.requestAlwaysAuthorization()
    }
    
    func stop()   {
        locationManager.stopUpdatingLocation()
    }
    
    var statusString: String {
        guard let status = locationStatus else {
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

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        print(#function, location)
    }
}
*/
