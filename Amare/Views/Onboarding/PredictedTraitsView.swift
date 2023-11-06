//
//  PredictedTraitsView.swift
//  Amare
//
//  Created by Micheal Bingham on 9/17/23.
//

import SwiftUI

struct PredictedTraitsView: View {
	
	@EnvironmentObject var model: OnboardingViewModel
    
    @State var traits: [String] = ["ambitious", "sincere", "emotional", "mean", "determined"]
    
   
    
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
                
            }
            .padding()
            .onChange(of: model.traitFeedback) { num in
                print("num \(num.count) , feedback: \(model.predictedTraits.count)")
                if num.count == model.predictedTraits.count && num.count != 0 {
                    withAnimation { didFinishTraitSelection.toggle() }
                }
                
                
                print(model.predictedTraits)
                print("\n")
                print(model.traitFeedback)
                print("\n\n\n\n")
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
    }
}
