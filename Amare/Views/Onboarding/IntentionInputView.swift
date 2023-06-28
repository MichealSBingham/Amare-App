//
//  IntentionInputView.swift
//  Amare
//
//  Created by Micheal Bingham on 6/27/23.
//

import SwiftUI

class IntentionInputViewModel: ObservableObject{
	@Published var friendshipSelected: Bool = false
	@Published var datingSelected: Bool = false
	@Published var selfDiscoverySelected: Bool = false 
}

struct IntentionInputView: View {
	
	@EnvironmentObject var model: OnboardingViewModel
	
    var body: some View {
        
		VStack{
			
			Spacer()
			
			Text("So \(model.name?.firstName ?? "Micheal"), why are you here? ")
				.bold()
				.font(.system(size: 40))  // was 50
				//.lineLimit(1)
				//.minimumScaleFactor(0.01)
				.padding()
			
	   
			
		   Text("You can select more than one.")
				.font(.system(size: 20))
				//.foregroundColor(.white)
				.padding()
			
			HStack{
				
				
					
			}
			.padding()
			
			NextButtonView {
				
			}
			
			Spacer()
			Spacer()
			
		}
    }
}

struct IntentionInputView_Previews: PreviewProvider {
    static var previews: some View {
        IntentionInputView()
			.environmentObject(OnboardingViewModel())
    }
}
