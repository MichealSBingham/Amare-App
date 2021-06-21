//
//  EnterNameView.swift
//  Love
//
//  Created by Micheal Bingham on 6/19/21.
//

import SwiftUI

struct EnterNameView: View {
    
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
                        
                        // User pressed enter
                        print("The name is \(name)")
                        
                    })
                    .font(.largeTitle)
                    
                    
                    
                }
                
                
                    

               
                
                
                
            }
            
      //  }

    }
}

struct EnterNameView_Previews: PreviewProvider {
    static var previews: some View {
        EnterNameView()
    }
}
