//
//  InputNameView.swift
//  Amare
//
//  Created by Micheal Bingham on 6/4/23.
//

import SwiftUI

struct InputNameView: View {
    
    @EnvironmentObject var model: OnboardingViewModel

    
    @State   var name: String = ""
    
    
   
    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String  = ""
    
    @State private var beginAnimation: Bool = false
    @State private var beginAnimation2: Bool = false
    
    @State private var buttonIsDisabled: Bool = false

	@FocusState private var isFieldFocused: Bool
   
    enum FirstResponders: Int {
            case name
        }
    @State var firstResponder: FirstResponders? = .name
    
    
    var body: some View {
       

        
        ZStack{
            
            
            
            
            VStack{
                    
            
                
                
                
                Spacer()
               
                title().padding()
                
          
                
               Text("Enter your name below")
                    .font(.system(size: 20))
                    //.foregroundColor(.white)
                    .padding()
                
           
                
                enterNameField().padding()
					.padding(.bottom)
					.onAppear{
						firstResponder = .name
					}
				
				NextButtonView {
					guard !(name.isEmpty) else{
						// User entered an empty name
					  /// - TODO: Do something to tell the user to enter a name
						return
					}
					
					name = name.trimmingCharacters(in: .whitespacesAndNewlines)
						
					// Set the name in the OnboardingModel
					model.name = name
				  
				  withAnimation {
					  model.currentPage = .hometown
				  }
					
				}
				.padding(.vertical)
				.disabled(name.isEmpty)
				.opacity(name.isEmpty ? 0.5: 1.0)
				
				   
                Spacer()
				Spacer()
				
				
				
     
                    
                }
            .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
    
            .onAppear { withAnimation {beginAnimation = true} /*; settings.viewType = .EnterNameView; doneWithSignUp(state: false) */}
            

            
            
        }
                    
               
                
                        
                    
            
               
            
    }
            
          
            
  
            

    
    /// Creates the logo for the view
    func createLogo() -> some View {
        
        /// The molecule (center) part of the logo (image)
         func moleculeImage() -> some View {
            
            return Image("branding/molecule")
                 .resizable()
                .scaledToFit()
                .frame(width: 35, height: 29.5)
               
        }
        
        /// The ring part of the logo (Image)
         func ringImage() -> some View {
            
            return Image("branding/ring")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            
               
        }
        
        ///The horizontal  part of the cross that's a part of the logo
         func horizontalCrossImage() -> some View {
            
            return Image("branding/cross-h")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 3)
                .offset(y: 44)
        }
        
        /// The verticle part of the cross that's a part of the logo
         func verticleCrossImage() -> some View {
            
            return Image("branding/cross-v")
                .resizable()
                .scaledToFit()
                .frame(width: 3.5, height: 28)
                .offset(x: 0, y: 38)  // was -8
                
                
        }
        
        
        return Group{
            ZStack{ ringImage() ; moleculeImage()  }
            ZStack{ verticleCrossImage() ; horizontalCrossImage() }
        }
            .offset(y: beginAnimation ? 30: 0 )
            .animation(.easeInOut(duration: 2.25).repeatForever(autoreverses: true), value: beginAnimation)
            .onAppear(perform: {  withAnimation{beginAnimation = true}})

    }
    
    func enterNameField() -> some View {
        
        return    TextField("Micheal S. Bingham", text: $name, onCommit:  {
            
            //TODO: Make sure the user can ONLY tap this once so we need to do something about this, ensure a unique tap for pressing 'return' so that this code is only executed once. 
          
            
			
		
			
            guard !(name.isEmpty) else{
                
                // User entered an empty name
              /// - TODO: Do something to tell the user to enter a name
                return
            }
            
         
          
            name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            
                
            // Set the name in the OnboardingModel
            model.name = name
            
         
          
          withAnimation {
              model.currentPage = .hometown
          }
            
          
            
        })
		
		.firstResponder(id: FirstResponders.name, firstResponder: $firstResponder, resignableUserOperations: .none)
        .font(.largeTitle)
      

    }
    
    /// Title of the view text .
    func title() -> some View {
        
        return Text("Your Cosmic Identity")
            .bold()
            .font(.system(size: 40)) // was 50
          //  .lineLimit(1)
            //.minimumScaleFactor(0.01)
            //.foregroundColor(.white)
    }
    
 
    }
    

    /*
    func handle(_ error: Error)  {
        
        // Handle Error
        if let error = error as? AccountError{
            
            switch error {
            case .doesNotExist:
                alertMessage = "You do not exist."
            case .disabledUser:
                alertMessage = "Sorry, your account is disabled."
            case .expiredVerificationCode:
                alertMessage = "Your verification code has expired."
            case .wrong:
                alertMessage = "You entered the wrong code"
            case .notSignedIn:
                alertMessage = "You are not signed in."
            case .uploadError:
                alertMessage = "There was some upload Error"
            case .notAuthorized:
                alertMessage = "You are not authorized to do this."
            case .expiredActionCode:
                alertMessage = "The action code has expired"
            case .sessionExpired:
                alertMessage = "The session has expired"
            case .userTokenExpired:
                alertMessage = "The user token has expired"
            }
        }
        
        if let error = error as? GlobalError{
            
            switch error {
            case .networkError:
                alertMessage = "There is a network error. Lost internet connection"
            case .tooManyRequests:
                alertMessage = "You're trying too many times to ping our servers. Wait a bit."
            case .captchaCheckFailed:
                alertMessage = "You might be a robot because you failed the captcha check and that's quite rare. Goodbye."
            case .invalidInput:
                alertMessage = "You entered something wrong with the wrong format."
            case .quotaExceeded:
                alertMessage = "This isn't your fault. We need to scale to be able to withstand the current quota. Just try again in a bit."
            case .notAllowed:
                alertMessage = "You are not allowed to do that."
            case .internalError:
                alertMessage = "There was some internal error with us. Not your fault."
            case .cantGetVerificationID:
                alertMessage = "This isn't an end-user error and you honestly should not be seeing this. If you did, something is broken. Report it to us because your verification ID is not being saved."
            case .unknown:
                alertMessage = "I'm not sure what this error is, lol."
            }
        }
        
        
        // Handle Error
        someErrorOccured = true
    }
    */
    

    
    



struct InputNameView_Previews: PreviewProvider {
    static var previews: some View {
        
            InputNameView()
                .environmentObject(OnboardingViewModel())
        
       
    }
}
