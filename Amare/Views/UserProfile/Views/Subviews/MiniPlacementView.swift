//
//  MiniPlacementView.swift
//  Amare
//
//  Created by Micheal Bingham on 10/27/23.
//

import SwiftUI

struct MiniPlacementView: View {
    var interpretation: String?
    var planet: Planet?
    
    var body: some View {
        Text("Ordinary life often seems drab and uninteresting to Diana and Diana must have something that stirs her imagination, some vision or ideal or dream to motivate her.")
          //.font(Font.custom("SF Pro Rounded", size: 14))
          .multilineTextAlignment(.center)
        
          .frame(width: 239, alignment: .top)
        
        
    }
}

#Preview {
    MiniPlacementView()
}
