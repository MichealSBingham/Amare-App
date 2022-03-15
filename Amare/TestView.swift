//
//  TestView.swift
//  Amare
//
//  Created by Micheal Bingham on 1/19/22.
//

import SwiftUI
import Firebase
import PushNotifications

struct TestView: View {
    
    @ObservedObject var viewModel: UserDataModel = UserDataModel()
    let beamsClient = PushNotifications.shared
    
    
    var body: some View {
        
        
        
        
        
        
        ZStack{
            
            
                
            
            
            Button {
                print("subscribed to : \(Auth.auth().currentUser?.uid) ")
                
                let me = Auth.auth().currentUser?.uid
                
                /*
                viewModel.subscribeToUserDataChanges(for: Auth.auth().currentUser?.uid ?? "U214TAvtCsVUSxecjeoPl7cs8PW2")
                
                viewModel.subscribeToNatalChart(for: Auth.auth().currentUser?.uid ?? "U214TAvtCsVUSxecjeoPl7cs8PW2")
                */
                
                let will = "hcrmKaxcEcc8CqY4B6Uh5VGG7Yc2"
                let micheal = "u4uS1JxH2ZO8re6mchQUJ1q18Km2"
                
                let personWhoIsntMe = (me != will) ? will: micheal
                
                viewModel.load(user: personWhoIsntMe)
               
                
                AmareApp().delay(5) {
                    print("Changing color..")
                    
                    viewModel.userData._synastryScore = 0.94
                    
                    
                
                    
                    
                    
                    
                    
                    
                  
                    
                  
                    
                    withAnimation(.easeIn(duration: 3)){
                        // change color of aspect 
                        viewModel.userData.natal_chart?.planets[0]._aspectThatExists = .trine
                    }
                    
                    
                    
                    
                }
                
                
            } label: {
                Text("Subscribe")
            }
            
            ProfilePopup(user: $viewModel.userData)
                 .opacity(viewModel.userData.isComplete() ? 1 : 0 )
                .hoverEffect()
            
            
            
            Button {
                
                    
                viewModel.userData._synastryScore = Double.random(in: 0...1)
                
                viewModel.userData._chemistryScore = Double.random(in: 0...1)
                
                viewModel.userData._loveScore = Double.random(in: 0...1)
                
                viewModel.userData._sexScore = Double.random(in: 0...1)
                

            } label: {
                Text("Regenerate")
            }
            .opacity(0)
            .offset(x: 10, y: 20)

        }.onAppear {
            
            if  let me = Auth.auth().currentUser?.uid{
               try? beamsClient.addDeviceInterest(interest: me)

            }
    }
       
        
       

    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
