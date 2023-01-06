//
//  DiscoverNearbyView.swift
//  Amare
//
//  Created by Micheal Bingham on 8/20/22.
//

import SwiftUI
import MapKit
import SPIndicator
import MultipeerKit
import NearbyInteraction

struct DiscoverNearbyView: View {
	
	@State private var region = MKCoordinateRegion(
					center: CLLocationCoordinate2D(
						latitude: 40.83834587046632,
						longitude: 14.254053016537693),
					span: MKCoordinateSpan(
						latitudeDelta: 0.03,
						longitudeDelta: 0.03)
					)
	
	@State private var locations: [CLLocation] = []
	
	
	@State private var discoverIsOn: Bool = false
    
    @State private var showFindNearbyUserView: Bool = false
    
    @State var otherUser: AmareUser = AmareUser.random()
    
    /// For detecting nearby users
    @EnvironmentObject var multipeerDataSource: MultipeerDataSource
    
    /// View model for the current signed in user's realtime data.
    @EnvironmentObject var mainViewModel: UserDataModel
    
    @EnvironmentObject var account: Account
    
    
    
    // For show with custom image:
    let image = UIImage.init(systemName: "sun.min.fill")!.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
    
    var locationPrivacyIndicator = SPIndicatorView(title: "Only Approximate Location Shared", preset: .custom(UIImage.init(systemName: "eye.fill")!.withTintColor(.amare, renderingMode: .alwaysOriginal)) )
    
    /// TODO: clean up 'test view model' change
    //@EnvironmentObject var NIusersDataModel = TestViewModel()
	
