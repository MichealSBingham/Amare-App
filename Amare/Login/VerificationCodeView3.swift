//
//  VerificationCodeView3.swift
//  VerificationCodeView3
//
//  Created by Micheal Bingham on 8/30/21.
//



import SwiftUI
import NavigationStack
import MbSwiftUIFirstResponder
import Combine


public struct VerificationCodeView3: View {
    
    
    /// id of view
    static let id = String(describing: Self.self)

    /// To manage navigation
    @EnvironmentObject private var navigationStack: NavigationStack

    
    /// The current user's account
    @State private var account: Account = Account()
    
    
    var maxDigits: Int = 6
    var label = "Enter One Time Password"
    
    @State var pin: String = ""
    @State var showPin = false
    @State var isDisabled = false
    
    @State var beginAnimation = false
    @State var resendCodeAnimation = false
    
    
    enum FirstResponders: Int {
            case verificationCodeField
        }
    @State var firstResponder: FirstResponders?// = .verificationCodeField
    
    @State var someErrorOccured: Bool = false
    @State var alertMessage: String = ""
    
    @State var attempts: Int = 0
    
    @State var alreadyRan: Bool = false
    
    @State var phonenumber: String = ""
    
    @State var canResendCode: Bool = true
    
    @State var secondsToWait: Int = 10
    
    @State var timerisrunning: Bool = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State private var isLoading: Bool = true
    @State private var buttonDisabled: Bool = false
    
