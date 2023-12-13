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
		   
            HStack{
                
                Text(!customAccount ? "Where Did You Spawn on Earth?" : "Where Did They Spawn on Earth?")
                    .multilineTextAlignment(.leading)
                    .bold()
                    .font(.system(size: 40))  // was 50
                    .lineLimit(2)
                    .minimumScaleFactor(0.1)
                    .padding()
                    .padding(.top, 20)
                Spacer()
            }
			
	   
			
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
				
			
			
           // CitySearchView(/*timezone: $model.homeCityTimeZone*/, firstResponder: <#Binding<FirstResponders?>#>)
			
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
            KeyboardPlaceholder()
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




