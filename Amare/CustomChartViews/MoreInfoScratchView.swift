//
//  MoreInfoScratchView.swift
//  Amare
//
//  Created by Micheal Bingham on 10/2/21.
//

import SwiftUI

/// View to provide more detail on a planet in a sign
struct MoreInfoOnPlacementView: View {
    
    var planet: Planet?
    var houses: [House]?
    
    var body: some View {
        ZStack{
            
            VStack{
                
                var planetName = planet?.name ??  PlanetName.allCases.randomElement()!
                var sign = planet?.sign ??  ZodiacSign.allCases.randomElement()!
                
                
                Text("\(planetName.rawValue) in \(sign.rawValue)")
                .font(.largeTitle)
                 .bold()
                 .frame(maxWidth : .infinity, alignment: .center)
                .padding(.top)
                .foregroundColor(Color.primary.opacity(0.4))
                .minimumScaleFactor(0.01)
                .lineLimit(1)
            
                
                
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
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                    
                    
                    
                    var angle = planet?.angle.dms ?? Double.random(in: 0..<30).dms
                    
                    Text("\(angle)")
                    .font(.largeTitle)
                     .bold()
                   //  .frame(maxWidth : .infinity, alignment: .center)
                    //.padding(.bottom)
                    .foregroundColor(Color.primary.opacity(0.4))
                    .padding()
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                    
                }
        
               
                
                Text("With a Cancer Sun in the seventh house you are becoming sensitive to your partners in life. You discover personal power by allowing yourself to depend on someone else without losing self― sufficiency. ith a Cancer Sun in the seventh house you are becoming sensitive to your partners in life. You discover personal power by allowing yourself to depend on someone else without losing self― sufficiency. Your central purpose is to nurture significant relationships while upholding your end of the responsibilities and duties that come with them. You shine through sensitive leadership and gentle compromise in partnership. Coming into your own requires having significant people in your life with whom you can let down your guard. Attaining self-realization means that you can show you care without losing face. Being you means making the time and space for intimate relationships to develop and grow no matter where you are or what you’re doing.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    
              //  Spacer()
                    
                    
                
                
                
                
                
                
                
              //  Spacer()
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

struct MoreInfoOnPlacementView_Previews: PreviewProvider {
    static var previews: some View {
        MoreInfoOnPlacementView().preferredColorScheme(.dark)
    }
}
