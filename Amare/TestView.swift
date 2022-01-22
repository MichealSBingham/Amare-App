//
//  TestView.swift
//  Amare
//
//  Created by Micheal Bingham on 1/19/22.
//

import SwiftUI

struct TestView: View {
    
    @ObservedObject var viewModel: HomeViewModel = HomeViewModel()
    
    
    var body: some View {
        
        
        
        
        
        
        ZStack{
            
            
                
            
            
            Button {
                print("subscribed")
                viewModel.subscribeToUserDataChanges(for: "U214TAvtCsVUSxecjeoPl7cs8PW2")
            } label: {
                Text("Subscribe")
            }
            
            ProfilePopup(user: $viewModel.userData)
                .opacity(viewModel.userData != nil ? 1 : 0 )
        }
       
        
       

    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
