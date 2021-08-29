//
//  SignInOrUpView2.swift
//  Amare
//
//  Created by Micheal Bingham on 8/19/21.
//

import SwiftUI
import PhoneNumberKit
import UIKit
import MbSwiftUIFirstResponder
import NavigationStack
import Combine

struct EnterPhoneNumberView2: View {
    
    @EnvironmentObject private var navigationStack: NavigationStack
    @State private var shouldGoToNext: Bool = false
    
    @EnvironmentObject private var account: Account

    
    /// Without country code
    @State private var phonenumber = ""
    
    @State private var phonenumberFieldIsActive: Bool = true
    
    /// Assuming user is in america
    @State private var countrycode: String = "+1"
    
    @State private var didTapChangeCountry: Bool = false
    
    
    enum FirstResponders: Int {
            case phonenumberfield
        }
    @State var firstResponder: FirstResponders? = .phonenumberfield
    
    @State var beginAnimation: Bool = false
    
    
    
    var body: some View {
        
        ZStack{
            
            let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()
            Background(timer: timer)//.opacity(0.80)
            
           

            VStack{
                
               backButton()
                
                
                
                Spacer()
                
                EnterYour()
                PhoneNumber()
                StandardMessagingRatesMayApply().padding()
                
                Group{
                Spacer()
                countrySelect()
                Spacer()
                }
                
                phoneNumberField()
                    
                Spacer()
                Spacer()
              
                
                
                     
                
                    
                
            }
        }.onAppear{}
        
    }
    
    
    func EnterYour() -> some View  {
        return Text("Enter Your")
            .bold()
            .font(.system(size: 40))
            .foregroundColor(.white)
            
    }
    
    func PhoneNumber() -> some View  {
        
        return Text("Phone Number")
            .bold()
            .font(.system(size: 40))
            .foregroundColor(.white)
    }
    
    func StandardMessagingRatesMayApply() -> some View  {
        
        return Text("Standard messaging and data rates may apply.")
            .font(.system(size: 15))
            .foregroundColor(.white)
    }
    
    func countrySelect() -> some View {
        
        return Button {
            
            didTapChangeCountry = true
            goBack()
            
        } label: {
            
            Text("United States")
                .font(.system(size: 20))
                .foregroundColor(.white)
        }

            
        
    }
    
    
    func phoneNumberField() -> some View {
        
        return         HStack{
            
            // Flag
                
                Button {
                    didTapChangeCountry = true
                } label: {
                    Image("EnterPhoneNumberView/americanflag")
                }
                .padding(.leading, 25)
                
                // Country Code
                Text(countrycode)
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .padding(.trailing, 15)
                
                
                Image("EnterPhoneNumberView/Line")

                
                
            TextField("212 444 2222", text: $phonenumber)
                   .firstResponder(id: FirstResponders.phonenumberfield, firstResponder: $firstResponder,
                                   resignableUserOperations: .none)
                   .disabled(!phonenumberFieldIsActive)
                    .font(.system(size: 28 ))
                    .foregroundColor(.white)
                    .padding()
                    .keyboardType(.phonePad)
                    .onReceive(Just(phonenumber)) { _ in
                        
                        
                        phonenumber =   phonenumber.applyPatternOnNumbers(pattern: "(###) ### ####", replacementCharacter: "#")
                        
                        let number_to_check = phonenumber.computerReadable(countryCode: countrycode)

                        
                        if number_to_check.isValidPhoneNumber(){
                            phonenumberFieldIsActive = false
                            print("\(phonenumber) is a valid number because \(number_to_check) is ")
                            
                            guard !shouldGoToNext else {return }
                            account.sendVerificationCode(to: number_to_check) { error in
                                
                                guard error == nil else {
                                    
                                    phonenumber = ""
                                    phonenumberFieldIsActive = true
                                    firstResponder = .phonenumberfield
                                    return
                                }
                                
                                if error == nil {shouldGoToNext = true }
                                goToNextView()
                            }
                            
                            
                        } else { print("\(number_to_check) is NOT valid number") }
                        
                        
                    
                    }
                    
                    
                    
                 
                
                
                
            }
            

    }
    
    
    /// Goes back to the login screen
    func goBack()   {
        
       
            firstResponder = nil
            navigationStack.pop()
    
        
    
        
    }
    
    
    func goToNextView()  {
      
        guard shouldGoToNext else {return }
        self.navigationStack.push(VerificationCodeView2().environmentObject(account))
        
        
    }
    
    /// Left Back Button
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
    
}

struct SignInOrUpView2_Previews: PreviewProvider {
    static var previews: some View {
        EnterPhoneNumberView2().onAppear(perform: {
            
        })
    }
}




extension Binding {
    /// Execute block when value is changed.
    ///
    /// Example:
    ///
    ///     Slider(value: $amount.didSet { print($0) }, in: 0...10)
    func didSet(execute: @escaping (Value) ->Void) -> Binding {
        return Binding(
            get: {
                return self.wrappedValue
            },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
}


extension String {
    
    /// -  WARNING: Does not work for international numbers , need a better phone number validator
    func isValidPhoneNumber() -> Bool {
        if self.count < 12 { return false }
        let regEx = "^\\+(?:[0-9]?){6,14}[0-9]$"

        let phoneCheck = NSPredicate(format: "SELF MATCHES[c] %@", regEx)
        return phoneCheck.evaluate(with: self)
    }
    
    
    /// Converts a formatted number to a number computer can read (917) 699 0590  ~> +19176990590. The country code is selected from the View and not included in 'self'
    func computerReadable(countryCode: String) -> String {
        
        var number_to_check = (countryCode+self)
        number_to_check =  String(number_to_check.filter { !" \n\t\r".contains($0) })
         number_to_check = number_to_check.replacingOccurrences(of: ")", with: "")
        number_to_check = number_to_check.replacingOccurrences(of: "(", with: "")
        
        return number_to_check

        
    }
    
    /// Formats phone number and returns string of formatted number
    func applyPatternOnNumbers(pattern: String, replacementCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }

    
    
}

