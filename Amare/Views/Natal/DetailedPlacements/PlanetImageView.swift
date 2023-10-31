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

#Preview {
    //PlanetImageView(planetName: PlanetName.allCases.randomElement()!)
    PlanetImageView_For_Preview()
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
