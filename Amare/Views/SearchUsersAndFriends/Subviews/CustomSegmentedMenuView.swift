//
//  CustomSegmentedMenuView.swift
//  Amare
//
//  Created by Micheal Bingham on 7/13/23.
//

import SwiftUI

struct CustomSegmentedMenuView: View {
    @Binding var segmentationSelection: UserTypeSection

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(UserTypeSection.allCases, id: \.self) { option in
                    Button(action: {
                        segmentationSelection = option
                    }) {
                        Text(option.rawValue)
                            .foregroundColor(option == segmentationSelection ? .white : .primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(option == segmentationSelection ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}







struct CustomSegmentedMenuView_Previews: PreviewProvider {
    @State static  var selection: UserTypeSection = .all

    
    static var previews: some View {
            
            CustomSegmentedMenuView(segmentationSelection: $selection)
            
        
    }
}
