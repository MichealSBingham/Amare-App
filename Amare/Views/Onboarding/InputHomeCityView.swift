//
//  InputHomeCityView.swift
//  Amare
//
//  Created by Micheal Bingham on 6/25/23.
//

import SwiftUI
import MapKit


struct InputHomeCityView: View {
	
	@EnvironmentObject var model: OnboardingViewModel
	
	@State var cityLabel: String = "Enter your place of birth, **not** your current city."
	
	/// If this is true, it will adjust the content of the view so that it's for creating another custom profile instead of onboarding the sign up user. i.e. instead of `Enter your name` it'll say `Enter their name`
	var customAccount: Bool = false
	
    var body: some View {
		VStack{
			
			//Spacer()
		   
			Text(!customAccount ? "Where Did You Spawn on Earth?" : "Where Did They Spawn on Earth?")
				.bold()
				.font(.system(size: 40))  // was 50
				.lineLimit(2)
				.minimumScaleFactor(0.1)
				.padding()
				.padding(.top, 20)
			
	   
			
			Text(.init(cityLabel))
				.font(.system(size: 20))
				.lineLimit(1)
				.minimumScaleFactor(0.01)
				.onAppear{
					if customAccount { self.cityLabel = "Enter their place of birth, **not** their current city."}
				}
				//.foregroundColor(.white)
				.padding()
				.onChange(of: model.homeCity) { city in
					/*
					guard let cityName = city?.city, let tz = model.homeCityTimeZone?.description else {
						if let title = city?.title { cityLabel = "\(title)"}
						
						return
					}
					
				
					cityLabel = "\(cityName) \(tz)"
					*/
					
					if let title = city?.title { cityLabel = "\(title)"}
					
				}
				
			
			
			CitySearchView(/*timezone: $model.homeCityTimeZone*/)
			
			//Spacer()
			
			NextButtonView {
				
				UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

				withAnimation{
					model.currentPage = .birthday
				}
				
					
				
			}
			.disabled(model.homeCity == nil )
			.opacity(model.homeCity == nil  ? 0.5: 1.0)
			
		//Spacer()
		}
    }
}

struct InputHomeCityView_Previews: PreviewProvider {
    static var previews: some View {
       InputHomeCityView()
			.environmentObject(OnboardingViewModel())
    }
}




class SearchCompleter: NSObject, MKLocalSearchCompleterDelegate, ObservableObject {
	@Published var results: [MKLocalSearchCompletion] = []
	var completer: MKLocalSearchCompleter

	let maxResults: Int

	init(completer: MKLocalSearchCompleter, maxResults: Int = 5) {
		self.completer = completer
		self.maxResults = maxResults
		super.init()
		self.completer.delegate = self
		self.completer.resultTypes = .address
		
	}

	func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
		self.results = Array(completer.results.prefix(maxResults))
	}
}




struct CitySearchView: View {
	
	@EnvironmentObject var model: OnboardingViewModel
	
	
	@State private var searchText = ""
	@State private var selectedCity: String?
	@StateObject private var searchCompleter = SearchCompleter(completer: MKLocalSearchCompleter(), maxResults: 5)
	
	@State var showTimeZoneErrorAlert: Bool = false
	
	//@Binding var timezone: TimeZone?
	
	
	enum FirstResponders: Int {
			case city
		}
	@State var firstResponder: FirstResponders? = .city
	
	
	@FocusState private var isFieldFocused: Bool
	
	var body: some View {
		VStack {
			TextField("Search", text: $searchText, onCommit: {
				
				guard model.homeCity != nil else { return }
				
				
				firstResponder = .none
				withAnimation{
					model.currentPage = .birthday
				}
				
				
				
			})
				.firstResponder(id: FirstResponders.city, firstResponder: $firstResponder, resignableUserOperations: .none)
			
				.padding()
				.onChange(of: searchText) { newValue in
					searchCompleter.completer.queryFragment = newValue
				}
				.alert(isPresented: $showTimeZoneErrorAlert) {
								Alert(
									title: Text("Can't Quite Find Your City"),
									message: Text("There was an error finding the timezone. Please try the closest city nearby."),
									dismissButton: .default(Text("OK"))
								) 
							}
			
			ScrollView {
				LazyVStack {
					ForEach(searchCompleter.results, id: \.title) { result in
						HStack {
							Text(result.title)
							
							Spacer()
							
							if selectedCity == result.title {
								Image(systemName: "checkmark")
									.foregroundColor(.green)
							}
						}
						.contentShape(Rectangle())
						.onTapGesture {
							selectedCity = result.title
							setTimezoneFromCity(city: result.title)
						}
						.padding()
						.background(Color(.gray))
						.cornerRadius(8)
						.shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
					}
				}
			}
			.frame(height: 150)
			.padding()
		}.onAppear{
			firstResponder = .city
		}
		
		
	}
	func setTimezoneFromCity(city: String) {
		let searchRequest = MKLocalSearch.Request()
		searchRequest.naturalLanguageQuery = city
		let search = MKLocalSearch(request: searchRequest)
		search.start { response, error in
			guard let response = response else {
				print("Error: \(error?.localizedDescription ?? "Unknown error")")
				return
			}
			
			for item in response.mapItems {
				
				if let timeZone = item.timeZone, let _ = item.placemark.city {
					print("the selected time zone is ... \(timeZone)")
					model.homeCity = item.placemark
					model.homeCityTimeZone = timeZone
				} else{
					// something went wrong selecting the timezone
					selectedCity = nil
					showTimeZoneErrorAlert = true
				}
			}
		}
	}
}