    public var body: some View {
        ZStack {
            
            Background()
                .opacity(isLoading ? 1: 0)
                .animation(.linear, value: phonenumber)
                .onAppear(perform: {buttonDisabled = false})
            
            ProgressView("Please wait...")
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .opacity(isLoading ? 1: 0)
                .foregroundColor(.white)
                .onReceive(Just(phonenumber)) { _ in
                    
                    if !phonenumber.isEmpty{
                        AmareApp().delay(2) {
                            isLoading = false
                            firstResponder = .verificationCodeField
                        }
                    }
                }
            
            VStack {
                
                backButton()
        
                EnterTheCode()//.opacity(isLoading ? 0: 1)
                SentToYourPhone()//.opacity(isLoading ? 0: 1)
                Spacer()
                lineoftext()
                Spacer()
                ZStack {
                    pinDots
                    backgroundField
                }
                showPinStack
                
                ZStack{
                    
                    resendCodeButton()
                    
                    Text("Please Wait ... \(secondsToWait)")
                        .foregroundColor(.white)
                        .padding()
                        .opacity(canResendCode ? 0: 1)
                        .onReceive(timer, perform: { _ in
                            guard timerisrunning else {return}
                            secondsToWait -= 1
                            if secondsToWait == 0 {
                                canResendCode = true
                                stopCountdown()
                                secondsToWait = 10
                            }
                        })
                    
                        
                        
                }
                
                
                Spacer()
            }
        
            .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
    // TODO: Publish the error message with the notification so that the user sees a pop up if an error occurs and then it goes back
      .onReceive(NotificationCenter.default.publisher(for: NSNotification.goBack)) { _ in

         goBack()
  }
        }
        .brightness(isLoading ? -0.5 : 1)
        .animation(.linear, value: phonenumber)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.verificationCodeSent)) { output in
                
            // Verification code was sent
            if let num = output.object as? String {
                
                phonenumber = num
                
            }
            
        }
        
        
    }
    
    
    private var pinDots: some View {
        HStack {
            Spacer()
            ForEach(0..<maxDigits) { index in
                Image(systemName: self.getImageName(at: index))
                    .font(.system(size: 25, weight: .thin, design: .default))
                    .foregroundColor(.white)
                    .modifier(ShakeEffect(shakes: attempts*2)).animation(Animation.default, value: attempts)
                Spacer()
            }
        }.opacity(isLoading ? 0: 1)
    }
    
    private var backgroundField: some View {
        let boundPin = Binding<String>(get: { self.pin }, set: { newValue in
            self.pin = newValue
            self.submitPin()
        })
        
        return TextField("", text: boundPin, onCommit: submitPin)
            .firstResponder(id: FirstResponders.verificationCodeField, firstResponder: $firstResponder, resignableUserOperations: .none)
           .accentColor(.clear)
           .foregroundColor(.clear)
           .keyboardType(.numberPad)
           .disabled(isLoading)
           .opacity(isLoading ? 0: 1)
          
           
    }
    
    private var showPinStack: some View {
        HStack {
            Spacer()
            if !pin.isEmpty {
                showPinButton
            }
        }
        .frame(height: 50)
        .padding([.trailing])
        .opacity(isLoading ? 0: 1)
    }
    
    private var showPinButton: some View {
        Button(action: {
            self.showPin.toggle()
        }, label: {
            self.showPin ?
                Image(systemName: "eye.slash.fill").foregroundColor(.white) :
                Image(systemName: "eye.fill").foregroundColor(.white)
        })
    }
    
    private func submitPin() {
        guard !pin.isEmpty else {
            showPin = false
            return
        }
        
        if pin.count == maxDigits {
           // isDisabled = true
            
            guard alreadyRan == false else {return}
            
            alreadyRan = true
                
            account.login(with: pin) { error, user, signUpState in
                
                guard error == nil else {
                    
                    alreadyRan = false
                    pin = ""
                    handle(error!)
                    
                    
                    return
                }
                  goToNext(signUpDataIsComplete: account.data?.isComplete() ?? false)
                
                
                return
                
                
            }
            
            
            
        }
        
        // this code is never reached under  normal circumstances. If the user pastes a text with count higher than the
        // max digits, we remove the additional characters and make a recursive call.
        if pin.count > maxDigits {
            pin = String(pin.prefix(maxDigits))
            submitPin()
        }
    }
    
    private func getImageName(at index: Int) -> String {
        if index >= self.pin.count {
            return "circle"
        }
        
        if self.showPin {
            return self.pin.Digits[index].NumberString + ".circle"
        }
        
        return "circle.fill"
    }
    
    func EnterTheCode() -> some View  {
        return Text("Enter the Code")
            .bold()
            .font(.system(size: 40))
            .foregroundColor(.white)
            
    }
    
    func SentToYourPhone() -> some View  {
        return Text("Sent to Your Phone")
            .bold()
            .font(.system(size: 40))
            .foregroundColor(.white)
            
    }
    
    func lineoftext() -> some View {
        
        let number = phonenumber.applyPatternOnNumbers(pattern: "+ # (###) ###-####", replacementCharacter: "#")
        
        return Text("We sent you an SMS with a code to\n\(number)")
            .foregroundColor(.white)
            .padding()
            .multilineTextAlignment(.center)
            .opacity(isLoading ? 0: 1)
    }
    
    /// Button for resending verification code
    func resendCodeButton() -> some View {
        return Button {
            
            canResendCode = false
            startCountdown()
            alertMessage = ""

            withAnimation {resendCodeAnimation.toggle()}
            
            guard  !(phonenumber.isEmpty) else {
                // Some error happened
                someErrorOccured = true
                alertMessage = "Please enter a phone number"
                return
            }
            
            Account().sendVerificationCode(to: phonenumber) { error in
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
                    
            }.opacity(canResendCode ? 1: 0)
             .disabled(!canResendCode)
             .opacity(isLoading ? 0: 1)
        }
    }
    
    func backButton() -> some View {
        
        return HStack{ Button {
            buttonDisabled = true
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
        .disabled(buttonDisabled)
            Spacer()
            
        }

       
            
            
            
    }
    
    /// Goes back to the login screen
    func goBack()   {
        
        print("going back...")
            firstResponder = nil
            navigationStack.pop()
    
        
    
        
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
            someErrorOccured = true
        }
        
        
        // Handle Error
        
    }
    
    func goToNext(signUpDataIsComplete: Bool = false)  {
        
        
        guard signUpDataIsComplete else {
           
            navigationStack.push(EnterNameView().environmentObject(account), withId: EnterNameView.id)
            return
        }
    
            
        navigationStack.push(MainView(isRoot: false).environmentObject(account), withId: MainView.id)
        
       
    }
    
    /// Starts the countdown from 10 seconds before user can resend code again
    func startCountdown() {
        
        timerisrunning = true
    }
    
    func stopCountdown(){
        timerisrunning = false 
    }
}


extension String {
    
    var Digits: [Int] {
        var result = [Int]()
        
        for char in self {
            if let number = Int(String(char)) {
                result.append(number)
            }
        }
        
        return result
    }
    
}

extension Int {
    
    var NumberString: String {
        
        guard self < 10 else { return "0" }
        
        return String(self)
    }
}




struct VerificationCodeView3_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack{
            let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()
            Background(timer: timer)//.opacity(0.80)
            VerificationCodeView3()
                .environmentObject(Account())
        }
        
        
    }
}
