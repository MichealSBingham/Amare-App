//
//  EnterGenderView.swift
//  Love
//
//  Created by Micheal Bingham on 7/6/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct EnterGenderView: View {
    
    
    @EnvironmentObject private var account: Account
    @State private var goToNext: Bool = false
    
    @State private var alertMessage: String = ""
    @State private var someErrorOccured: Bool = false
    
    
    
    var body: some View {
        
        ZStack{
            
            SetBackground()
            
            // ******* ======  Transitions -- Navigation Links =======
            //                                                      //
            //                Goes to the Profile                   //
            //                                                      //
         /* || */           NavigationLink(                       /* || */
        /* || */   destination: EnterOrientationView().environmentObject(account),
        /* || */           isActive: $goToNext,                  /* || */
        /* || */           label: {  EmptyView()  })             /* || */
        /* || */                                                 /* || */
        /* || */                                                 /* || */
            // ******* ================================ **********
            
            
            HStack{
                
                MakeManButton()
                Spacer()
                MakeWomanButton()
                Spacer()
                MakeOtherButton()
                
            }
            
            
        } .onAppear {
            // set view to restore state 
            doneWithSignUp(state: false)
        }
       
        
        
        
        
        
        
    }
    
    
    
    
    
    
    // ======================================================================================


    func MakeManButton() -> some View  {
        
        return   Button("Man") {
            
            // selected man
            SelectGenderAction(gender: "M")
        }.padding()

        
    }

    func MakeWomanButton() -> some View {
        
        return Button("Woman") {
            
            // selected woman
            SelectGenderAction(gender: "F")
        }.padding()
    }


    /// Once this button is tapped, the user should be able to enter their own custom gender
    func MakeOtherButton() -> some View  {
        
        return Button("Other") {
            
            // selected other
            SelectGenderAction(gender: "O")
            
        }.padding()
    }



    func SetBackground() -> some View {
        
        return Image("backgrounds/background1")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("Hey Micheal, you are a ...")
            .navigationBarColor(backgroundColor: .clear, titleColor: .white)
            .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
    }



    // ======================================================================================




    func SelectGenderAction(gender: String)  {
        
        goToNext = true
        
        self.account.data?.sex = gender
        
        do{
            
            try account.save()
            
        } catch (let error){
            
            // Handle Error //
            
            handle(error)
            
            // Handle Error //
        }
        
            
        
        
    }





    // =======================================================================================

    
    
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











@available(iOS 15.0, *)
struct EnterGenderView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView{
            EnterGenderView().environmentObject(Account())
        }
       
    }
}
