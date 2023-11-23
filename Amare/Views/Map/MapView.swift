//
//  MapView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/22/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060), // Example coordinates (New York City)
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )

    var body: some View {
        Map(coordinateRegion: $region)
      
           .ignoresSafeArea()
        //.edgesIgnoringSafeArea(.all) // Makes the map full screen
    }
}


#Preview {
    MapView()
}
