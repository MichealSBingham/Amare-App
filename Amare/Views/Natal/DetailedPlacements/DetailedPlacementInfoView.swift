//
//  DetailedPlacementInfoView.swift
//  Amare
//
//  Created by Micheal Bingham on 10/29/23.
//

import SwiftUI

struct DetailedPlacementInfoView: View {
    var body: some View {
        VStack{
            
            HStack{
                
                planet3DImage()
                
                VStack{
                    
                    
                        
                        planetName()
                        .onAppear {
                            guard planet != nil else { return }
                            viewModel.findPeople(with: planet!)
                        }
                        
                       planetImage()
                        
                        
                   
                    
                  
                    
                    alternatingTextOfWhatItRules()
                    

                }
               
            }
        }
    }
}

#Preview {
    DetailedPlacementInfoView()
}
