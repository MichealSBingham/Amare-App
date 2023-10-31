//
//  PlanetView.swift
//  Amare
//
//  Created by Micheal Bingham on 7/27/23.
//

import SwiftUI

struct PlanetView: View {
	
	@Environment(\.colorScheme) var colorScheme
	
	var planet: Planet?
    
 
	
	var body: some View {
		
        if let planet = planet {
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
        else{
            EmptyView()
        }
	}
}

struct PlanetView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetView()
    }
}
