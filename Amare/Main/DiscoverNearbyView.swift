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
	
	var body: some View {
		
	
	
		
				
				
				ZStack{
					
					NearbyUsersMapView(locations: $locations)
						.ignoresSafeArea()
						.brightness(discoverIsOn ? 0: -0.5)
					
					VStack{
						
						ZStack{
							
							//Mark: Title Bar
							Rectangle()
								.frame(width: .infinity, height: 110.0)
								.background(.ultraThinMaterial)
								.foregroundColor(discoverIsOn ? .green : .pink)
								.foregroundStyle(.ultraThinMaterial)
								.colorScheme(.dark)
								.opacity(0.5)
							//.cornerRadius(20)
								.ignoresSafeArea()
							
							
							HStack{
								
								if #available(iOS 16.0, *) {
									Text("Discover")
									//.foregroundStyle(.ultraThinMaterial)
										.foregroundColor(.white)
										.font(.largeTitle)
										.fontWeight(.bold)
										.minimumScaleFactor(0.01)
										.lineLimit(1)
										.padding()
								} else {
									// Fallback on earlier versions
									Text("Discover")
									//.foregroundStyle(.ultraThinMaterial)
										.foregroundColor(.white)
										.font(.largeTitle)
										//.fontWeight(.bold)
										.minimumScaleFactor(0.01)
										.lineLimit(1)
										.padding()
								}
								
							
								Spacer()
								
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
										.colorScheme(.dark)
										.offset(x: 20)
										.frame(width: 25.0, height: 25.0)
										.padding()
									
								}
								.foregroundColor(.white)

								
								Toggle("", isOn: $discoverIsOn)
									.padding()
									.colorScheme(.dark)
									.frame(width: 80.0)
									
							}
							.offset(y: -30.0)
							
							
						}
						
						
						
						Spacer()
					}
					
					
				}
				.onTapGesture {
					print("Generating New Location")
					self.randomLocation()
					
					print("The locations... \(locations)")
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
				let pin = MKPointAnnotation()
			
				
				// set the coordinates
				pin.coordinate =  loc
				
				// set the title
				//pin.title = location.name
			
			
			
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
				
				print("***inside mapView(_:)")
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
				let image = UIImage(systemName: "lasso")!
				flagAnnotationView.image = image
	   
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
