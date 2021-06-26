//
//  EnterNameView.swift
//  Love
//
//  Created by Micheal Bingham on 6/19/21.
//

import SwiftUI

struct EnterNameView: View {
    

    
    
    @EnvironmentObject private var account: Account
    
    @State  private var name: String = ""
    @State private var goToNext: Bool = false
    
   
    
    
    
    var body: some View {
       
      //  NavigationView{ // comment this out when running code. for some reason, if this is not here, the navigation title will not show in the preview canvas
            
            ZStack{
                
                // Background Image
                Image("backgrounds/background1")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .navigationTitle("What is your name?")
                    .navigationBarColor(backgroundColor: .clear, titleColor: .white)
                
                // ******* ======  Transitions -- Navigation Links =======
                
                // Goes to the Profile
                NavigationLink(
                    destination: EnterBirthdayView(),
                    isActive: $goToNext,
                    label: {  EmptyView()  }
                )
                
                // ******* ================================ **********
                
                VStack{
                    
                    TextField("Micheal S. Bingham", text: $name, onCommit:  {
                        
                        guard !(name.isEmpty) else{
                            
                            // User entered an empty name
                            print("Name is empty")
                            return
                        }
                        
                        // Go to next page
                        goToNext = true
                        
                        var userdata = UserData(id: account.user?.uid ?? "")
                        userdata.name = name
                        
                        account.set(data: userdata) { error in
                            
                          
                            
                            guard error == nil else {
                                // There is some error
                               
                                
                                goToNext = false
                                return
                            }
                            
                           
                        }
                        
                    })
                    .font(.largeTitle)
                    
                    
                    
                }
                
                
                    
                
               
                
                
                
            } .onAppear {
                doneWithSignUp(state: false)
            }
            
          
            
      //  }
            

    }
}

struct EnterNameView_Previews: PreviewProvider {
    static var previews: some View {
        EnterNameView()
    }
}
