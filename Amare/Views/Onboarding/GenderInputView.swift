//
//  GenderInputView.swift
//  Amare
//
//  Created by Micheal Bingham on 6/28/23.
//

import SwiftUI

class GenderInputViewModel: ObservableObject{
	@Published var isMan: Bool = false
	@Published var isWoman: Bool = false
	@Published var needsHelp: Bool = false
	@Published var moreOptions: Bool  = false
	
	@Published var isTransmale: Bool = false
	@Published var isTranswoman: Bool = false
}

struct GenderInputView: View {
	
	@EnvironmentObject var model: OnboardingViewModel
	@ObservedObject var gModel: GenderInputViewModel = GenderInputViewModel()
	
    var body: some View {
		VStack{
			
			Spacer()
			
			Text("What's your gender?")
				.bold()
				.font(.system(size: 40))  // was 50
				//.lineLimit(1)
				//.minimumScaleFactor(0.01)
				.padding()
			
	   
			Button {
				gModel.moreOptions.toggle()
			} label: {
				
				Text("I need help answering this.")
					 .font(.system(size: 20))
					 //.foregroundColor(.white)
					 .padding()
				 
			}
		   
			ZStack{
				regularGenderOptions()
					.opacity(gModel.moreOptions ? 0 : 1)
				.padding()
				
				moreGenderOptions()
					.opacity(gModel.moreOptions ? 1 : 0)
					.padding()
				
			}
			
			
			
			
			Button {
				
				withAnimation(.easeIn(duration: 0.5)){
					gModel.moreOptions.toggle()
				}
				
			} label: {
				
				Text("I need more options.")
			}

			
			NextButtonView {
				withAnimation {
					model.currentPage = .intention
				}
			}
			.disabled(!(model.friendshipSelected && model.datingSelected && model.selfDiscoverySelected))
			.opacity(!(model.friendshipSelected || model.datingSelected || model.selfDiscoverySelected) ? 0.5 : 1.0)
			
			Spacer()
			Spacer()
			
		}
    }
	
	
	func regularGenderOptions() -> some View {
		HStack{
			
			TileView(icon: Image("Onboarding/man"), label: "Man", isSelected: $model.gender.mappedToBool(for: .male))
				
			
			TileView(icon: Image("Onboarding/woman"), label: "Woman", isSelected: $model.gender.mappedToBool(for: .female))
			
			
				
		}
		
	}
	
	
	func moreGenderOptions() -> some View {
		HStack{
			
			TileView(icon: Image("Onboarding/man"), label: "T-male", isSelected: $model.gender.mappedToBool(for: .transmale))
				
			
			TileView(icon: Image("Onboarding/woman"), label: "T-female", isSelected: $model.gender.mappedToBool(for: .transfemale))
			
			TileView(icon: Image("Onboarding/woman"), label: "Non-Binary", isSelected: $model.gender.mappedToBool(for: .non_binary))
			
			
				
		}
		
	}
}

struct GenderInputView_Previews: PreviewProvider {
    static var previews: some View {
        GenderInputView()
			.environmentObject(OnboardingViewModel())
    }
}
