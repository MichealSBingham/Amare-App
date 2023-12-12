//
//  SegmentedMenuView.swift
//  Amare
//
//  Created by Micheal Bingham on 7/13/23.
//

import SwiftUI

struct SegmentedMenuView: View {
    @Binding var segmentationSelection: UserTypeSection
    
    let choices: [UserTypeSection] = [.all,  .requests]
    //[.all, .friends, .requests, .historicals, .custom]
    
    
    
    var body: some View {
        
        
      
            Picker("", selection: $segmentationSelection) {
                ForEach(choices, id: \.self) { option in
                    Text(option.rawValue)
                }
            }.pickerStyle(.segmented)
            
        
        
    }
}


struct SegmentedMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedMenuView(segmentationSelection: .constant(.all))
    }
}
