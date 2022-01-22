//
//  TestView.swift
//  Amare
//
//  Created by Micheal Bingham on 1/19/22.
//

import SwiftUI

struct TestView: View {
    
    @ObservedObject var viewModel: UserDataModel = UserDataModel()
    
    
    var body: some View {
        
        
        
        
        
        
        ZStack{
            
            
                
            
            
            Button {
                print("subscribed")
                viewModel.subscribeToUserDataChanges(for: "U214TAvtCsVUSxecjeoPl7cs8PW2")
                
                viewModel.subscribeToNatalChart(for: "U214TAvtCsVUSxecjeoPl7cs8PW2")
                
                
                AmareApp().delay(5) {
                    print("Changing color..")
                    
                    viewModel.userData?._synastryScore = 0.94
                    
                    
                
                    
                    
                    
                    
                    
                    
                  
                    
                  
                    
                    withAnimation(.easeIn(duration: 3)){
                        
                        viewModel.userData?.natal_chart?.planets[0]._aspectThatExists = .trine
                    }
                    
                    
                    
                    
                }
                
                
            } label: {
                Text("Subscribe")
            }
            
            ProfilePopup(user: $viewModel.userData)
                .opacity(viewModel.userData != nil ? 1 : 0 )
            
            
            
            Button {
                
                    
                    viewModel.userData?._synastryScore = Double.random(in: 0...1)
                
                

            } label: {
                Text("Regenerate")
            }
            .offset(x: 10, y: 20)

        }
       
        
       

    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
