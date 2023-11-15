//
//  PredictedPersonalityStatementsView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/8/23.
//

import SwiftUI



struct PredictedPersonalityStatementsView: View {
    
    @EnvironmentObject var model: OnboardingViewModel
    
    
    
   
    
    @State var didFinish: Bool = false
    
    var body: some View {
        VStack{
            Spacer()
            
            Text("Discover Your Stellar Narrative")
                .multilineTextAlignment(.center)
                .bold()
                .font(.system(size: 50))
                .padding()
            
            
            
            PersonalityGuesserView()
                .frame(height: 360)
                .onAppear{
                    model.generatePersonality()
                }
        
            
            

            
            
            NextButtonView(text: !didFinish ? "Do this later" : "Next"){
                withAnimation{
                    model.currentPage = .mediaUpload
                }
            }
            .padding()
            .onChange(of: model.personalityStatementsFeedback) { num in
               
                if num.count == model.personalityStatementsFeedback.count && num.count != 0 {
                    withAnimation { didFinish.toggle() }
                }
                
                
            }
            
            
            Spacer()
            Spacer()
           
            
           // KeyboardPlaceholder()
        }
    }
}

struct PredictedPersonalityStatementsView_Previews: PreviewProvider {
    static var previews: some View {
        PredictedPersonalityStatementsView()
            .environmentObject(OnboardingViewModel())
    }
}
