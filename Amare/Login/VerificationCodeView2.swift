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
                    ZStack {
                        pinDots
                        backgroundField
                    }
                    
                    Button {
                        print("resend code")
                        withAnimation {resendCodeAnimation.toggle()}
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

                    Spacer()
                    Spacer()
                    
                    
                    
                }
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
    
  

    private var pinDots: some View {
        HStack {
            Spacer()
            ForEach(0..<maxDigits) { index in
                Image(systemName: self.getImageName(at: index))
                    .font(.system(size: 50, weight: .thin, design: .default))
                    .foregroundColor(.white)
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
                    someErrorOccured = true
                    
                    
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
