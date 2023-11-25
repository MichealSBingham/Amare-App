//
//  MapView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/22/23.
//

import SwiftUI
import MapKit

import SwiftUI
import MapKit


struct MapView: View {
    @EnvironmentObject var userDataModel: UserProfileModel
    @StateObject var locationManager: LocationManager = LocationManager()
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        Map()
            .ignoresSafeArea()
    }
    
}

struct MapView2: View {
    @EnvironmentObject var userDataModel: UserProfileModel
    @StateObject var locationManager: LocationManager = LocationManager()
    @StateObject private var viewModel = MapViewModel()
    @State private var isInvisibleMode = false

    var body: some View {
        ZStack {
            if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
                Map(coordinateRegion: $viewModel.region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(MapUserTrackingMode.follow))
                    .opacity(isInvisibleMode ? 0.5 : 1.0)  // Tint map if in invisible mode
            } else {
                locationPermissionView
            }
            
            // Invisible Mode Toggle
            Toggle("Invisible Mode", isOn: $isInvisibleMode)
                .onChange(of: isInvisibleMode) { newValue in
                    viewModel.updateInvisibleMode(newValue)
                }
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .padding()
        }
    }

    /*
    private var actualMapView: some View {
        Map(coordinateRegion: $viewModel.region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .follow) {
            // Annotations
        }
        .onChange(of: isInvisibleMode) { _ in
            if isInvisibleMode {
                viewModel.stopFetchingUsers()
            } else {
                viewModel.startFetchingUsers()
            }
        }
    }
*/
    private var locationPermissionView: some View {
        VStack {
            Text("Location Permission Needed")
            Button("Enable Location") {
                // Trigger location permission request
                //locationManager.requestLocationPermission()
            }
        }
    }
}

    
    
    
    
    // handling error
    /*
        .alert(item: $locationManager.lastError) { error in
                    Alert(
                        title: Text("Error"),
                        message: Text(error.localizedDescription),
                        dismissButton: .default(Text("OK")) {
                            // Reset the error after the alert is dismissed
                            locationManager.lastError = nil
                        }
                    )
                }
    */



#Preview {
    MapView()
        .environmentObject(UserProfileModel())
}
