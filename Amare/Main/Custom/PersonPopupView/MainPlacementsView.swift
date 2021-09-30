//
//  PersonPopupVIew.swift
//  Amare
//
//  Created by Micheal Bingham on 9/29/21.
//

import SwiftUI

/// To be used on the person popup, shows the 3 main placements and colors them
struct MainPlacementView: View {
    
    var sign: ZodiacSign? = ZodiacSign.allCases.randomElement()!
    
    var planet: PlanetName? = PlanetName.allCases.randomElement()!
    
    var color: Color? = randomColor()
    
    var size: CGFloat = 10
    
    var body: some View {
        
        HStack{
            
            planet?.image()
                .colorInvert()
                .colorMultiply(color!)
                .frame(width: size, height: size)
                
            
            sign?.image()
                .resizable()
                .aspectRatio(contentMode: .fit)
                    .colorInvert()
                    .colorMultiply(color!)
                    .frame(width: size, height: size)
                    
            
            
            
        }
        
        
    }
}

struct MainPlacementView_Previews: PreviewProvider {
    static var previews: some View {
        MainPlacementView()
            .preferredColorScheme(.dark)
            //.frame(width: 25, height: 25)
    }
}

func randomColor() -> Color {
    
    var colors: [Color] = [.white, .red, .orange, .blue, .green, .yellow]
    
    return colors.randomElement()!
}
