//
//  MoreInfoScratchView.swift
//  Amare
//
//  Created by Micheal Bingham on 10/2/21.
//

import SwiftUI

struct MoreInfoScratchView: View {
    
    var planet: Planet?
    var houses: [House]?
    
    var body: some View {
        ZStack{
            
            VStack{
                
                var planetName = planet?.name ?? PlanetName.allCases.randomElement()!
                var sign = planet?.sign ?? ZodiacSign.allCases.randomElement()!
                
                
                Text("\(planetName.rawValue) in \(sign.rawValue)")
                .font(.largeTitle)
                 .bold()
                 .frame(maxWidth : .infinity, alignment: .center)
                .padding(.top)
                .foregroundColor(Color.primary.opacity(0.4))
            
                
                
                MainPlacementView( planet: nil, size: 50)
                    .padding()
                
                let el = planet?.element
                
                (el ?? Element.allCases.randomElement()!).image()
                    .padding()
              
               
                
                HStack{
                    
                    
                      var name_of_house = planet?.inWhatHouse(houses: houses ?? [])?.name() ??  HouseNameOrd.allCases.randomElement()!.rawValue//
                    
                    Text("\(name_of_house) House")
                    .font(.largeTitle)
                     .bold()
                    // .frame(maxWidth : .infinity, alignment: .center)
                   // .padding(.bottom)
                    .foregroundColor(Color.primary.opacity(0.4))
                    .padding()
                    
                    
                    
                    
                    Text("28°14'")
                    .font(.largeTitle)
                     .bold()
                   //  .frame(maxWidth : .infinity, alignment: .center)
                    //.padding(.bottom)
                    .foregroundColor(Color.primary.opacity(0.4))
                    .padding()
                    
                }
        
               
                
              //  Spacer()
                    
                    
                
                
                
                
                
                
                
                Spacer()
            }
            
            
        }
        .padding()
        .background(.ultraThinMaterial)
        .foregroundColor(Color.primary.opacity(0.35))
        .foregroundStyle(.ultraThinMaterial)
        .cornerRadius(20)
      //  .padding()
        .onAppear(perform: {
            
                withAnimation {
                    //    showProfilePopup = true
                        
                
              
            }
       
        })
    }
}

struct MoreInfoScratchView_Previews: PreviewProvider {
    static var previews: some View {
        MoreInfoScratchView().preferredColorScheme(.dark)
    }
}
