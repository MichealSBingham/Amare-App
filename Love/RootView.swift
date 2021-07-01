//
//  RootView.swift
//  Love
//
//  Created by Micheal Bingham on 6/22/21.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject private var account: Account
    
    
    var body: some View {
        
        
     
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

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(Account())
    }
}
