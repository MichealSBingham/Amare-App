//
//  MenuOptionsView.swift
//  Amare
//
//  Created by Micheal Bingham on 10/21/23.
//

import SwiftUI

struct MenuOptionsView: View {
    var body: some View {
        Image(systemName: "ellipsis")
            
            .resizable()
            .foregroundColor(Color.primary)
            .rotationEffect(.degrees(90))
            .aspectRatio(contentMode: .fit)
            
            
            
    }
}



#Preview {
    MenuOptionsView()
        .frame(width: 25)
}
