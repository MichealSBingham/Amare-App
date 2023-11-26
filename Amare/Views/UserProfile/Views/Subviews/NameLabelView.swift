//
//  NameLabelView.swift
//  Amare
//
//  Created by Micheal Bingham on 10/20/23.
//

import SwiftUI



struct NameLabelView: View {
    var name: String?
    var username: String?

    var body: some View {
        VStack {
            Text(name ?? "Micheal Bingham")
                .fontWeight(.medium)
                .font(.headline)
            
        }
        .redacted(reason: name == nil ? .placeholder : [])
    }
}


#Preview {
    
    NameLabelView(name: "Micheal Bingham", username: "micheal")
}