	var body: some View {
		
	
	
		
				
				
				ZStack{
					
					NearbyUsersMapView(locations: $locations)
						.ignoresSafeArea()
						.brightness(discoverIsOn ? 0: -0.5)
                        .onAppear{
                            
                            //locationPrivacyIndicator.dismissByDrag  = false
                            //locationPrivacyIndicator.present(duration: .greatestFiniteMagnitude)
                            
                            
                        }
                        .onDisappear{
                           // locationPrivacyIndicator.dismiss()
                        }
                    /*
                        .SPIndicator(
                            isPresent: .constant(true),
                            title: "Exact Locations",
                            message: "Never Shared",
                            duration:  2.0,
                            presentSide: .top,
                            dismissByDrag: true,
                            preset: .custom(UIImage.init(systemName: "eye.fill")!.withTintColor(.amare, renderingMode: .alwaysOriginal)),
                            haptic: .success,
                            layout: .init(),
                            completion: {
                                print("Indicator is destoryed")
                            })
                    */
                       
					
					VStack{
						
						ZStack{
							
    
							
							
							HStack{
								
							
							
								Spacer()
								
                                VStack{
                                    
                                    Menu {
                                        
                                        if discoverIsOn{
                                            
                                            Button {
                                                print("Allow anyone to discover me")
                                            } label: {
                                                Text("Allow anyone to discover me")
                                            }
                                            
                                            Button {
                                                print("Allow anyone to discover me")
                                            } label: {
                                                Text("Allow only those matching my dating profile to discover me")
                                            }
                                            
                                            Button {
                                                print("Allow anyone to discover me")
                                            } label: {
                                                Text("Show me to people I've crossed paths with")
                                            }
                                            
                                        } else {
                                            
                                            
                                            
                                            Button {
                                                print("Allow anyone to discover me")
                                            } label: {
                                                Text("Show me to people I've crossed paths with")
                                            }
                                            
                                            Button {
                                                print("Allow anyone to discover me")
                                            } label: {
                                                Text("Don't show me to people I've crossed paths with")
                                            }
                                            
                                            
                                        }
                                        

                                    } label: {
                                        Image(systemName: "gear")
                                            .resizable()
                                            .foregroundColor(.white)
                                          
                                            .colorScheme(.dark)
                                            .offset(x: 50)
                                            .frame(width: 25.0, height: 25.0)
                                            .background(Circle()
                                                .fill(Color.ourGray)
                                                .offset(x: 50)
                                                .opacity(0.50)
                                                .frame(width: 40, height: 40))
                                            .padding()
                                        
                                        
                                    }
                                    .foregroundColor(.white)

                                    
                                    Toggle("", isOn: $discoverIsOn)
                                        .tint(.amare)
                                        .padding()
                                        //.colorScheme(.dark)
                                        //.background(Circle()
                                          //  .fill(Color.white)
                                            //.opacity(0.50)
                                            //.frame(width: 50, height: 50))
                                        .frame(width: 200)
                                       // .toggleStyle(MapToggleStyle())
                                    
                                }
								
									
							}
                            //.offset(y: -30.0)
							
							
						}
                        
						
						
						Spacer()
					}
					
					
                    
				}
				.onTapGesture {
					print("Generating New Location")
					self.randomLocation()
					
					print("The locations... \(locations)")
				}
                .onAppear{
                    checkForNISupport()
                }
                .onChange(of: mainViewModel.userData, perform: { newData in
                    
                   
                    broadcastToNearByUsers()
                })
                
                
                
                // Optimize later .. would much rather not broadcast every time this changes but no other solutions at the current moment.
                .onChange(of: multipeerDataSource.availablePeers) { peers in
                    
        
                    broadcastToNearByUsers()
                  
                
                }
                
                .sheet(isPresented: $discoverIsOn) {
                if true /*#available(iOS 16.1, *)*/ {
                    ZStack{
                        VStack{
                            
                            HStack{
                                
                                Text("People")
                                    .font(.largeTitle)
                                // .fontDesign(.rounded)
                                    .padding()
                                Spacer()
                            }
                            
                            List{
                                
                                Section(header: Text("Next To You")){
                                    
                                    ForEach(account.nearbyUsersByMultipeer.sorted(by: {$0.name! < $1.name!
                                        
                                    }), id: \.self){ person in
                                        
                                        Button {
                                            
                                            withAnimation{
                                                
                                                self.otherUser = person
                                                showFindNearbyUserView.toggle()
                                            }
                                            
                                        } label: {
                                            rowForNearbyPerson(person: person)
                                        }
                                        
                                        
                                        
                                    }
                                    
                                }
                                
                                Section(header: Text("Near You")){
                                    
                                }
                            }
                            
                            Spacer()
                        }
                       /*
                        FindNearbyUserView(user: $otherUser, blindMode: false)
                            .opacity(showFindNearbyUserView ? 1 : 0)
                        */
                        
                    }
                    
                   // .presentationDetents([.fraction(CGFloat(0.10)), .medium, .large])
                    
                } else {
                    // Fallback on earlier versions
                }
                    
            }
            
				
				
			
		}
		
    
    @ViewBuilder
    func rowForNearbyPerson(person: AmareUser) -> some View {
        
        HStack{
            
            ProfileImageView(profile_image_url: .constant(person.profile_image_url), size: CGFloat(80))
                .padding(-10)
           
            
            Text(person.name)
                //.fontWeight(.heavy)
                //.font(Font.title2)
                .padding()
            
            Spacer()
               
            
            
            
        }
    }
		
	func randomLocation()  {
		var currentLat = 40.7484
		var currentLon = -73.9857
		
		let randomLatShift = Double.random(in: 0..<0.00095)*(Bool.random() == true ? -1: 1)
		let randomLonShift = Double.random(in: 0..<0.00095)*(Bool.random() == true ? -1: 1)
		
		let lat = currentLat + randomLatShift
		let lon = currentLon + randomLonShift
		
		let loc = CLLocation(latitude: lat, longitude: lon)
	
		self.locations.append(loc)
		
		
		
	}
    
