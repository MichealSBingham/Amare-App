//
//  Map+Extensions.swift
//  Amare
//
//  Created by Micheal Bingham on 11/24/23.
//

import Foundation
import CoreLocation
import FirebaseFirestore
import MapKit
import GeohashKit

extension MKCoordinateRegion {
    static var defaultNYCRegion: MKCoordinateRegion {
        let center = CLLocationCoordinate2D(latitude: 40.7829, longitude: -73.9654) // Central Park coordinates
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // Span covering a few blocks

        return MKCoordinateRegion(center: center, span: span)
    }
}



extension GeoPoint {
    func toCLLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}



extension CLLocation {
    func geohash(precision: Int) -> String? {
        guard let geohashObject = Geohash(coordinates: (self.coordinate.latitude, self.coordinate.longitude), precision: precision) else {
            return nil
        }
        return geohashObject.geohash
    }
}


extension MKPlacemark {
    var cityStateCountry: String {
        var components = [String]()

        if let locality = locality {
            components.append(locality)
        }

        if let administrativeArea = administrativeArea {
            components.append(administrativeArea)
        }

        if let country = country {
            components.append(country)
        }

        return components.joined(separator: ", ")
    }
}
