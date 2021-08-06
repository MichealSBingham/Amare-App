import SwiftUI
import Firebase
import NavigationStack


///I**IMPORTANT *********
/// **FILE IS LIKELY NOT NEEDED BUT I HAVEN'T DELETED IT YET BECAUSE I THINK
///  **THERE IS AN EXTENSION HERE THAT IS USED ELSEHWERE IN THE CODE
///  **
@available(iOS 15.0, *)
public struct VerificationCodeView: View {

/// State variable for when there is a successful sign in
    @State var goToProfile: Bool = false

    @State private var account: Account = Account()
    
    
    
    /// Sign Up States to go to if user did not finish sign up flow
    @State private var goToEnterNameView: Bool = false
   // @State private var goToEnterBirthdayView: Bool = false
    @State private var goToEnterGenderView: Bool = false
    @State private var goToEnterOrientationView: Bool = false
    @State private var goToFromWhereView: Bool = false
    @State private var goToLiveWhereView: Bool = false
    @State private var goToImageUploadView: Bool = false

    
// Part of VerificationCodeView UI
var maxDigits: Int = 6
var label = "Enter One Time Password"
@State var pin: String = ""
@State var showPin = true
//@FocusState private var isFocused: Bool


    
    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String  = ""


    @EnvironmentObject var navigation: NavigationModel

    
public var body: some View {
    
    
  
        
        ZStack {
            
            
                //.alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
             
            
            
            
            // ******* ======  Transitions -- Navigation Links =======
            
            // Goes to the Profile
            NavigationLink(
                destination: ProfileView().environmentObject(account),
                isActive: $goToProfile)
                {  EmptyView()  }
            
            
            
 //\\//\\///\\/\/\/\/\/\\/\/\/\  GOES TO PROPER PAGE IN SIGN UP FLOW IF USER DID NOT FINISH SIGN UP
            //\\//\\///\\/\/\/\/\/\\/\/\/\
            NavigationLink(
                destination: EnterNameView().environmentObject(account),
                isActive: $goToEnterNameView)
                {  EmptyView()  }
            
                //Do not need to go here
                /*  NavigationLink(
                destination: EnterBirthdayView().environmentObject(account),
                isActive: $goToEnterBirthdayView)
                {  EmptyView()  } */
            
            NavigationLink(
                destination: EnterGenderView().environmentObject(account),
                isActive: $goToEnterGenderView)
                {  EmptyView()  }
            
            NavigationLink(
                destination: EnterOrientationView().environmentObject(account),
                isActive: $goToEnterOrientationView)
                {  EmptyView()  }
            
            NavigationLink(
                destination: FromWhereView().environmentObject(account),
                isActive: $goToFromWhereView)
                {  EmptyView()  }
            
            NavigationLink(
                destination: LiveWhereView().environmentObject(account),
                isActive: $goToLiveWhereView)
                {  EmptyView()  }
            
            NavigationLink(
                destination: ImageUploadView().environmentObject(account),
                isActive: $goToImageUploadView)
                {  EmptyView()  }
            
            
            // ******* ================================ **********

            
            VStack {
                
                
                ZStack {
                    pinDots
                    backgroundField
                }
            }
            
            
        }
    
    
        
        
        
    
    
}
    
private var pinDots: some View {
    HStack {
        Spacer()
        ForEach(0..<maxDigits) { index in
            Image(systemName: self.getImageName(at: index))
                .font(.system(size: 50, weight: .thin, design: .default))
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
    
    return TextField("", text: boundPin, onCommit: submitPin)
        .accentColor(.clear)
        .foregroundColor(.clear)
        .keyboardType(.numberPad)
        .textContentType(.oneTimeCode)
        //.focused($isFocused)
        
    
    
}


private var showPinButton: some View {
    Button(action: {
        self.showPin.toggle()
      //  if (pin.isEmpty){isFocued = true}
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
            
            goToRightViewFrom(signUpState)
            
            
            
            
            
        }
        

            
        }

                                               
       
        }
        
        
      
        
    
    func goToRightViewFrom(_ signUpState: SignUpState?)  {
        
        switch signUpState{
        case .name:
            goToEnterNameView = true
        case .sex:
            goToEnterGenderView = true
        case .orientation:
            goToEnterOrientationView = true
        case .hometown:
            goToFromWhereView = true
        case .birthday:
            goToFromWhereView = true // don't go to birthday view because it has to get the time zone from the LiveWhereView and then pass it to the next view
        case .residence:
            goToLiveWhereView = true
        case .imageUpload:
            goToImageUploadView = true
        case .none:
            goToProfile = true
        case .done:
            goToProfile = true
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

@available(iOS 15.0, *)
struct VerificationCodeView_Previews: PreviewProvider {
    static var previews: some View {
        //maxDigits =  Set According to your condition
        //label =  Set Title
        //Pin Count
        NavigationView{
            
            VerificationCodeView().preferredColorScheme(.dark)
        }
        
    }
}



extension String {
var digits: [Int] {
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

var numberString: String {
    
    guard self < 10 else { return "0" }
    
    return String(self)
   }
}
