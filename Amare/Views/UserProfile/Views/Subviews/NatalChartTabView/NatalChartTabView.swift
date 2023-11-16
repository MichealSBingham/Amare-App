//
//  NatalChartTabView.swift
//  Amare
//
//  Created by Micheal Bingham on 7/27/23.
//

import SwiftUI

struct NatalChartTabView: View {
	
    @EnvironmentObject var userDataModel: UserProfileModel
    
	var natalChart: NatalChart?
    /// The user id the natal chart belongs to
    var belongingToUserID: String?
	
	private let randomPlanet = Planet(name: .Sun, angle: 17.82, element: .water, onCusp: false, retrograde: false, one_line_placement_interpretation: nil, longer_placement_interpretation: nil, sign: .Cancer, house: 7, cusp: nil, speed: 7, forSynastry: false, _aspectThatExists: nil)
    
    /// Shows the detailed planet info view
    @State var showDetails: Bool = false
    
    @State var selectedPlanet: Planet?
	
    fileprivate  func PlanetViewButton(planet: Planet?) -> some View {
        
        NavigationLink {
            DetailedPlacementInfoView(
                isShown: .constant(true), planetName: planet?.name,
                sign: planet?.sign,
                house: planet?.house,
                angle: planet?.angle,
                longDescription: natalChart?.interpretations?[planet?.name.rawValue ?? ""],
                element: planet?.element
            )
            
        } label: {
            PlanetView(planet: planet )
                .redacted(reason: planet == nil ? .placeholder : [])
            
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    
    
    fileprivate func SunSignViewButton(planet: Planet?) -> some View {
        NavigationLink {
            DetailedPlacementInfoView(
                isShown: .constant(true), planetName: planet?.name,
                sign: planet?.sign,
                house: planet?.house,
                angle: planet?.angle,
                element: planet?.element
            )
            
        } label: {
            SunSignView(planet: planet)
                .redacted(reason: planet == nil ? .placeholder : [])
            
        }
        .buttonStyle(PlainButtonStyle())
    }
    
	var body: some View {
		
		TabView{
			
			HStack{
				
                let sun = natalChart?.planets.get(planet: .Sun)
				SunSignViewButton(planet: sun)
					.padding(.horizontal)
					.padding(.top, -10)
				Spacer()
			}
			
			
			HStack{
                let sun = natalChart?.planets.get(planet: .Sun)
				PlanetViewButton(planet: sun )
					.padding()
				
                let moon = natalChart?.planets.get(planet: .Moon)
				PlanetViewButton(planet: moon)
					.padding()
				
				//TODO: Change to the ascendant
                let rando = natalChart?.planets.get(planet: .Moon)
				PlanetViewButton(planet: rando)
					.padding()
			}
			
			HStack{
				
                let mercury = natalChart?.planets.get(planet: .Mercury)
                let venus = natalChart?.planets.get(planet: .Venus)
                let mars = natalChart?.planets.get(planet: .Mars)
				 
				PlanetViewButton(planet: mercury)
					.padding()
				PlanetViewButton(planet: venus)
					.padding()
				PlanetViewButton(planet: mars)
					.padding()
			}
			
			HStack{
				
                let jupiter = natalChart?.planets.get(planet: .Jupiter)
                let saturn = natalChart?.planets.get(planet: .Saturn)
                let uranus = natalChart?.planets.get(planet: .Uranus)
				 
				PlanetViewButton(planet: jupiter)
					.padding()
				PlanetViewButton(planet: saturn)
					.padding()
				PlanetViewButton(planet: uranus)
					.padding()
			}
			
			HStack{
				
                let neptune = natalChart?.planets.get(planet: .Neptune)
                let pluto = natalChart?.planets.get(planet: .Pluto) 
				 
				PlanetViewButton(planet: neptune)
					.padding()
				PlanetViewButton(planet: pluto)
					.padding()
				
			}
				
				
		}
		.frame(width: .infinity, height: 55)
		.tabViewStyle(.page(indexDisplayMode: .never))
        /*
        .sheet(isPresented: $showDetails, content: {
            if let planet = selectedPlanet {
                    DetailedPlacementInfoView(
                        isShown: $showDetails, planetName: planet.name,
                        sign: planet.sign,
                        house: planet.house,
                        angle: planet.angle,
                        element: planet.element
                    )
                } else {
                    // Provide a fallback view or just an empty view
                    EmptyView()
                }
        })
        .onChange(of: selectedPlanet) { newValue in
            if newValue != nil {
                withAnimation {
                    showDetails = true
                }
            }
        }
            */
		
		
		
	}
}

struct NatalChartTabView_Previews: PreviewProvider {
    static var previews: some View {
        NatalChartTabView()
            .preferredColorScheme(.dark)
    }
}
