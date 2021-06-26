//
//  ProfileView.swift
//  Love
//
//  Created by Micheal Bingham on 6/18/21.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    
    
     @EnvironmentObject private var account: Account


    var body: some View {
        
        ZStack{
            
                
            Image("backgrounds/background1")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .navigationBarBackButtonHidden(true)
                .navigationBarTitle("Profile")
                

                .onReceive(NotificationCenter.default.publisher(for: NSNotification.logout), perform: { _ in
                    
                    NavigationUtil.popToRootView()
                
                })
          
            
            VStack{
                
                Spacer()
                
                Text(account.user?.displayName ?? "The User's Name Goes Here")//.colorInvert()
                
                Text(account.user?.uid ?? "The User's ID Goes Here")//.colorInvert()

                
                
                Spacer()
                
               
                
                Button("Sign Out") {
                    // Signs out of profile
                    account.signOut {
                        
                       

                        
                    }
                        
                        cantSignOut: { error in
                        
                        // Some error happened when attempting to sign out
                        print("Some sign out error happened \(error)")
                            
                    }

                }
                
                Spacer()
                
            }
            
        } .onAppear(perform: {
            
            doneWithSignUp()
            account.listen()
            account.stopListening()
            account.listenOnlyForSignOut()
            
        })
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
