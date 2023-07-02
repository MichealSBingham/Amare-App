//
//  IntentionInputView.swift
//  Amare
//
//  Created by Micheal Bingham on 6/27/23.
//

import SwiftUI


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
				
				TileView(icon: Image("Onboarding/dating"), label: "Dating", isSelected: $model.datingSelected)
				
				TileView(icon: Image("Onboarding/friendship"), label: "Friendship", isSelected: $model.friendshipSelected)
				
				TileView(icon: Image("Onboarding/self_discovery"), label: "Discovery", isSelected: $model.selfDiscoverySelected)
					
			}
			.padding()
			
			NextButtonView {
				withAnimation {
					model.currentPage = .username
				}
			}
			.disabled(!(model.friendshipSelected || model.datingSelected || model.selfDiscoverySelected))
			.opacity(!(model.friendshipSelected || model.datingSelected || model.selfDiscoverySelected) ? 0.5 : 1.0)
			
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
