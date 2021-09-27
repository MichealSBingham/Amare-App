//
//  RV.swift
//  Amare
//
//  Created by Micheal Bingham on 8/7/21.
//

import SwiftUI
import NavigationStack
import FirebaseAuth

typealias PerformOnce = () -> Void

struct RootView: View {
    
    static let id = String(describing: Self.self)
    @EnvironmentObject private var account: Account
    
    @EnvironmentObject private var navigationStack: NavigationStack

    static var signOutOnlyOnce: PerformOnce = {
        Account().signOut { error in
            return
        }
            return {}
        }()
    
    var body: some View {
        
        
      
        
        ZStack{
            
            let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()
            Background(timer: timer)
            
            NavigationStackView(transitionType: .custom(.opacity), easing: .easeInOut(duration: 0.8)){
                
               
               
             
               if account.isSignedIn{
                    
                    
                    
                    
                   MainView(isRoot: true )
                        .environmentObject(account)
                        .onAppear(perform: {  account.stopListening() })
                    
                    
                } else {

                    SignInOrUpView(isRoot: true )
                        .environmentObject(account)
                        .onAppear {  account.stopListening()}
                        
                        
                    
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
            
            
            
        }.onAppear {
            /// This will only run ONCE in a lifetime (unless the app is deleted and redownloaded, or unless it's rebuilt in dev). This will sign out the user.
            
            
            _ =  RootView.signOutOnlyOnce

        /*
            func doOnce() {
                struct Resource {
                    static var resourceInit : Void = {
                      print("Signing out only once in lifetime for initalizatoin ")
                        Account().signOut { error in
                            return
                        }
                    }()
                }

                let _ = Resource.resourceInit
            }
            */
            //doOnce()
            
        }
                
    }
    
    
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(Account())
    }
}
