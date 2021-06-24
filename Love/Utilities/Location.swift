//
//  Location.swift
//  Love
//
//  Created by Micheal Bingham on 6/23/21.
//

import Foundation


import MapKit
import Contacts


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
}

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}
