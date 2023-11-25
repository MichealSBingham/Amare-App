//
//  LocationManager.swift
//  Amare
//
//  Created by Micheal Bingham on 11/24/23.
//

import CoreLocation
import Combine

import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocation?
    /// 6-letter percision to use to detect nearby users, do not store this in the database because this is not the exact user's location
    @Published var currentGeoHash6: String = ""
    @Published var currentGeoHash8: String = ""
    @Published var lastError: Error?
    @Published var authorizationStatus: CLAuthorizationStatus
   
    

    override init() {
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
        switch status {
        case .denied, .restricted:
            // Handle denied case
            print("User denied the location")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
        
        let geoHash = location.geohash(precision: 6) ?? ""
        if self.currentGeoHash6 != geoHash { self.currentGeoHash6 = geoHash }
        
        let geohash8 = location.geohash(precision: 8) ?? ""
        if self.currentGeoHash8 != geohash8 {
            // Geohash8 changed
            //Update Geohash exit because it changed ... yes iI know the name is misleading but the oldGeohash really is == current geohash8 here because we havne't change it yet.
            FirestoreService.shared.updateGeohashEntryExit(newGeohash: geohash8, oldGeohash: self.currentGeoHash8, location: location, completion: {
                error in 
            })
            self.currentGeoHash8 = geohash8
        }

        FirestoreService.shared.updateCurrentUserLocation(location) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.lastError = error
                    print("Error updating user location in Firestore: \(error.localizedDescription)")
                } else {
                    print("User location updated in Firestore successfully")
                }
            }
        }
    }

  
}


 