    /// Will broadcast our user data to nearby users by multipeer. We do this so that other nearby users know that we are around
    func broadcastToNearByUsers()  {
        
        print("broadcasting to nearby users")
        guard mainViewModel.userData.isComplete() else { print("!No need to broadcast to all ... incomplete data"); return }
    
   

        guard let deviceID = UIDevice.current.identifierForVendor?.uuidString else { return }
                
        var data = UserDataToSend(userData: mainViewModel.userData, id: mainViewModel.userData.id!, chart: mainViewModel.userData.natal_chart, deviceID: deviceID, profileImage: nil)
        
        
        
        multipeerDataSource.transceiver.broadcast(data)
    }
    
    /// Broadcasts the signed in person's user data to a specific peer
    func broadcast(to: Peer)   {
        
        
        guard mainViewModel.userData.isComplete() else { print("!No need to broadcast // my data is incomplete"); return }
        
        print("!!! Broadcasting this data .. \(mainViewModel.userData)")
        multipeerDataSource.transceiver.send(mainViewModel.userData, to: [to])
    }
    
    
    func checkForNISupport(){
        // See if device is compatible with nearby interaction
        
        var user = AmareUser()
        
       
        
        if let supportsNI = mainViewModel.userData.supportsNearbyInteraction {
            // Check if it matches
            print("determining if NI is supported")
            if supportsNI != NISession.isSupported {
                // set in database whether or not this is supported
                print("Different value in database : this device: \(NISession.isSupported) ")
                user.supportsNearbyInteraction = supportsNI
            
                account.data = user
                
            
                
                do {
                    print("Attempting to save this data: \(user) ")
                    try account.save()
                    
                } catch (let error) {
                    
                    print("xxxSaving user info with error \(error)")
                }
                
            }
        } else {
            
            print("Cannot determine if it supports nearby interaction")
            var supportsNI = NISession.isSupported
            // set in database
        
            print("Supports NI: \(NISession.isSupported)")
            user.supportsNearbyInteraction = supportsNI
            account.data = user
            do {
                print("Attempting to save this data: \(user) ")
                try account.save()
                
            } catch (let error) {
                
                print("xxxSaving user info with error \(error)")
            }
        }
        
        
        multipeerDataSource.transceiver.peerRemoved = { peer in
             
            
            
            for user in account.nearbyUsersByMultipeer{
                
                print("!Looping through nearbyusers on \(user.deviceID)")
               
                if user.deviceID == peer.name{
                    print("!removing .. \(peer.name)")
                    account.nearbyUsersByMultipeer.remove(user)
                    
                 
                    
                }
            }
            
        
        }
         
        
        
        multipeerDataSource.transceiver.receive(UserDataToSend.self) { payload, sender in
            
            //payload.userData.id = payload.id
            var data =   payload.userData
            data.id = payload.id
            data.natal_chart = payload.chart
            data.deviceID = payload.deviceID
            data.image = payload.profileImage
            data.isNearby = true
            
     
        
            account.nearbyUsersByMultipeer.insert(data)
            
            
        
          
            
        }
        
        
        
     broadcastToNearByUsers()
    }
    
    }



struct DiscoverNearbyView_Previews: PreviewProvider {
    
    static var account = Account()
    static var previews: some View {
        DiscoverNearbyView()
            .environmentObject(account)
            .onAppear{
                //account.nearbyUsersByMultipeer.append(<#T##Combine.Publishers.Sequence<Elements, Failure>...#>)
                
                for i in 0...10{
                    account.nearbyUsersByMultipeer.insert(AmareUser.random())
                }
            }
            
            
    }
}



struct NearbyUsersMapView: UIViewRepresentable {

	
	/*
	/// Pass a state variable here and when it changes, the map will fly to this location
	@Binding var locationToGoTo: CLPlacemark?
	
	 */
	/// This will keep track of annotations to place on the map, without animations.
	@Binding var locations: [CLLocation]
	
	
	
