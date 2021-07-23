//
//  VerificationCodeView2.swift
//  Amare
//
//  Created by Micheal Bingham on 7/23/21.
//

import SwiftUI
import NavigationStack

@available(iOS 15.0, *)
struct VerificationCodeView2: View {
   // @FocusState private var isFocused: Bool

    /// id of view
    static let id = String(describing: Self.self)

    /// To manage navigation
    @EnvironmentObject var navigation: NavigationModel
    
    /// The current user's account
    @State private var account: Account = Account()
    
    /// When to start animation
    @State  var beginAnimation: Bool = false
    @State var resendCodeAnimation: Bool = false
    
    @State private var someErrorOccured: Bool = false
    /// Alert message for error
    @State private var alertMessage: String  = ""
    

    
    // Part of VerificationCodeView UI
    var maxDigits: Int = 6
    var label = "Enter One Time Password"
    @State var pin: String = ""
    @State var showPin = true
    
    /// Used to shake the field when there has been an invalid code entered
    @State var attempts: Int = 0


    
    var body: some View {
       
        NavigationStackView(VerificationCodeView2.id) {
            
            ZStack{
                
                let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()

             
                Background()
                    .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
                    .onReceive(timer) { _ in  withAnimation { beginAnimation.toggle() }; timer.upstream.connect().cancel()}
                    
                
                VStack(alignment: .leading) {
                    
                    
                    Spacer()
                    
                    HStack(alignment: .top){
                        
                        backButton()
                        Spacer()
                        title()
                        Spacer()
                    }.offset( y: -45)
                       
                    
                    Spacer()
                    
                    Text(attempts > 0 ? alertMessage : "")
                        .foregroundColor(.white)
                        .offset(x: 14)
                        .animation(.easeInOut(duration: 1), value: attempts)

                        
                    
                    ZStack {
                        verificationCodeField
                        backgroundField
                    }
                    
                    resendCodeButton()

                    Spacer()
                    Spacer()
                    
                    
                    
                }
            }
        }
    }
    
