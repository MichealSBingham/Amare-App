import SwiftUI
import MapKit



struct ContentView: View {
    // add locations here
    @State var locationsForAnnotation: [LocationForMapView]  = []
    
    @State var selectedLocation: LocationForMapView? = nil
    
    
    
    var body: some View {
        GlobeView(locationToGoTo: $selectedLocation, locations: $locationsForAnnotation)
            .onTapGesture {
                
            selectedLocation =
                LocationForMapView(title: "New York", latitude: 40.7128, longitude: -74.0060)
                
                
                
            }
            .ignoresSafeArea()
        
    }
}

struct LocationForMapView {
    var title: String
    var latitude: Double
    var longitude: Double
}


struct GlobeView: UIViewRepresentable {
    
    /// Pass a state variable here and when it changes, the map will fly to this location
    @Binding var locationToGoTo: LocationForMapView?
    
    /// This will keep track of annotations to place on the map, without animations.
    @Binding var locations: [LocationForMapView]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        // change the map type here
        mapView.mapType = .hybridFlyover
    
        return mapView
    }
    
    
    func updateUIView(_ view: MKMapView, context: Context) {
        
        for location in locations {
       
            // make a pins
            let pin = MKPointAnnotation()
            
            // set the coordinates
            pin.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            // set the title
            pin.title = location.title
        
            
            // add to map
            view.addAnnotation(pin)
        }
        
        if let goToLoc =  locationToGoTo{
            
            // Animate to the location
            
            let loc = CLLocationCoordinate2D(latitude: goToLoc.latitude, longitude: goToLoc.longitude)
            
            
            var region = MKCoordinateRegion(center: loc, latitudinalMeters: 16093.4, longitudinalMeters: 16093.4)
            
            view.animatedZoom(to: region, for: 3)
            
            // make a pins
            let pin = MKPointAnnotation()
            
            // set the coordinates
            pin.coordinate = loc
            
            // set the title
            pin.title = "City"
        
            
            // add to map
            view.addAnnotation(pin)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView()
           

       
    }
}
