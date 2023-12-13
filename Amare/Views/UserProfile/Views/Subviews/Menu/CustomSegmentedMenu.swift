//
//  CustomSegmentedMenu.swift
//  Amare
//
//  Created by Micheal Bingham on 10/27/23.
//

import SwiftUI
enum MenuOptions: String{
    case synastryChart
    case natalChart
    case media
}

struct CustomSegmentedMenu: View {
    @Binding var selectedSegment: MenuOptions
    let menuOptions: [MenuOptions] = [.synastryChart, .natalChart, .media]
    
    var body: some View {
        Picker("", selection: $selectedSegment) {
            ForEach(0..<menuOptions.count) { index in
                Text(self.menuOptions[index].rawValue)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}


struct CustomSegmentedMenu_Previews: PreviewProvider {
    static var previews: some View {
        CustomSegmentedMenu(selectedSegment: .constant(.media))
    }
}
