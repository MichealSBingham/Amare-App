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
        
        
        VStack{
            
            
            Text(viewModel.userData?.name ?? "nothing")
            
            
            Button {
                print("subscribed")
                viewModel.subscribeToUserDataChanges(for: "U214TAvtCsVUSxecjeoPl7cs8PW2")
            } label: {
                Text("Subscribe")
            }
        }
        
       

    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
