//
//  EnterNameView.swift
//  Love
//
//  Created by Micheal Bingham on 6/19/21.
//

import SwiftUI
import NavigationStack

@available(iOS 15.0, *)
struct EnterNameView: View {
    
    /// To manage navigation
    @EnvironmentObject var navigation: NavigationModel
    
    /// id of view
    static let id = String(describing: Self.self)
    
    @EnvironmentObject private var account: Account
    
    @State  private var name: String = ""
    @State private var goToNext: Bool = false
    
   
    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String  = ""
    
    @State private var beginAnimation: Bool = false
    
    
    var body: some View {
       

            
        NavigationStackView(EnterNameView.id) {
            
            ZStack{
                    
                let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()

             
                Background()
                    .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
                    .onReceive(timer) { _ in  withAnimation { beginAnimation.toggle() }; timer.upstream.connect().cancel()}
                    
                    
                VStack(alignment: .leading){
                        
                    Spacer()
                    
                    HStack(alignment: .top){
                        
                        backButton()
                        Spacer()
                        title()
                        Spacer()
                        
                    }.offset(y: -45)
                    
                        Spacer()
                    
                    enterNameField().padding()
                        
                        Spacer()
                        Spacer()
         
                        
                    }
                    
                    
                        
                    
                   
                    
                    
                    
                } .onAppear {
                    doneWithSignUp(state: false)
            }
        }
            
          
            
  
            

    }
    
    
    func enterNameField() -> some View {
        
        return    TextField("Micheal S. Bingham", text: $name, onCommit:  {
            
            guard !(name.isEmpty) else{
                
                // User entered an empty name
                print("Name is empty")
                return
            }
            
            // Go to next page
            goToNextView()
            
            var userdata = UserData(id: account.user?.uid ?? "")
            userdata.name = name
            
            account.set(data: userdata) { error in
                
              
                
                guard error == nil else {
                    // There is some error
                
                   comeBackToView()
                    return
                }
                
               
            }
            
        })
        .font(.largeTitle)
        

    }
    
    
    
    
    /// Title of the view text .
    func title() -> some View {
        
        return Text("What is your name?")
            .foregroundColor(.white)
            .font(.largeTitle)
            .bold()
            .offset(x: -20)
    }
    
    /// Goes back to the login screen
    func goBack()   {
        
        account.signOut { error in
            
            guard error == nil else { return }
            navigation.hideViewWithReverseAnimation(RootView.id)
            return
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
                .offset(x: beginAnimation ? 7: 0, y: -10)
                .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: beginAnimation)
                .onAppear { withAnimation { beginAnimation = true } }
                
            
              
        }

       
            
            
            
    }
    
    /// Comes back to this view since an error occured.
    func comeBackToView()  {
        
        navigation.hideViewWithReverseAnimation(EnterNameView.id)
        
    }
    
    /// Goes to the next screen / view,. Verification Code Screen
    func goToNextView()  {
        
        
        let animation = NavigationAnimation(
            animation: .easeInOut(duration: 0.8),
            defaultViewTransition: .static,
            alternativeViewTransition: .opacity
        )
        
        navigation.showView(EnterNameView.id, animation: animation) { EnterGenderView().environmentObject(navigation)
                            .environmentObject(account)
            

            
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





// Previewing in canvas 
@available(iOS 15.0, *)
struct EnterNameView_Previews: PreviewProvider {
    static var previews: some View {
        
       
            EnterNameView().environmentObject(Account())
                .preferredColorScheme(.dark)
                .environmentObject(NavigationModel())
        
        
    }
}
