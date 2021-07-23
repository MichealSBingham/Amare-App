//
//  ContentView.swift
//  Love
//
//  Created by Micheal Bingham on 6/15/21.
//

import SwiftUI
import CoreData
import iPhoneNumberField
import Firebase
import FirebaseAuth
import PhoneNumberKit
import NavigationStack

@available(iOS 15.0, *)
struct EnterPhoneNumberView: View {
    
    @State var phone_number_field_text = "+15555555555"
    @State var isEditing = true
    
    //Goes to Verification Code Screen or back to Phone Number Screen
    @State private var shouldGoToVerifyCodeScreen = false
    
    //Prevents user from typing more digits
    @State private var shouldDisablePhoneTextField = false
    
    @State private var shouldGoToProfile = false
    
    

    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String  = ""
    
    @State  var beginAnimation: Bool = false
 
    @EnvironmentObject var navigation: NavigationModel


    static let id = String(describing: Self.self)

    var body: some View {
        
        
            
     NavigationStackView(EnterPhoneNumberView.id) {
            
            
            
            ZStack {
                
                
                // ******* ======  Transitions -- Navigation Links =======
                // Goes to Enter Verification Code View
                
                NavigationLink(destination: VerificationCodeView(), isActive: $shouldGoToVerifyCodeScreen){ EmptyView() }
                
                
            
                // Set the background, along with other base properties to set about the view
                Background()
                    .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
                  
                
                
                    
                
                VStack(alignment: .leading) {
                    
                    
                    Spacer()
                    
                    HStack(alignment: .top){
                        
                        backButton()
                        Spacer()
                        title()
                        Spacer()
                    }.offset( y: -45)
                    
                    Spacer()
                    makePhoneNumberField()
                    Spacer()
                    Spacer()
                    
                    
                    
                }
                
                
            }
            
            
    }
   
       
        
    } // End of View 
    
    
    
    
    
    
    
    

    
    
    func makePhoneNumberField() -> some View {
        
        // Phone Number Field
        // Used an external framework iPhoneNumberField
        // Because it's easier to format numbers this way
       return iPhoneNumberField("(000) 000-0000", text: $phone_number_field_text, isEditing: $isEditing)
            .flagHidden(false)
            .flagSelectable(true)
            .font(UIFont(size: 30, weight: .bold, design: .rounded))
            .prefixHidden(false)
            .autofillPrefix(true)
            .formatted(false)
            .disabled(shouldDisablePhoneTextField)
            .clearsOnInsert(true)
            .clearButtonMode(.whileEditing)
            .onEdit { numfield in
                
                
                userEnteredPhoneNumberAction(number: numfield.phoneNumber)
                
                
                
            }

        
    }

    
    
    /// Left Back Button
    func backButton() -> some View {
        
       return Button {
            
            goBack()
            
        } label: {
            
             Image("RootView/right-arrow")
                .resizable()
                .scaledToFit()
                .rotationEffect(.degrees(180))
                .offset(x: beginAnimation ? 7: 0)
                .frame(width: 33, height: 66)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: beginAnimation)
            
            
              
        }

       
            
            
            
    }
  
    /// Goes to the next screen / view
    func goToNextView()  {
        
    }
    
    /// Goes back to the login screen
    func goBack()   {
        
        navigation.hideViewWithReverseAnimation(RootView.id)
    }
    
    /// Title of the view text .
    func title() -> some View {
        
        return Text("What is your Phone Number?")
            .foregroundColor(.white)
            .font(.largeTitle)
            .bold()
            .offset(x: -40)
           
            
    }
    
    
    
    
    
    
    
    
    
    // ===********************************************************** // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\//\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\/
    
    
    
    
    
    
    
    
    
    
    
    
    // // /// // /// /// / /// /// =================  /// // Functionality  // //  /// =============================
    
        // Put all code relevant to functionality of the app/UI here. Such as sending verification codes or responding to user taps and thigns  like that.
    
    func userEnteredPhoneNumberAction(number: PhoneNumber?)  {
        
        // A valid phone number was entered
        if let phoneNumber = number{
            
            
            shouldDisablePhoneTextField = true
            shouldGoToVerifyCodeScreen = true
            
            Account().sendVerificationCode(to: phoneNumber.numberString) { error in
                
                guard error == nil else {
                    
                    someErrorOccured = true
                    shouldDisablePhoneTextField = false
                    isEditing = true
                    handle(error: error!)
                    
                    return
                }
                
                
            }
            
            
            
        }
    }
    
    
    
    
    
    
    
    // // /// // /// /// / /// /// =================  /// // ENnd of  Functionality  // //  /// =============================
    
    
    
    
    
    
    func handle(error: Error)  {
        
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
struct EnterPhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        NavigationView {
            Group {
                EnterPhoneNumberView().preferredColorScheme(.dark)
            }
        }
        
    }
}
