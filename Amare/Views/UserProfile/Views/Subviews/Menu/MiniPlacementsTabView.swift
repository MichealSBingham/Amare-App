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


struct MiniPlacementVerticalPageView: View {
    var interpretations: [String: String] = [:]
    var planets: [Planet] = []

    @State  var selectedPlanet: Planet // Use a UUID or any unique identifier for planets

    var body: some View {
        TabView(selection: $selectedPlanet) {
            
            ForEach(planets) { planet in
                
            DetailedMiniPlacementView(
                        interpretation: interpretations[planet.name.rawValue],
                        planetBody: planet.name,
                        sign: planet.sign,
                        house: planet.house,
                        angle: planet.angle,
                        element: planet.element
                    )
                    //.rotationEffect(.degrees(-90), anchor: .center)
                    //.frame(width: .infinity, height: .infinity)
                    .tag(planet)
                .buttonStyle(PlainButtonStyle())
            }
        }
       // .rotationEffect(.degrees(90), anchor: .center)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onAppear {
            // Set the selected planet when the view appears (e.g., set it to the first planet)
           // selectedPlanetID = planets.first?.id
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                BackButton()
                    .padding()
                
            }
        }
    }
}


struct MiniPlacementsScrollView: View {
    var interpretations: [String:String] = [:]
    var planets: [Planet] = []
    
    var body: some View {
    
        ScrollView{
            ForEach(planets) { planet in
                
                NavigationLink{
                    
                 
                    MiniPlacementVerticalPageView(interpretations: interpretations, planets: planets, selectedPlanet: planet)
                    

                    
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
