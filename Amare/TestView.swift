//
//  TestView.swift
//  Amare
//
//  Created by Micheal Bingham on 1/19/22.
//

import SwiftUI
import Firebase
import PushNotifications
import MultipeerKit

struct TestView: View {
    
   // @EnvironmentObject var multipeerDataSource: MultipeerDataSource

    @ObservedObject var viewModel: UserDataModel = UserDataModel()
    let beamsClient = PushNotifications.shared
    
    
    @StateObject var multipeerDataSource: MultipeerDataSource =
    MultipeerDataSource(transceiver: MultipeerTransceiver(configuration: MultipeerConfiguration(serviceType: "Amare", peerName: Auth.auth().currentUser?.uid ?? "id", defaults: UserDefaults.standard, security: .default, invitation: .automatic)))

   

    
    // Consider Adding elsewhere
    
 
  
    

    
    
    var body: some View {
        
        
        
       
        
        
        
        VStack{
            
            
            ForEach(multipeerDataSource.availablePeers){ peer in
                
                Button{
                    
                    multipeerDataSource.transceiver.broadcast("Hi peers.")

                } label: {
                    
                    Text("Peer Detected: \(peer.name)")
                }
                
                
                
            }
            
            /*
            Button {
                
                
                multipeerDataSource.transceiver.broadcast("Hi peers.")
                
            } label: {
                
                Text("Peer Count:  \(multipeerDataSource.availablePeers.count) ")
            }
            
            */

          //
                
            
           
            
            
            

        }.onAppear {
            
            if  let me = Auth.auth().currentUser?.uid{
               try? beamsClient.addDeviceInterest(interest: me)
                
        

            }
            
           
        
            
            // Resume the transceiver
            print("resuming transceiver")
            multipeerDataSource.transceiver.resume()
            
            
            //*** Example usage of receiving message from peer
            multipeerDataSource.transceiver.receive(String.self) { payload, sender in
                
                
                
                // send notification when received
                let content = UNMutableNotificationContent()
                        content.body = "\"\(payload)\" from \(sender.name)"
                        let request = UNNotificationRequest(identifier: payload, content: content, trigger: nil)
                        UNUserNotificationCenter.current().add(request) { _ in

                        }
            }
            
            //*** Example usage of receiving message from peer
            
            
            
    }
       
        
       

    }
    
    /*
    func exampleUsageOfProfilePopup(<#parameters#>) -> <#return type#> {
        
        /*
         EXAMPLE USAGE OF PROFILE POPUP
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
        
        */
    }
     
     */
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
