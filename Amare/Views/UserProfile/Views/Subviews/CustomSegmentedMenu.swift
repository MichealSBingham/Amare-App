//
//  CustomSegmentedMenu.swift
//  Amare
//
//  Created by Micheal Bingham on 10/27/23.
//

import SwiftUI


struct CustomSegmentedMenu: View {
    @Binding var selectedSegment: Int
    let menuOptions = ["Synastry Charts", "Natal Chart", "Media"]
    
    var body: some View {
        Picker("", selection: $selectedSegment) {
            ForEach(0..<menuOptions.count) { index in
                Text(self.menuOptions[index])
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}


struct CustomSegmentedMenu_Previews: PreviewProvider {
    static var previews: some View {
        CustomSegmentedMenu(selectedSegment: .constant(1))
    }
}
