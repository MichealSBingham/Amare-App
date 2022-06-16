//
//  RV.swift
//  Amare
//
//  Created by Micheal Bingham on 8/7/21.
//

import SwiftUI
import NavigationStack
import FirebaseAuth
import MultipeerKit
typealias PerformOnce = () -> Void

struct RootView: View {
    
    
    static let id = String(describing: Self.self)
    @EnvironmentObject private var account: Account
    
    @EnvironmentObject private var navigationStack: NavigationStack

    
     var isSignedIn: Bool = false
     var dataIsComplete: Bool = false
    
   
    
    
    var body: some View {
        
        
      
        
        ZStack{
            
            /*
            let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()
             Background(timer: timer)
             */
            Background()
            
            NavigationStackView(transitionType: .custom(.opacity), easing: .easeInOut(duration: 0.8)){
                
               
               
                
                // If signed in and done with user sign up procress
                if account.isSignedIn {
                    
                    
    
            
            
                 
                   MainView(isRoot: true )
                        .environmentObject(account)
                        .onAppear(perform: { account.stopListening()})
                     //   .environmentObject(multipeerDataSource)
                        
                    
                    
                } else {

                    SignInOrUpView(isRoot: true )
                        .environmentObject(account)
                        .onAppear { account.stopListening()}
                        
                        
                    
                }
                
               /*
                    MainView()
                        .environmentObject(account)
                        .onAppear(perform: {  account.stopListening() })
                        .opacity(account.isSignedIn ? 1: 0 )
                    
                    SignInOrUpView()
                        .environmentObject(account)
                        .onAppear {  account.stopListening()}
                        .opacity(account.isSignedIn ? 0: 1)
                */
                    
                    
                
                
               
                
            }
            
            
            
        }
        
        
      
                
    }
    
    
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(Account())
    }
}
