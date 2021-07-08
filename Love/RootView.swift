//
//  RootView.swift
//  Love
//
//  Created by Micheal Bingham on 6/22/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct RootView: View {
    
    @EnvironmentObject private var account: Account
    
    
    var body: some View {
        
        
     
        NavigationView {
            
            Group{
                
                if account.isSignedIn{
                    
                    ProfileView().environmentObject(self.account)
                    
                } else{
                    
                    EnterPhoneNumberView()
                }
            } .onDisappear(perform: {
                account.stopListening()
        })
        }
        
       
        
        
    }
}

@available(iOS 15.0, *)
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(Account())
    }
}
