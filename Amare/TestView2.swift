//
//  TestView2.swift
//  Amare
//
//  Created by Micheal Bingham on 1/23/22.
//

import SwiftUI

struct TestView2: View {
    
    @ObservedObject var viewModel: UserDataModel = UserDataModel()

    
    var body: some View {
        
        ZStack{
            
            ProfilePopup(user: $viewModel.userData)
                .opacity(viewModel.userData != nil ? 1 : 0 )
            
            //MainPlacementView(planet: viewm)
        }
    }
}

struct TestView2_Previews: PreviewProvider {
    static var previews: some View {
        TestView2()
    }
}
