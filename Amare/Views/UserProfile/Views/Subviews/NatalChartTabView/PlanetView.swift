//
//  PlanetView.swift
//  Amare
//
//  Created by Micheal Bingham on 7/27/23.
//

import SwiftUI

struct PlanetView: View {
	
	@Environment(\.colorScheme) var colorScheme
	
	var planet: Planet = Planet(name: .Mercury, angle: 17.82, element: .fire, onCusp: false, retrograde: false, one_line_placement_interpretation: nil, longer_placement_interpretation: nil, sign: .Leo, house: 7, cusp: nil, speed: 7, forSynastry: false, _aspectThatExists: nil)
	
	var body: some View {
		
		
		VStack{
			
			HStack{
				
				if colorScheme == .light{
					
					planet.name.image()
						//.resizable()
						.scaledToFit()
						.frame(width: 25, height: 25)
					planet.sign.image()
						.resizable()
						.scaledToFit()
						.frame(width: 25, height: 25)
				}
				else {
					
					planet.name.image()
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
				
		
			}
			
			Text("**\(planet.sign.rawValue)** \(planet.name.rawValue)")
		
		}
		
		
	}
}

struct PlanetView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetView()
    }
}
