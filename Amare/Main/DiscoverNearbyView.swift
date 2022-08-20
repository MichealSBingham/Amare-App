//
//  DiscoverNearbyView.swift
//  Amare
//
//  Created by Micheal Bingham on 8/20/22.
//

import SwiftUI
import MapKit
struct DiscoverNearbyView: View {
	
	@State private var region = MKCoordinateRegion(
					center: CLLocationCoordinate2D(
						latitude: 40.83834587046632,
						longitude: 14.254053016537693),
					span: MKCoordinateSpan(
						latitudeDelta: 0.03,
						longitudeDelta: 0.03)
					)
	
    var body: some View {
		
		
		GlobeView()
			.ignoresSafeArea()
		
		
    }
}

struct DiscoverNearbyView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverNearbyView()
    }
}
