//
//  SignInOrUpView2.swift
//  Amare
//
//  Created by Micheal Bingham on 8/19/21.
//

import SwiftUI

import UIKit
import MbSwiftUIFirstResponder
import Combine

struct InputPhoneNumber: View {
    
	@EnvironmentObject var background: BackgroundViewModel
	
	@EnvironmentObject var model: OnboardingViewModel
	
	@EnvironmentObject var authService: AuthService
	
    
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
    
    /// The view has an error of going to the next view multiple times this is a solution to correct it
    @State var timesExecuted: Int = 0
    
    @State var someErrorOccured: Bool = false
    @State var alertMessage: String = ""
    
    @State private var buttonDisabled: Bool = false
    
    var body: some View {
        
        ZStack{
            
           
            
           

            VStack{
                
                
                    
                   
                               
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
					.onAppear{
						//firstResponder = .phonenumberfield
					}
                    
                Spacer()
                Spacer()
                
                KeyboardPlaceholder()
              
                
                
                     
                
                    
                
            }.alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
			/*
			 New Error Method ... might noe need to implement this.
				.alert("Error", isPresented: Binding<Bool>(
							get: { model.error != nil },
							set: { _ in model.error = nil }
						)) {
							Button("OK", role: .cancel) { model.error = nil; }
						} message: {
							Text(model.error?.localizedDescription ?? "")
						}
			 */
        }
        
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
    
    //TODO: Make country code selectable
    func countrySelect() -> some View {
        
        return Button {
            
            didTapChangeCountry = true
			
			//TODO: REMOVE THIS FROM PRODUCTINO
			//authService.signOut()
           // goBack()
            
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
                           // phonenumberFieldIsActive = false
                            
							//model.phoneNumber = number_to_check
                            
                            guard timesExecuted == 0 else {return}
                            
                            timesExecuted+=1
                            
                            
							
							authService.sendVerificationCode(to: number_to_check) {  result in
								
								model.phoneNumber = number_to_check
								
								switch result {
								case .success(let success):
									print("Send verification code to \(number_to_check)")
									goToNextView()
								case .failure(let failure):
									
									DispatchQueue.main.async {
										phonenumber = ""
										phonenumberFieldIsActive = true
										firstResponder = .phonenumberfield
										timesExecuted = 0
										
				
											handle(error: failure)
									
										
										
									}
									
								}
								
							}
                            
						
                            
                        } else { print("\(number_to_check) is NOT valid number") }
                        
                        
                    
                    }
                    
                    
                    
                 
                
                
                
            }
            

    }
    
    
    /// Goes back to the login screen
    func goBack()   {
        
       print("Going backwards...")
            firstResponder = nil
           // navigationStack.pop()
    
        
    
        
    }
    
    
    func goToNextView()  {
      
		withAnimation {
			model.currentPage = .authCode
		}
      
        
    }
    
    /// Left Back Button
    func backButton() -> some View {
        
        return HStack{ Button {
			
			
            buttonDisabled = true
            goBack()
            buttonDisabled = false
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
    
    /// Creates the logo for the view
    func createLogo() -> some View {
        
        /// The molecule (center) part of the logo (image)
         func moleculeImage() -> some View {
            
            return Image("branding/molecule")
                 .resizable()
                .scaledToFit()
                .frame(width: 35, height: 29.5)
               
        }
        
        /// The ring part of the logo (Image)
         func ringImage() -> some View {
            
            return Image("branding/ring")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            
               
        }
        
        ///The horizontal  part of the cross that's a part of the logo
         func horizontalCrossImage() -> some View {
            
            return Image("branding/cross-h")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 3)
                .offset(y: 44)
        }
        
        /// The verticle part of the cross that's a part of the logo
         func verticleCrossImage() -> some View {
            
            return Image("branding/cross-v")
                .resizable()
                .scaledToFit()
                .frame(width: 3.5, height: 28)
                .offset(x: 0, y: 38)  // was -8
                
                
        }
        
        
        return Group{
            ZStack{ ringImage() ; moleculeImage()  }
            ZStack{ verticleCrossImage() ; horizontalCrossImage() }
        }
            .offset(y: beginAnimation ? -15: 0 )
            .animation(.easeInOut(duration: 2.25).repeatForever(autoreverses: true), value: beginAnimation)
            .onAppear(perform: {  withAnimation{beginAnimation = true}})

    }
    
    
    func handle(error: Error)  {
                // Handle Error
        someErrorOccured = true
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
        
        
       
        
    }
    
}

struct InputPhoneNumber_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            
            let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()
            Background(timer: timer)//.opacity(0.80)
				.environmentObject(BackgroundViewModel())
            InputPhoneNumber().onAppear(perform: {
                
            })
			.environmentObject(AuthService.shared)
			.environmentObject(OnboardingViewModel())
			.environmentObject(BackgroundViewModel())
        }
       
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




