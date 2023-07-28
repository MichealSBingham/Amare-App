//
//  NatalChartTabView.swift
//  Amare
//
//  Created by Micheal Bingham on 7/27/23.
//

import SwiftUI

struct NatalChartTabView: View {
	
	var natalChart: NatalChart?
	
	private var randomPlanet = Planet(name: .Sun, angle: 17.82, element: .water, onCusp: false, retrograde: false, one_line_placement_interpretation: nil, longer_placement_interpretation: nil, sign: .Cancer, house: 7, cusp: nil, speed: 7, forSynastry: false, _aspectThatExists: nil)
	
	var body: some View {
		
		TabView{
			
			HStack{
				
				var sun = natalChart?.planets.get(planet: .Sun) ?? randomPlanet
				SunSignView(planet: sun)
					.padding(.horizontal)
					.padding(.top, -10)
				Spacer()
			}
			
			
			HStack{
				var sun = natalChart?.planets.get(planet: .Sun) ?? randomPlanet
				PlanetView(planet: sun )
					.padding()
				
				var moon = natalChart?.planets.get(planet: .Moon) ?? randomPlanet
				PlanetView(planet: moon)
					.padding()
				
				//TODO: Change to the ascendant
				var rando = natalChart?.planets.get(planet: .Moon) ?? randomPlanet
				PlanetView(planet: rando)
					.padding()
			}
			
			HStack{
				
				var mercury = natalChart?.planets.get(planet: .Mercury) ?? randomPlanet
				var venus = natalChart?.planets.get(planet: .Venus) ?? randomPlanet
				var mars = natalChart?.planets.get(planet: .Mars) ?? randomPlanet
				 
				PlanetView(planet: mercury)
					.padding()
				PlanetView(planet: venus)
					.padding()
				PlanetView(planet: mars)
					.padding()
			}
			
			HStack{
				
				var jupiter = natalChart?.planets.get(planet: .Jupiter) ?? randomPlanet
				var saturn = natalChart?.planets.get(planet: .Saturn) ?? randomPlanet
				var uranus = natalChart?.planets.get(planet: .Uranus) ?? randomPlanet
				 
				PlanetView(planet: jupiter)
					.padding()
				PlanetView(planet: saturn)
					.padding()
				PlanetView(planet: uranus)
					.padding()
			}
			
			HStack{
				
				var neptune = natalChart?.planets.get(planet: .Neptune) ?? randomPlanet
				var pluto = natalChart?.planets.get(planet: .Pluto) ?? randomPlanet
				 
				PlanetView(planet: neptune)
					.padding()
				PlanetView(planet: pluto)
					.padding()
				
			}
				
				
		}
		.frame(width: .infinity, height: 55)
		.tabViewStyle(.page(indexDisplayMode: .never))
			
			
		
		
		
	}
}

struct NatalChartTabView_Previews: PreviewProvider {
    static var previews: some View {
        NatalChartTabView()
    }
}