	func makeUIView(context: Context) -> MKMapView {
		let mapView = MKMapView(frame: .zero)
		
	
		
		// change the map type here
//		mapView.mapType = .standard
//        mapView.tintColor = UIColor(red: 1.00, green: 0.01, blue: 0.40, alpha: 1.00)
		mapView.showsUserLocation = true
		
		let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.7484, longitude: -73.9857), latitudinalMeters: 200, longitudinalMeters: 200)
			
		mapView.region = region
		//mapView.isZoomEnabled = false
		mapView.isPitchEnabled = true
		mapView.camera.pitch = 20.0
		//MKMapCamer
		//mapView.setCamera(<#T##camera: MKMapCamera##MKMapCamera#>, animated: true)
	
		
		mapView.delegate = context.coordinator
		
		mapView.register(UserAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(UserAnnotation.self))
		
		if #available(iOS 16.0, *) {
			mapView.preferredConfiguration = MKStandardMapConfiguration(elevationStyle: .realistic)
		} else {
			// Fallback on earlier versions
			
			print("FALLING BACK THE MAP")
		}
		
		
	
		return mapView
	}
	
	
	func updateUIView(_ view: MKMapView, context: Context) {
		
		print("Updating UIVIEW ")
		for location in locations {
		
			
			print("Making a pin..")
			let loc = location.coordinate
				
				// make a pins
				//let pin = MKPointAnnotation()
			
				let pin = UserAnnotation()
			
			
				
				// set the coordinates
				pin.coordinate =  loc
				
				// set the title
				//pin.title = location.name
			
				pin.user = AmareUser.random()
			
			
				//view.showsUserLocation = false
				// add to map
				view.addAnnotation(pin)
			
	   
			
		}
		
		
	}
	 
	func makeCoordinator() -> Coordinator {
			Coordinator(self)
		}

		class Coordinator: NSObject, MKMapViewDelegate {
			var parent: NearbyUsersMapView

			init(_ parent: NearbyUsersMapView) {
				self.parent = parent
			}
			
		  
			
			/// The map view asks `mapView(_:viewFor:)` for an appropiate annotation view for a specific annotation.
			/// - Tag: CreateAnnotationViews
			func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
				
				
				guard annotation.isKind(of: UserAnnotation.self) else {
					// Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
					print("***Not a type of user annotation..")
					return nil
				}
				
				
				print("***inside mapView(_:) creating annotation ")
				var annotationView: MKAnnotationView?
				
				if let annotation = annotation as? UserAnnotation {
					annotationView = setupUserAnnotation(for: annotation, on: mapView)
				}
				
				return annotationView
					
			}
			
			
			/// The map view asks `mapView(_:viewFor:)` for an appropiate annotation view for a specific annotation. The annotation
			/// should be configured as needed before returning it to the system for display.
			/// - Tag: ConfigureAnnotationViews
			private func setupUserAnnotation(for annotation: UserAnnotation, on mapView: MKMapView) -> MKAnnotationView {
				let reuseIdentifier = NSStringFromClass(UserAnnotation.self)
				let flagAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)
				
				flagAnnotationView.canShowCallout = false
				
				// Provide the annotation view's image.
				//let image = #imageLiteral(resourceName: "flag")
			   // flagAnnotationView.image = image
				
				
				let image = ImageFromUrl(annotation.user?.profile_image_url ?? "").image().resizeImage(50.0, opaque: false)
				flagAnnotationView.image = image
				flagAnnotationView.isDraggable = true
				
				// Provide the left image icon for the annotation.
				flagAnnotationView.leftCalloutAccessoryView = UIImageView(image: image)
				
				//UIImageView(image: #imageLiteral(resourceName: "sf_icon"))
				
				// Offset the flag annotation so that the flag pole rests on the map coordinate.
			   // let offset = CGPoint(x: image.size.width / 2, y: -(image.size.height / 2) )
				//flagAnnotationView.centerOffset = offset
				
			  //  flagAnnotationView.tintColor = .green
				
				return flagAnnotationView
					
			}
			
			
		}
}
