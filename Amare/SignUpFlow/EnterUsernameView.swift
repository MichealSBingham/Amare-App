//
//  EnterUsernameView.swift
//  Amare
//
//  Created by Micheal Bingham on 10/17/21.
//

import SwiftUI
import NavigationStack
import Combine

struct EnterUsernameView: View {
    
    /// To manage navigation
    @EnvironmentObject private var navigationStack: NavigationStack
    
    /// id of view
    static let id = String(describing: Self.self)
    
    @EnvironmentObject private var account: Account
    
    @ObservedObject var settings = Settings.shared
    
  //  @State   var username: String = ""
    @State private var goToNext: Bool = false
    
    /// When this is false, we will go back to EnterNameView
    @Binding  var showThisView: Bool
    
   
    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String  = ""
    
    @State private var beginAnimation: Bool = false
    @State private var beginAnimation2: Bool = false
    
    @State private var buttonIsDisabled: Bool = false
    
    @State var isUniqueUsername: Bool = false
	
	@State var usernameIsSelected: Bool = false
    
    
    enum FirstResponders: Int {
            case username
        }
    @State var firstResponder: FirstResponders? = .username
    
   
    //TODO: Don't allow users to enter '@' symbol at all (low priority, but enhancement to make soon) 
    class UsernameValidator: ObservableObject {

        @Published var text = ""

    }
    
    
    @ObservedObject var username = UsernameValidator()
    
    @State var message: String = "Enter a name."
    
    var body: some View {
        VStack{
            
            ZStack{
                backButton()
                createLogo()
            }
            
            Spacer()
            
            title().padding()
            
            Text(message)
                 .font(.system(size: 20))
                 .foregroundColor(.white)
                 .padding()
            
          
            enterUsernameField().padding()
            
            ZStack{
                
                nextButton()
                    .opacity(isUniqueUsername ? 1: 0 )
                ProgressView()
                    .preferredColorScheme(.dark)
                    .opacity(isUniqueUsername ? 0: 1)
                    
            }
          
            
            Spacer()
         
                
            Spacer()
            
        }
    }
    
    /// Left Back Button
    func backButton() -> some View {
        
        return HStack { Button {
            buttonIsDisabled = true
            goBack()
            
        } label: {
            
             Image("RootView/right-arrow")
                .resizable()
                .scaledToFit()
                .rotationEffect(.degrees(180))
                .frame(width: 33, height: 66)
                .offset(x: beginAnimation ? 7: 0, y: -10)
                .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: beginAnimation)
                .onAppear { withAnimation { beginAnimation = true }; doneWithSignUp(state: false) }
            
              
        }.disabled(buttonIsDisabled)
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
            .offset(y: beginAnimation ? 30: 0 )
            .animation(.easeInOut(duration: 2.25).repeatForever(autoreverses: true), value: beginAnimation)
            .onAppear(perform: {  withAnimation{beginAnimation = true}})

    }
    
    func goBack()   {
        
      
        withAnimation {
            showThisView = false
        }
    
    }
    
