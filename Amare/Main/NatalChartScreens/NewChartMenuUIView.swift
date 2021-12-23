//
//  NewChartMenuUIView.swift
//  Amare
//
//  Created by Micheal Bingham on 12/22/21.
//

// Note to self:
// "Discover one another"
// "Discover themed matching"
import SwiftUI
import Combine
import TimeZoneLocate

struct NewChartMenuUIView: View {
    
    /// Name of the user profile
    @State var name: String = ""
    /// Search string of location that the user enters
    @State var birthlocation: String = ""
    
    /// Shows the menu to search for locations
    @State var presentLocationSearchMenu: Bool = false
    /// The Birthplace detected that's compatible with our API format
    @State var birthplace: Place?
    
    
    @State var date: Date = Date()
    
    @State var timezone: TimeZone = .current
    
    var location: CLLocation?
    
    var body: some View {
        
        ZStack{
            VStack{
                Text("Discover About Another")
                    //.font(.title)
                     .bold()
                    .foregroundColor(Color.primary.opacity(0.4))
                    .padding()
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                
                
                
                TextField("Name", text: $name) {
                    
                    // After entering name
                }
                .padding()
                
                
                Button {
                    presentLocationSearchMenu = true 
                } label: {
                    
                    TextField("Birth Location", text: $birthlocation)
                }

                 
                
               
                
                
                DatePicker(selection: $date, in :...Date().dateFor(years: -13) , displayedComponents: [.date, .hourAndMinute], label: { Text("Birthday") })
                    .padding()
                    .environment(\.timeZone, timezone)
                    //.datePickerStyle(.graphical)
                
               
               
                Button {
                    print("Date is .. \(date.to(timezone: timezone))")
                } label: {
                    
                    Text("Click Me To Verify Date Timezone")
                }

                
              
            }
            
            
            
            
            
        }
            .background(.ultraThinMaterial)
            .foregroundColor(Color.primary.opacity(0.35))
            .foregroundStyle(.ultraThinMaterial)
            .cornerRadius(20)
            .sheet(isPresented: $presentLocationSearchMenu) {
               PlacePicker(place: $birthplace)
                
            }
            .onReceive(Just(birthplace)) { output in
                birthlocation = birthplace?.city ?? ""
                
                print("The new place iss . \(birthplace)")
                
                // Getting the timezone from the location
                if let lat = birthplace?.latitude, let lon = birthplace?.longitude{
                 
                let geocoder = CLGeocoder()
                let loc = CLLocation(latitude: lat, longitude: lon)
                   
                    geocoder.reverseGeocodeLocation(loc) { placemarks, error in
                        
                        guard let placeMark = placemarks?.first else { return }
                        
                        let tz = placeMark.timeZone
                        print("this timezone is ... \(tz)")
                        timezone = tz!
                    }
                                        
                  
                }
               
            }
    }
}

struct NewChartMenuUIView_Previews: PreviewProvider {
    static var previews: some View {
        NewChartMenuUIView()
            .preferredColorScheme(.dark)
    }
}


import Foundation
import UIKit
import SwiftUI
import GooglePlaces
import MapKit


struct PlacePicker: UIViewControllerRepresentable {

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    @Environment(\.presentationMode) var presentationMode
   // @Binding var address: String
    @Binding var place: Place?

    func makeUIViewController(context: UIViewControllerRepresentableContext<PlacePicker>) -> GMSAutocompleteViewController {

        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = context.coordinator


        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
           UInt(GMSPlaceField.placeID.rawValue)  |
        UInt(GMSPlaceField.coordinate.rawValue))
        autocompleteController.placeFields = fields

        let filter = GMSAutocompleteFilter()
        
        filter.type = .noFilter
        //filter.country = "ZA"
        autocompleteController.autocompleteFilter = filter
        return autocompleteController
    }

    func updateUIViewController(_ uiViewController: GMSAutocompleteViewController, context: UIViewControllerRepresentableContext<PlacePicker>) {
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, GMSAutocompleteViewControllerDelegate {

        var parent: PlacePicker

        init(_ parent: PlacePicker) {
            self.parent = parent
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            DispatchQueue.main.async {
                print(place.description.description as Any)
              //  self.parent.address =  place.name!
            
                self.parent.place = Place(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, city: place.name)
                
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            print("Error: ", error.localizedDescription)
        }

        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}
