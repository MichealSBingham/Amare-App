//
//  ProfileView.swift
//  Love
//
//  Created by Micheal Bingham on 6/18/21.
//

import SwiftUI

struct ProfileView: View {
    

    

    
    
    var body: some View {
        
        ZStack{
            
            Image("backgrounds/background1")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .navigationBarBackButtonHidden(true)
                
                
            // ******* ======  Transitions -- Navigation Links =======
            /*
            // Goes to the Profile
            NavigationLink(
                destination: EnterPhoneNumberView(),
                isActive: $shouldLogOut,
                label: {  EmptyView()  }
                        )
            .isDetailLink(false) // Because it goes to Root Navigation View
            */
            // ******* ================================ **********
            
            
            VStack{
                
                Button("Sign Out") {
                    // Signs out of profile
                    Account.signOut {
                        
                       
                        NavigationUtil.popToRootView() // goes to root view 
                        
                    }
                        
                        cantSignOut: { error in
                        
                        // Some error happened when attempting to sign out
                        
                            
                    }

                }
                
            }
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