    /// Button for resending verification code
    func resendCodeButton() -> some View {
        return Button {
            
            alertMessage = ""

            withAnimation {resendCodeAnimation.toggle()}
            
            guard let number = String.getPhoneNumber() else {
                // Some error happened
                someErrorOccured = true
                alertMessage = "Please enter a phone number"
                return
            }
            
            Account().sendVerificationCode(to: number) { error in
                print("the second num is \(number)")
                guard error == nil else {
                    handle(error!)
                    return
                }
            }
            
        } label: {
            
            HStack{
                Text("Resend Code").padding()
                    .foregroundColor(.white)
                Image(systemName: "arrow.clockwise")
                    //.resizable()
                    .foregroundColor(.white)
                    .scaledToFit()
                    .rotationEffect(.degrees( (!resendCodeAnimation) ? 0: 360*3))
                    .animation(.easeInOut(duration: 1), value: resendCodeAnimation)
                    .offset(x: -14)
                    
            }
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
                .frame(width: 33, height: 66)
                .offset(x: beginAnimation ? 7: 0)
                .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: beginAnimation)
                .onAppear { withAnimation { beginAnimation = true } }
                
            
              
        }

       
            
            
            
    }
    
    /// Goes back to the login screen
    func goBack()   {
        
        navigation.hideViewWithReverseAnimation(EnterPhoneNumberView.id)
     
            
    }
    
    /// Title of the view text .
    func title() -> some View {
        
        return Text("What code was sent to your device?  ")
            .foregroundColor(.white)
            .font(.largeTitle)
            .bold()

            
    }
    
  

    private var verificationCodeField: some View {
        HStack {
            Spacer()
            ForEach(0..<maxDigits) { index in
                Image(systemName: self.getImageName(at: index))
                    .font(.system(size: 50, weight: .thin, design: .default))
                    .foregroundColor(.white)
                    .modifier(ShakeEffect(shakes: attempts*2)).animation(Animation.default, value: attempts)
                Spacer()
            }
        }
    }

    private func getImageName(at index: Int) -> String {
        if index >= self.pin.count {
            return "circle"
        }
        if self.showPin {
            return self.pin.digits[index].numberString + ".circle"
        }
        return "circle"
    }

    private var backgroundField: some View {
        let boundPin = Binding<String>(get: { self.pin }, set: { newValue in
            self.pin = newValue
            self.submitPin()
        })
        
        return SecureField("", text: boundPin, onCommit: submitPin)
            .accentColor(.clear)
            .foregroundColor(.clear)
            .keyboardType(.numberPad)
            .textContentType(.oneTimeCode)
            
          //  .focused($isFocused)
            
        
        
    }


    private var showPinButton: some View {
        Button(action: {
            self.showPin.toggle()
           // if (pin.isEmpty){ isFocused = true}
        }, label: {
            self.showPin ?
                Image(systemName: "eye.slash.fill").foregroundColor(.primary) :
                Image(systemName: "eye.fill").foregroundColor(.primary)
        })
    }

        
        /// Called when pin is submitted
    private func submitPin() {
        
        if pin.count == maxDigits {
            
            account.login(with: pin) { error, user, signUpState in
                
                guard error == nil else {
                    
                    
                    handle(error!)
                    
                    
                    return
                }
                
              goToNextView()
                
                
                
                
                
            }
            

                
            }

                                                   
           
            }
            
        
            
           
    func handle(_ error: Error)  {
        
        // Handle Error
        if let error = error as? AccountError{
            
            switch error {
            case .doesNotExist:
                alertMessage = "You do not exist."
                someErrorOccured = true
            case .disabledUser:
                alertMessage = "Sorry, your account is disabled."
                attempts+=1
            case .expiredVerificationCode:
                alertMessage = "Please resend your code because it expired."
                attempts+=1
            case .wrong:
                alertMessage = "You entered the wrong code."
                attempts+=1
            case .notSignedIn:
                alertMessage = "You are not signed in."
                someErrorOccured = true
            case .uploadError:
                alertMessage = "There was some upload Error"
                someErrorOccured = true
            case .notAuthorized:
                alertMessage = "You are not authorized to do this."
                attempts+=1
            case .expiredActionCode:
                alertMessage = "Please resend the code."
                attempts+=1
            case .sessionExpired:
                alertMessage = "Please resend the code, your session expired."
                attempts+=1
            case .userTokenExpired:
                alertMessage = "Please send the code, your token expired."
                attempts+=1
            }
        }
        
        if let error = error as? GlobalError{
            
            switch error {
            case .networkError:
                alertMessage = "There is a network error. Lost internet connection"
                someErrorOccured = true

            case .tooManyRequests:
                alertMessage = "Please wait a few moments. "
                attempts+=1
            case .captchaCheckFailed:
                alertMessage = "You might be a robot because you failed the captcha check and that's quite rare. Goodbye."
                someErrorOccured = true

            case .invalidInput:
                alertMessage = "You entered something wrong with the wrong format."
                someErrorOccured = true

            case .quotaExceeded:
                alertMessage = "Please wait a few moments. "
                attempts+=1
            case .notAllowed:
                alertMessage = "You are not allowed to do that."
                someErrorOccured = true

            case .internalError:
                alertMessage = "There was some internal error with us. Not your fault."
                someErrorOccured = true

            case .cantGetVerificationID:
                alertMessage = "This isn't an end-user error and you honestly should not be seeing this. If you did, something is broken. Report it to us because your verification ID is not being saved."
                someErrorOccured = true

            case .unknown:
                alertMessage = "I'm not sure what this error is, lol."
                someErrorOccured = true

            }
        }
        
        
        // Handle Error
        
    }
    
    
    func goToNextView()  {
        
    }
}

@available(iOS 15.0, *)

struct VerificationCodeView2_Previews: PreviewProvider {
    static var previews: some View {
        VerificationCodeView2()
            .environmentObject(NavigationModel())
    }
}
