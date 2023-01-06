//
//  MapCustomToggleView.swift
//  Amare
//
//  Created by Micheal Bingham on 12/30/22.
//

import Foundation
import SwiftUI


struct MapToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Label {
                configuration.label
            } icon: {
                Image( !configuration.isOn ? "DiscoverNearbyView/private" : "DiscoverNearbyView/not private")
                   // .foregroundColor(configuration.isOn ? .accentColor : .secondary)
                   // .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                    .imageScale(.large)
               
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
