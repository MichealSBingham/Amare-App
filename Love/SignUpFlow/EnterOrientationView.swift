//
//  EnterOrientationView.swift
//  Love
//
//  Created by Micheal Bingham on 7/6/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct EnterOrientationView: View {
    
    @EnvironmentObject private var account: Account
    @State private var goToNext: Bool = false
    
    
    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String  = ""
    
    var body: some View {
        
        // ******* ======  Transitions -- Navigation Links =======
        //                                                      //
        //                Goes to the Profile                   //
        //                                                      //
     /* || */           NavigationLink(                       /* || */
    /* || */   destination: FromWhereView().environmentObject(account),
    /* || */           isActive: $goToNext,                  /* || */
    /* || */           label: {  EmptyView()  })             /* || */
    /* || */                                                 /* || */
    /* || */                                                 /* || */
        // ******* ================================ **********
        
        
        ZStack{
            
            SetBackground()
            
            
    
            HStack { MenButton(); WomenButton(); MenAndWomenButton(); EverythingButton()}
            
        }.onAppear {  doneWithSignUp(state: false)}
    }
    
    
    
    
    
    func SetBackground() -> some View {
        
        return Image("backgrounds/background1")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("I like ... ")
            .navigationBarColor(backgroundColor: .clear, titleColor: .white)
            .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
    }
    
    
    
    func MenButton() -> some View {
        
        return Button("Men") {
            // Selected they like Men
            SelectOrientaionAction(orientaion: "M")
            
        }.padding()
    }
    
    
    func WomenButton() -> some View {
        
        return Button("Women") {
            // Selected they like Women
            
            SelectOrientaionAction(orientaion: "W")
            
        }.padding()
    }
    
    func MenAndWomenButton() -> some View {
        
        return Button("Men and Women") {
            // Selected they like women and men
            SelectOrientaionAction(orientaion: "MW")
            
        }.padding()
    }
    
    func EverythingButton() -> some View {
        
        return Button("(?)ALL(?)") {
            // Selected they like everythong
            SelectOrientaionAction(orientaion: "A")
            
        }.padding()
    }
    
    
    
    
    
    func SelectOrientaionAction(orientaion: String)  {
        goToNext = true
        
        account.data?.orientation = orientaion
        
        do {
            
            try account.save()
            
        } catch (let error){
            
            goToNext = false
            handle(error)
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
struct EnterOrientationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{EnterOrientationView().environmentObject(Account()).preferredColorScheme(.dark)}
    }
}
