//
//  OrientationInputView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/4/23.
//

import SwiftUI



struct OrientationInputView: View {
    
    @EnvironmentObject var model: OnboardingViewModel
    
    @State var moreOptions: Bool = false
    
    @State var needsHelp: Bool = false 
    
    var body: some View {
        VStack{
            
            Spacer()
            
         
                Text("Who Sparks Your Stars?")
                    .multilineTextAlignment(.center)
                    .bold()
                    .font(.system(size: 50))
                    .lineLimit(3)
                    .minimumScaleFactor(0.7)
                    .padding()
             
            
            Button {
                needsHelp.toggle()
            } label: {
                
                Text("I need help answering this.")
                     .font(.system(size: 20))
                     //.foregroundColor(.white)
                     .padding()
                 
            }
            
           
            ZStack{
                regularGenderOptions()
                    .opacity(moreOptions ? 0 : 1)
                .padding()
                
                moreGenderOptions()
                    .opacity(moreOptions ? 1 : 0)
                    .padding()
                
            }
            
            
            
            
            Button {
                
                withAnimation(.easeIn(duration: 0.5)){
                    moreOptions.toggle()
                }
                
            } label: {
                
                Text("Show me more.")
            }

            
            NextButtonView {
                withAnimation {
                    print("about to generate traits")
                    model.generateTraits { result in
                        
                        
                    }
                    model.currentPage = .traitPredictor
                }
            }
            .disabled(!(model.menSelected || model.womenSelected || model.nonBinarySelected || model.TmenSelected || model.TwomenSelected))
            .opacity(!(model.menSelected || model.womenSelected || model.nonBinarySelected || model.TmenSelected || model.TwomenSelected) ? 0.5 : 1.0)
            
            Spacer()
            Spacer()
            
        }
        .sheet(isPresented: $needsHelp) {
            Text("Explain the Definition of Each Gender (TODO)")
                .font(.largeTitle)
                .bold()
        }
    }
    
    
    func regularGenderOptions() -> some View {
        HStack{
            
            TileView(icon: Image("Onboarding/man"), label: "Men", isSelected: $model.menSelected)
                
            
            TileView(icon: Image("Onboarding/woman"), label: "Women", isSelected: $model.womenSelected)
            
            
                
        }
        
    }
    
    
    func moreGenderOptions() -> some View {
        HStack{
            
            TileView(icon: Image("Onboarding/man"), label: "T-men", isSelected: $model.TmenSelected)
                
            
            TileView(icon: Image("Onboarding/woman"), label: "T-women", isSelected: $model.TwomenSelected)
            
            TileView(icon: Image("Onboarding/nonbinary"), label: "Non-Binary", isSelected: $model.nonBinarySelected)
            
            
                
        }
        
    }
}


struct OrientationInputView_Previews: PreviewProvider {
    static var previews: some View {
        OrientationInputView()
            .environmentObject(OnboardingViewModel())
    }
}
