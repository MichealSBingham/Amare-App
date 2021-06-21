import SwiftUI
import Firebase



public struct VerificationCodeView: View {

/// State variable for when there is a successful sign in
    @State var goToProfile: Bool = false

    
// Part of VerificationCodeView UI
var maxDigits: Int = 6
var label = "Enter One Time Password"
@State var pin: String = ""
@State var showPin = true
    


    
    
public var body: some View {
    
    
  
        
        ZStack {
            
            Image("backgrounds/background1")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .navigationBarTitle("Enter Verification Code")
                .navigationBarColor(backgroundColor: .clear, titleColor: .white)
                
             
            
            
            
            // ******* ======  Transitions -- Navigation Links =======
            
            // Goes to the Profile
            NavigationLink(
                destination: ProfileView(),
                isActive: $goToProfile,
                label: {  EmptyView()  }
            )
            
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
                .font(.system(size: 60, weight: .thin, design: .default))
            Spacer()
        }
    }
}

private func getImageName(at index: Int) -> String {
    if index >= self.pin.count {
        return "square"
    }
    if self.showPin {
        return self.pin.digits[index].numberString + ".square"
    }
    return "square"
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
        
    
    
}


private var showPinButton: some View {
    Button(action: {
        self.showPin.toggle()
    }, label: {
        self.showPin ?
            Image(systemName: "eye.slash.fill").foregroundColor(.primary) :
            Image(systemName: "eye.fill").foregroundColor(.primary)
    })
}

    
    /// Called when pin is submitted
private func submitPin() {
    if pin.count == maxDigits {
        
        Account.login(with: pin) { error in
            
            // Could not Log in
            
        } afterSuccess: { user in
            
                // Successfully signed in
                goToProfile = true 
            
        } onFirstSignIn: {
            
            // 
        }

    
       
        }
        
        
      
        }
    
    
    
}

struct VerificationCodeView_Previews: PreviewProvider {
    static var previews: some View {
        //maxDigits =  Set According to your condition
        //label =  Set Title
        //Pin Count
        
        VerificationCodeView(maxDigits: 6, label: "Enter Verification Code", pin: "", showPin: true)
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
