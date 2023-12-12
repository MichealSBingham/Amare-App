//
//  3DPlanetImageView.swift
//  Amare
//
//  Created by Micheal Bingham on 10/29/23.
//

import SwiftUI

struct PlanetImageView: View {
    var planetName: PlanetName
    var body: some View {
         planetName.image_3D()
                    
    }
}

struct PlanetGridView: View {
    
    var planets: [Planet] = []
    var interpretations: [String:String] = [:]
    
    var body: some View{
        var columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]

        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(planets, id: \.self) { planet in
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
                        VStack {
                            
                            ZStack{
                                
                                planet.name.image_3D()
                                    .opacity(0.5)
                                
                                planet.sign.image()
                                    .colorInvert()
                            }
                            
                            Text(planet.name.rawValue)
                                .font(.caption)
                            
                            
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
       

        
    }
}

#Preview {
    //PlanetImageView(planetName: PlanetName.allCases.randomElement()!)
    //PlanetImageView_For_Preview()
    PlanetGridView(planets: Planet.randomArray(ofLength: 9))
        .preferredColorScheme(.dark)
}


// Making sure we have planet images for all
struct PlanetImageView_For_Preview: View {
    let allPlanets = PlanetName.allCases
    
    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: 100))
        ]
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(allPlanets, id: \.self) { planet in
                    VStack {
                        PlanetImageView(planetName: planet)
                        Text(planet.rawValue)
                            .font(.caption)
                    }
                }
            }
        }
    }
}
