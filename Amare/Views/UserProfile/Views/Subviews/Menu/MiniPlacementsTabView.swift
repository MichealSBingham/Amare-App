//
//  MiniPlacementsTabView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/6/23.
//

import SwiftUI
import LoremSwiftum

struct MiniPlacementsTabView: View {
    var interpretations: [String:String] = [:]
    var planets: [Planet] = []
    
    var body: some View {
    
        TabView{
            ForEach(planets) { planet in
                MiniPlacementView(interpretation: interpretations[planet.name.rawValue], planetBody: planet.name, sign: planet.sign)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        
    }
}

struct MiniPlacementsScrollView: View {
    var interpretations: [String:String] = [:]
    var planets: [Planet] = []
    
    var body: some View {
    
        ScrollView{
            ForEach(planets) { planet in
                
                NavigationLink{
                    
                    DetailedPlacementInfoView(
                        isShown: .constant(true), planetName: planet.name,
                        sign: planet.sign,
                        house: planet.house,
                        angle: planet.angle,
                        longDescription:interpretations[planet.name.rawValue],
                        element: planet.element
                        
                    )

                    
                } label: {
                    MiniPlacementView(interpretation: interpretations[planet.name.rawValue], planetBody: planet.name, sign: planet.sign)
                }
                .buttonStyle(PlainButtonStyle())
                
            }
        }
        
        
    }
}

#Preview {
    MiniPlacementsScrollView(interpretations: generateRandomPlanetInfoDictionary(), planets: Planet.randomArray(ofLength: 5))
        
}

func generateRandomPlanetInfoDictionary() -> [String: String] {
    var planetInfoDict = [String: String]()

    // Iterate through all planet names
    for planetName in PlanetName.allCases {
        let key = planetName.rawValue
        let value = Lorem.paragraphs(1)
        planetInfoDict[key] = value
    }

    return planetInfoDict
}
