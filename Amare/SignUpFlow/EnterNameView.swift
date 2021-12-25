//
//  EnterNameView.swift
//  Love
//
//  Created by Micheal Bingham on 6/19/21.
//

import SwiftUI
import NavigationStack


struct EnterNameView: View {
    
    /// To manage navigation
    @EnvironmentObject private var navigationStack: NavigationStack
    
    /// id of view
    static let id = String(describing: Self.self)
    
    @EnvironmentObject private var account: Account
    
    @ObservedObject var settings = Settings.shared
    
    @State   var name: String = ""
    @State private var goToNext: Bool = false
    
   
    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String  = ""
    
    @State private var beginAnimation: Bool = false
    @State private var beginAnimation2: Bool = false
    
    @State private var buttonIsDisabled: Bool = false

    
    //@FocusState var isFocused: Bool
    enum FirstResponders: Int {
            case name
        }
    @State var firstResponder: FirstResponders? = .name
    
    
    var body: some View {
       

        
            
                    
                VStack{
                        
                
                    ZStack{
                        
                        backButton()
                        createLogo()
                    }
                    
                    Spacer()
                   
                    title().padding()
                    
               
                    
                   Text("Enter your name below")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                    
               
                    
                    enterNameField().padding()
                    nextButton()
                    
                    Spacer()
                 
                        
                    Spacer()
                       
         
                        
                    }
                .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
                //.onReceive(timer) { _ in  withAnimation { beginAnimation.toggle() }; timer.upstream.connect().cancel()}
                .onAppear { withAnimation {beginAnimation = true} ; settings.viewType = .EnterNameView; doneWithSignUp(state: false) }

                
                        
                    
            
               
            
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
    
    func enterNameField() -> some View {
        
        return    TextField("Micheal S. Bingham", text: $name, onCommit:  {
            
            guard !buttonIsDisabled else {
                return
            }
            
            buttonIsDisabled = true
            guard !(name.isEmpty) else{
                
                // User entered an empty name
               buttonIsDisabled = false
                return
            }
            
         
          
            name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            
            account.data = AmareUser(id: account.user?.uid ?? "", name: name)
            
            do{
                try account.save(completion: { error in
                    guard error == nil else {
                        buttonIsDisabled = false
                        return
                    }
                   // firstResponder = nil 
                    goToNextView()
                })
            } catch (let error){
                buttonIsDisabled = false
                handle(error)
                return
            }
            
           
            
        })
            .firstResponder(id: FirstResponders.name, firstResponder: $firstResponder, resignableUserOperations: .none)
        .font(.largeTitle)
       // .focused($isFocused)
      //  .onAppear { AmareApp().delay(0.10, completion: {isFocused=true}) }
        

    }
    
    /// Title of the view text .
    func title() -> some View {
        
        return Text("Who are you?")
            .bold()
            .font(.system(size: 50))
            .foregroundColor(.white)
    }
    
    /// Goes back to the login screen
    func goBack()   {
    
        
        
        account.signOut { error in
            
            guard error == nil else { return }
            
                firstResponder = nil
                navigationStack.pop(to: .previous)
            
           
            return
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
                .onAppear { withAnimation { beginAnimation = true } }
            
              
        }.disabled(buttonIsDisabled)
            Spacer()
            
        }

       
            
            
            
    }
    
    
    /// Right Back Button
    func nextButton() -> some View {
        
        return Button {
            
            buttonIsDisabled = true
                
                guard !(name.isEmpty) else{
                    
                    // User entered an empty name
                   buttonIsDisabled = false
                    return
                }
                
             
              
                name = name.trimmingCharacters(in: .whitespacesAndNewlines)
                
                account.data = AmareUser(id: account.user?.uid ?? "", name: name)
           
                
                do{
                    try account.save(completion: { error in
                        guard error == nil else {
                            buttonIsDisabled = false
                            return
                        }
                        firstResponder = nil
                        goToNextView()
                    })
                } catch (let error){
                    buttonIsDisabled = false
                    handle(error)
                    return
                }
                
               
                
            
            
        } label: {
            
             Image("RootView/right-arrow")
                .resizable()
                .scaledToFit()
                .frame(width: 33, height: 66)
                .offset(x: beginAnimation2 ? 10: 0)
                .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: beginAnimation2).onAppear {
                    AmareApp().delay(0.5) {
                        withAnimation {
                            beginAnimation2 = true
                        }
                    }
                }
               
                
            
              
        }.disabled(buttonIsDisabled)

       
            
            
            
    }
    
    /// Comes back to this view since an error occured.
    /// - Deprecated
    func comeBackToView()  {
        
        
    }
    
    /// Goes to the next screen / view,. Verification Code Screen
    func goToNextView()  {
        
        
        navigationStack.push(EnterUsernameView().environmentObject(account))
        
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
    
    

    
    

}




// Previewing in canvas 

struct EnterNameView_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack{
            let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()
            Background(timer: timer)//.opacity(0.80)
            EnterNameView().environmentObject(Account())
                .preferredColorScheme(.dark)
                //.environmentObject(NavigationModel())
        }
            
        
        
    }
}
