//
//  RV.swift
//  Amare
//
//  Created by Micheal Bingham on 8/7/21.
//

import SwiftUI
import NavigationStack

struct RootView: View {
    
    static let id = String(describing: Self.self)
    @EnvironmentObject private var account: Account
    
    
    
    var body: some View {
        
        
        
        ZStack{
            
            let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()
            Background(timer: timer)
            
            NavigationStackView(transitionType: .custom(.scale), easing: .easeIn(duration: 0.5)){
                
                if account.isSignedIn{
                    
                    MainView()
                        .environmentObject(account)
                        .onAppear(perform: {  account.stopListening()})
                    
                    
                } else {
                    SignInOrUpView()
                        .onAppear {  account.stopListening() }
                        
                        
                    
                }
            }
            
        }
                
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(Account())
    }
}
