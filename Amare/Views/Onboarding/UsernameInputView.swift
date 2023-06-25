//
//  UsernameInputView.swift
//  Amare
//
//  Created by Micheal Bingham on 6/9/23.
//

import SwiftUI

struct UsernameInputView: View {
    
    @EnvironmentObject var model: OnboardingViewModel
    
    //@State var username: String = ""
    
    enum FirstResponders: Int {
            case username
        }
    
    @State var firstResponder: FirstResponders? = .username
    
    
    
    
    
    var body: some View {
        
        VStack{
            
            
            
            
            
            Spacer()
           
            Text("Choose Your Stardust Alias")
                .bold()
                .font(.system(size: 40))  // was 50 
                //.lineLimit(1)
                //.minimumScaleFactor(0.01)
                .padding()
            
       
            
           Text("Enter a username")
                .font(.system(size: 20))
                //.foregroundColor(.white)
                .padding()
            
       
            ZStack{
                
                enterUsernameField().padding()
                    .onChange(of: model.username) { newValue in
                        
                        model.isUsernameAvailable = nil
                        //TODO: complete the function for checking username availability
                        
                        guard !(model.username.isEmpty) else {
                            //TODO: Tell the user to enter a username
                            return
                        }
                        
                        model.checkUsername()
                    }
                
                HStack{
                    
                    Spacer()
                    
                    if !(model.username.isEmpty){
                        UsernameAvailabilityView(isUsernameAvailable: $model.isUsernameAvailable)
                    }
                    
                }
                
            }
            
            Text("")
            
            Spacer()
         
                
            Spacer()
               
 
                
            }
        
    }
    
    //TODO: Adjust this so that it only accepts valid usernames (no punctuation/no spaces/ etc)
    func enterUsernameField() -> some View {
        
        //TODO: Make sure there is an '@' in front of it.
        return    TextField("@starsystem2", text: $model.username,
                            
              onCommit:  {
            
            //TODO: Ensure that this code can only be executed once when they press return
                            
            
                                guard (model.isUsernameAvailable ?? false) else {
                                    
                                    // Username is not available so show a message saying so
                                    return
                                }
                                
                                
                                model.currentPage = .birthday
            
           
    
            
          
          
            
          
            
        })
            .firstResponder(id: FirstResponders.username, firstResponder: $firstResponder, resignableUserOperations: .none)
        .font(.largeTitle)
    
      

    }
    
    
    
}

struct UsernameInputView_Previews: PreviewProvider {
    static var previews: some View {
        
        
            UsernameInputView()
			.environmentObject(OnboardingViewModel())
        
       
    }
}






