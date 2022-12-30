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
	
	@State private var locations: [CLLocation] = []
	
	
	@State private var discoverIsOn: Bool = false
    
    
    /// TODO: clean up 'test view model' change
    //@EnvironmentObject var NIusersDataModel = TestViewModel()
	
	var body: some View {
		
	
	
		
				
				
				ZStack{
					
					NearbyUsersMapView(locations: $locations)
						.ignoresSafeArea()
						.brightness(discoverIsOn ? 0: -0.5)
					
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
                                            .foregroundColor(.amare)
                                          
                                            //.colorScheme(.dark)
                                           // .offset(x: 20)
                                            .frame(width: 25.0, height: 25.0)
                                            .background(Circle()
                                                .fill(Color.white)
                                                .opacity(0.50)
                                                .frame(width: 40, height: 40))
                                            .padding()
                                        
                                        
                                    }
                                    .foregroundColor(.white)

                                    
                                    Toggle("", isOn: $discoverIsOn)
                                        .padding()
                                        .colorScheme(.dark)
                                        .background(Circle()
                                            .fill(Color.white)
                                            .opacity(0.50)
                                            .frame(width: 50, height: 50))
                                        .frame(width: 200)
                                        .toggleStyle(MapToggleStyle())
                                    
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
                .sheet(isPresented: .constant(true)) {
                    if #available(iOS 16.1, *) {
                        /*
                         NavigationView {
                            Text("People Nearby")
                                .navigationTitle(Text("Discover")
                                    .padding(.vertical, -10))
                        }*/
                        VStack{
                            
                            HStack{
                                
                                Text("People")
                                    .font(.largeTitle)
                                   // .fontDesign(.rounded)
                                    .padding()
                                Spacer()
                            }
                        
                            Spacer()
                        }
                        
                        
                            .presentationDetents([.fraction(CGFloat(0.10)), .medium])
                        
                    } else {
                        // Fallback on earlier versions
                    }
                        
                }
                .onAppear{
                    
                    guard let windows = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    
                    if let controller = windows.windows.first?.rootViewController?.presentedViewController, let sheet = controller.presentationController as? UISheetPresentationController{
                        
                    } else {
                        print("CONTROLLER NOT FOUND")
                    }
                    
                                        
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
    }


struct DiscoverNearbyView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverNearbyView()
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
