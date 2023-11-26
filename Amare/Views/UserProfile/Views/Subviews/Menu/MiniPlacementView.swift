//
//  MiniPlacementView.swift
//  Amare
//
//  Created by Micheal Bingham on 10/27/23.
//

import SwiftUI
import LoremSwiftum

struct MiniPlacementView: View {
    var interpretation: String?
    var planetBody: PlanetName?
    var sign: ZodiacSign?
    
    var numSentences: Int = 2
   
    
    var body: some View {
        
        ZStack{
            planetBody?.image_3D()
                .opacity(0.4)
            VStack{
                (Text(interpretation?.firstNSentences(numSentences) ?? Lorem.sentences(3)) + Text("..."))
                //.font(Font.custom("SF Pro Rounded", size: 14))
                    .redacted(reason: interpretation == nil ? .placeholder : [])
                    .multilineTextAlignment(.center)
                    .padding()
                   // .frame(width: 239, alignment: .top)
                
                HStack(spacing: 10){
                    
                    planetBody?.image().conditionalColorInvert()
                        .frame(height: 25)
                    
                    sign?.image().resizable().aspectRatio(contentMode: .fit).conditionalColorInvert()
                    
                        .frame(height: 25)
                    
                }
                .padding()
                
            }
        }
    }
}

#Preview {
    MiniPlacementView(interpretation: "Ordinary life often seems drab and uninteresting to Diana and Diana must have something that stirs her imagination, some vision or ideal or dream to motivate her.", planetBody: .Mars, sign: .Scorpio)
}
