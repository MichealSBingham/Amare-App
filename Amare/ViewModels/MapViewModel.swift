//
//  MapViewModel.swift
//  Amare
//
//  Created by Micheal Bingham on 11/24/23.
//

import Foundation
import Combine
import FirebaseFirestore
import MapKit
import SwiftUI
class MapViewModel: ObservableObject {
    @Published var region: MKCoordinateRegion = MKCoordinateRegion.defaultNYCRegion // Default region
    
    @Published var nearbyUsers: [AppUser] = []
    private var nearbyUsersListener: ListenerRegistration?
    
    /// Listen for nearby users based on the geohash
       func listenForNearbyUsers(geohash: String) {
           // Only update the listener if the geohash has changed
           print("Just called MapViewModel.listenForNearbyUsers")

           // Remove any existing listener
           nearbyUsersListener?.remove()

           // Set up a new listener for the geohash
           nearbyUsersListener = FirestoreService.shared.listenForUsers(near: geohash) { [weak self] result in
               switch result {
               case .success(let users):
                   DispatchQueue.main.async {
                       // Update nearby users, considering not updating if the contents are the same
                       print("did get nearby users \(users)")
                       if !(self?.nearbyUsers.elementsEqual(users, by: { $0.id == $1.id }) ?? false) {
                           withAnimation {
                               self?.nearbyUsers = users
                           }
                       }
                   }
               case .failure(let error):
                   print("Error fetching nearby users: \(error.localizedDescription)")
               }
           }
       }

       // Ensure to remove the listener when it's no longer needed
    deinit {
           nearbyUsersListener?.remove()
    }

    func updateInvisibleMode(_ isInvisible: Bool) {
        // Update the 'invisible' mode status in Firestore
    }

    func startFetchingUsers() {
        // Start fetching nearby users
    }

    func stopFetchingUsers() {
        // Stop fetching nearby users
    }
    
    // Static function to create a mock instance
       static func mockInstance() -> MapViewModel {
           let viewModel = MapViewModel()
           viewModel.nearbyUsers = AppUser.generateMockData(of: 10) // Assuming this function returns mock users
           return viewModel
       }
    
        
}

/*
class MapViewModel: ObservableObject {
    @Published var nearbyUsers: [UserAnnotation] = []
    private var locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()

    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        setupDataFetch()
    }

    private func setupDataFetch() {
        locationManager.$userLocation
            .compactMap { $0 }
            .sink { [weak self] location in
                self?.fetchNearbyUsers(from: location)
            }
            .store(in: &cancellables)
    }

    private func fetchNearbyUsers(from location: CLLocation) {
        // Query Firestore for nearby users based on the current location's geohash
    }
}
*/
