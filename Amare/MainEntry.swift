//
//  MainEntry.swift
//  Amare
//
//  Created by Micheal Bingham on 12/28/22.
//

import SwiftUI

struct MainEntry: View {
    
    @State var menuSelection  = 2
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                FloatingTabbar(selected: $menuSelection)
                   
            }
        
        }
    }
}

struct MainEntry_Previews: PreviewProvider {
    static var previews: some View {
        MainEntry()
    }
}
