//
//  MapView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/22/23.
//

import SwiftUI
import MapKit




struct MapView: View {
    @EnvironmentObject var userDataModel: UserProfileModel
    @StateObject var locationManager: LocationManager = LocationManager()
    @EnvironmentObject  var viewModel: MapViewModel

    
    var body: some View {
        
        ZStack{
            
            
            Map(coordinateRegion: $viewModel.region, interactionModes: .all, showsUserLocation: true)
                .ignoresSafeArea()
                .onChange(of: locationManager.currentGeoHash6) {  geohash in
                   
                    viewModel.listenForNearbyUsers(geohash: geohash)
                    
                    AmareApp().delay(2) {
                        
                        guard let user = userDataModel.user else {
                            print("can't listen for dices")
                            return }
                        
                        print("should start listening for a nearby dice")
                        viewModel.listenForNearbyDices(geohash: geohash, mySex: user.sex, forDating: user.isForDating ?? false, forFriendship: user.isForFriends ?? false, myOrientation: user.orientation)
                    }
                   
                    
                }
            
            Color.black.opacity(userDataModel.user?.locationSettings == .off ? 0.5: 0).ignoresSafeArea()
                
                
            
            VStack{
                LocationPrivacyCapsule()
                    .environmentObject(userDataModel)
                    .padding()
                
                Spacer()
                
                HStack{
                    Spacer()
                    DiceButtonView(status: userDataModel.user?.isDiceActive ?? false, onTap: {
                        
                        addOrRemoveDice()
                        
                    })
                        
                        .padding()
                }
                
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
            
            // Just for Debugging, we're going to add this elsewhere
          /*  HStack{
                ScrollView(.horizontal) {
                    
                }
            }
            */

        }
    }
    
    func addOrRemoveDice(){
        guard userDataModel.user?.isDiceActive == false else {
            FirestoreService.shared.deleteDice { error in
                
            }
            return 
        }
        
        locationManager.addDiceToMap(user: userDataModel.user) { error in
            print("the error adding dice to map is \(error)")
        }

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


struct MapViewPreview: View {
    
    @StateObject var viewModel = MapViewModel()
    @State var users: [AppUser] = []
    @State var showUserSheet: Bool = false
    var body: some View {
        MapView()
            .environmentObject(viewModel)
            .tabSheet(showSheet: .constant(true), initialHeight: 250, sheetCornerRadius: 15) {
                NavigationStack{
                    ScrollView{
                        VStack{
                            
                            HStack{
                                Text("\(users.count) \(users.count == 1 ? "Person" : "People") Near You")
                                    .font(.title3.bold())
                                     
                                    // .foregroundColor(.amare)
                                    Spacer()

                            }
                            //MARK: - Show nearby users
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack{
                                    
                                    ForEach(users) { user in
                                        
                                      
                                        Button {
                                            withAnimation{
                                                showUserSheet = true
                                            }
                                        } label: {
                                            
                                            CircularProfileImageView(profileImageUrl: user.profileImageUrl, isNotable: false , showShadow: false)
                                                    .frame(width: 80)
                                                    .padding()
                                                
                                        }
                                        .buttonStyle(.plain)

                                        
                                            
                                                
                                    
                                    }
                                    
                                }
                                .frame(minHeight: 90)
                                
                            }.scrollContentBackground(.hidden).background(Color.clear)
                               
                        }
                    } 
                    .padding()
                    .padding(.vertical, 10)
                    .scrollIndicators(.hidden)
                    .scrollContentBackground(.hidden)
                    
                }.background {
                    if #unavailable(iOS 16.4) {
                        ClearBackground()
                    }
                }
            }
            
            .onAppear{
                viewModel.nearbyUsers = AppUser.generateMockData(of: 28)
                users = AppUser.generateMockData(of: 28)
            }
        
    }
}


#Preview {
    MapView()
        .environmentObject(MapViewModel())
        .environmentObject(UserProfileModel())
    
    /*
        .tabSheet(showSheet: .constant(true) , initialHeight: 200, sheetCornerRadius: 15) {
                 NavigationStack {
                     ScrollView {
                         /// Showing Some Sample Mock Devices
                         VStack{
                           
                             //  adding user profiles in a scrollable list
                             ScrollView(.horizontal, showsIndicators: false) {
                                 HStack(spacing: 20) {
                                     ForEach(.constant(AppUser.generateMockData(of: 10))) { user in
                                         VStack {
                                          //   CircularProfileImageView(profileImageUrl: user.profileImageUrl)
                                                 //.resizable()
                                                // .frame(width: 60, height: 60)
                                                
                                             Text(user.name)
                                             //Text(user.astroSign)
                                         }
                                     }
                                 }
                             }
                             .padding()

                             }
                         }
                         //.padding(.horizontal, 15)
                         .navigationTitle(Text("Nearby Users"))
                         .padding(.vertical, 10)
                     }
                     .scrollIndicators(.hidden)
                     .scrollContentBackground(.hidden)
                    
                     .background {
                         if #unavailable(iOS 16.4) {
                             ClearBackground()
                         }
                     }
            }
        .environmentObject(UserProfileModel())
    */
}
