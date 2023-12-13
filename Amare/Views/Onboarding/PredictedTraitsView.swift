//
//  PredictedTraitsView.swift
//  Amare
//
//  Created by Micheal Bingham on 9/17/23.
//

import SwiftUI

struct PredictedTraitsView: View {
	
	@EnvironmentObject var model: OnboardingViewModel
    
    @State var traits: [String] = []
    
   
    
    @State var didFinishTraitSelection: Bool = false
	
    var body: some View {
        VStack{
            Spacer()
            
            Text("Embrace Your Cosmic Self")
                .multilineTextAlignment(.center)
                .bold()
                .font(.system(size: 50))
                .padding()
            
            
            
            TraitsFeedbackView()
                .frame(height: 360)
        
            
            

            
            
            NextButtonView(text: !didFinishTraitSelection ? "Do this later" : "Next"){
                withAnimation {
                    model.currentPage = .personality
                }
            }
            .padding()
            .onChange(of: model.traitFeedback) { num in
               
                if num.count == model.predictedTraits.count && num.count != 0 {
                    withAnimation { didFinishTraitSelection.toggle() }
                }
                
                
            }
            
            
            Spacer()
            Spacer()
           
            
           // KeyboardPlaceholder()
        }
    }
}

struct PredictedTraitsView_Previews: PreviewProvider {
    static var previews: some View {
        PredictedTraitsView()
            .environmentObject(OnboardingViewModel())
    }
}
