//
//  EnterNameView.swift
//  Love
//
//  Created by Micheal Bingham on 6/19/21.
//

import SwiftUI
import NavigationStack

@available(iOS 15.0, *)
struct EnterNameView: View {
    
    /// To manage navigation
    @EnvironmentObject var navigation: NavigationModel
    
    /// id of view
    static let id = String(describing: Self.self)
    
    @EnvironmentObject private var account: Account
    
    @State  private var name: String = ""
    @State private var goToNext: Bool = false
    
   
    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String  = ""
    
    
    var body: some View {
       

            
        NavigationStackView(EnterNameView.id) {
            
            ZStack{
                    
                    // Background Image
                    Image("backgrounds/background1")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                       // .navigationTitle("What is your name?")
                      //  .navigationBarColor(backgroundColor: .clear, titleColor: .white)
                        .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
                    
                    // ******* ======  Transitions -- Navigation Links =======
                    /*
                    // Goes to the Profile
                    NavigationLink(
                        destination: EnterGenderView().environmentObject(account),
                        isActive: $goToNext,
                        label: {  EmptyView()  }
                    )
                    */
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
        }
            
          
            
  
            

    }
    
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
        
    }
    
}













// Previewing in canvas 
@available(iOS 15.0, *)
struct EnterNameView_Previews: PreviewProvider {
    static var previews: some View {
        
       
            EnterNameView().environmentObject(Account())
                .preferredColorScheme(.dark)
                .environmentObject(NavigationModel())
        
        
    }
}
