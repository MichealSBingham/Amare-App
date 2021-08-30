//
//  VerificationCodeView3.swift
//  VerificationCodeView3
//
//  Created by Micheal Bingham on 8/30/21.
//



import SwiftUI
import NavigationStack
import MbSwiftUIFirstResponder
// import Introspect


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
    
    
    enum FirstResponders: Int {
            case verificationCodeField
        }
    @State var firstResponder: FirstResponders? = .verificationCodeField
    
    
  //  var handler: (String, (Bool) -> Void) -> Void
    
    public var body: some View {
        VStack {
            
            backButton()
    
            EnterTheCode()
            SentToYourPhone()
            
            lineoftext()
            
            ZStack {
                pinDots
                backgroundField
            }
            showPinStack
        }
        
    }
    
    private var pinDots: some View {
        HStack {
            Spacer()
            ForEach(0..<maxDigits) { index in
                Image(systemName: self.getImageName(at: index))
                    .font(.system(size: 25, weight: .thin, design: .default))
                    .foregroundColor(.white)
                Spacer()
            }
        }
    }
    
    private var backgroundField: some View {
        let boundPin = Binding<String>(get: { self.pin }, set: { newValue in
            self.pin = newValue
            self.submitPin()
        })
        
        return TextField("", text: boundPin, onCommit: submitPin)
            .firstResponder(id: FirstResponders.verificationCodeField, firstResponder: $firstResponder)
           .accentColor(.clear)
           .foregroundColor(.clear)
           .keyboardType(.numberPad)
           .disabled(isDisabled)
           
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
            isDisabled = true
            
            /*
            handler(pin) { isSuccess in
                if isSuccess {
                    print("pin matched, go to next page, no action to perfrom here")
                } else {
                    pin = ""
                    isDisabled = false
                    print("this has to called after showing toast why is the failure")
                }
            }
            */
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
        
        let number = (account.phoneNumber ?? "+19176990590").applyPatternOnNumbers(pattern: "+ # (###) ###-####", replacementCharacter: "#")
        
        return Text("We sent you an SMS with a code to the number\n \(number)")
            .foregroundColor(.white)
            .padding()
            .multilineTextAlignment(.center)
    }
    
    func backButton() -> some View {
        
        return HStack{ Button {
            
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
            Spacer()
            
        }

       
            
            
            
    }
    
    
    /// Goes back to the login screen
    func goBack()   {
        
       
            firstResponder = nil
            navigationStack.pop()
    
        
    
        
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
        }
        
    }
}