    /// Title of the view text .
    func title() -> some View {
        
        return Text("Pick a username.")
            .bold()
            .font(.system(size: 50))
            .foregroundColor(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.01)
    }
    

    
    func enterUsernameField() -> some View {
        
        return TextField("@you", text: $username.text,  onEditingChanged: {
            didChange in
            
            
              
            
            
        })
            .firstResponder(id: FirstResponders.username, firstResponder: $firstResponder, resignableUserOperations: .none)
        
            .onReceive(Just(username.text), perform: { newvalue in
                
                var value = ((newvalue.prefix(1) != "@") ? "@" : "")  + newvalue.lowercased().trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "").stripped
                if value != newvalue{
                    self.username.text = value
                    
                    
                }
                
                var nametolookfor:String  = username.text.replacingOccurrences(of: "@", with: "")
                    // see if it exists in database
                
                guard !nametolookfor.isEmpty else { isUniqueUsername = false; message = "Enter a username."; return }
                
                account.db?.collection("usernames").document(nametolookfor).getDocument(completion: { doc, error in
                    
                   
                    if (doc?.exists ??  false ) && !usernameIsSelected  {
                        print("\(nametolookfor) is not a unique username")
                        isUniqueUsername = false
                        message = "Try something unique. That's taken."
                    } else {
                        print("\(nametolookfor) is a a unique username")
                        isUniqueUsername = true
                        message = "That works!"
                        beginAnimation2 = true
                    }
                })
              
                
            })
        .font(.largeTitle)
        
        
        
        

    }
    
    /// Goes to the next screen / view,. Verification Code Screen
    func goToNextView()  {
        
        
        navigationStack.push(EnterGenderView().environmentObject(account))
        
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
        someErrorOccured = true
    }
    
    /// Right Back Button
    func nextButton() -> some View {
        
        return Button {
            
			usernameIsSelected = true
            buttonIsDisabled = true
                
            guard !(username.text.isEmpty) else{
                    
                    // User entered an empty name
                   buttonIsDisabled = false
                    return
                }
                
             
              
      
                
            var unique_username = username.text.replacingOccurrences(of: "@", with: "")
        
            
			Account.shared.signUpData.username = unique_username
			
			
			// TODO: Reserving the username... set GITHUB ticket.
			
			account.db?.collection("usernames").document(unique_username).setData(["userId": account.user?.uid ?? "", "username": unique_username, "isNotable": false], merge: true, completion: { error in
				
				guard error == nil else {
					buttonIsDisabled = false
					handle(error!)
					usernameIsSelected = false
					return
					
				}
				goToNextView()
				buttonIsDisabled = false
			})
			
			
			
                /*
                do{
                    try account.save(completion: { error in
                        guard error == nil else {
                            buttonIsDisabled = false
                            return
                        }
                       firstResponder = nil
                        
                        // Set the taken username in database
                        
                        
                        account.db?.collection("usernames").document(unique_username).setData(["userId": account.user?.uid ?? "", "username": unique_username, "isNotable": false], merge: true, completion: { error in
                            
                            guard error == nil else {
                                buttonIsDisabled = false
                                handle(error!)
                                return
                                
                            }
                            goToNextView()
                        })
                        
                       
                    })
                } catch (let error){
                    buttonIsDisabled = false
                    handle(error)
                    return
                }
                */
               
                
            
            
        } label: {
            
             Image("RootView/right-arrow")
                .resizable()
                .scaledToFit()
                .frame(width: 33, height: 66)
                .offset(x: beginAnimation2 ? 10: 0)
                .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: beginAnimation2).onAppear {
                    AmareApp().delay(1) {
                        withAnimation {
                            beginAnimation2 = true
                        }
                    }
                }
               
                
            
              
        }.disabled(buttonIsDisabled)

       
            
            
            
    }
   
    
}


extension String{
    
    var stripped: String {
            let okayChars = Set("@abcdefghijklmnopqrstuvwxyz")
            return self.filter {okayChars.contains($0) }
        }
    
    func isValidUserndame() -> Bool {
        
    
        
        return false
    }
    
    func isValidUsername() -> Bool {
        
        if self.isEmpty {return true }
        
        if self.prefix(1) != "@" {return false }
        
        var password = self
        password.removeFirst()
        
        // it should not have a capital letter
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        guard !texttest.evaluate(with: password) else { return false }

        /*
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        guard texttest1.evaluate(with: password) else { return false }
*/
        // Should not contain capital letters
        let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        
        guard !texttest2.evaluate(with: password) else { return false }

        return true
    }
    
    func makeValid() -> String {
        
        if self.prefix(1) != "@"{
            
            return "@" + self.stripped.lowercased()
        } else {
            return  self.stripped.lowercased()
        }
        
    }
}

struct EnterUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Background()
            EnterUsernameView( showThisView: .constant(false))
        }
       
    }
}
