//
//  SunSignView.swift
//  Amare
//
//  Created by Micheal Bingham on 7/27/23.
//

import SwiftUI

struct SunSignView: View {
	
	var planet: Planet?
	
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
        if let planet = planet {
            HStack{
                
                Group{
                    
                    if colorScheme == .dark {
                        
                        PlanetName.Sun.image()
                        //.resizable()
                            .colorInvert()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        planet.sign.image()
                            .resizable()
                            .colorInvert()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                    else {
                        PlanetName.Sun.image()
                        //.resizable()
                        
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        planet.sign.image()
                            .resizable()
                        
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                    
                }
                Text("\(planet.sign.rawValue)")
                    .bold()
                Text("\(planet.angle.dm)")
                
                //Image("ZodiacIcons/water")
                planet.element.image()
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
            }
        }
        else {
            EmptyView()
        }
	}
}

struct SunSignView_Previews: PreviewProvider {
    static var previews: some View {
		SunSignView(planet:   Planet(name: .Sun, angle: 17.82, element: .water, onCusp: false, retrograde: false, one_line_placement_interpretation: nil, longer_placement_interpretation: nil, sign: .Scorpio, house: 7, cusp: nil, speed: 7, forSynastry: false, _aspectThatExists: nil))
    }
}
