//
//  EnterGenderView.swift
//  Love
//
//  Created by Micheal Bingham on 7/6/21.
//

import SwiftUI
import NavigationStack
import Shimmer


@available(iOS 15.0, *)
struct EnterGenderView: View {
    
    /// To manage navigation
    @EnvironmentObject private var navigationStack: NavigationStack
    
    /// id of view
    static let id = String(describing: Self.self)
    
    
    @EnvironmentObject private var account: Account
    @State private var goToNext: Bool = false
    
    @State private var alertMessage: String = ""
    @State private var someErrorOccured: Bool = false
    @State private var beginAnimation: Bool = false
    
    @State private var showTodoMessage: Bool = false
    
    
    
    var body: some View {
        
    
            
            
                
                let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()

             
                    
            
                VStack(alignment: .leading){
                    
                    Spacer()
                    
                    HStack(alignment: .top){
                        
                        backButton()
                        Spacer()
                        title()
                        Spacer()
                    }.offset(y: -45)
                    
                    Spacer()
                    
                    HStack(alignment: .center){
                        
                        MakeManButton().padding()
                        Spacer()
                        MakeWomanButton().padding()
                        Spacer()
                        MakeOtherButton().padding()
                        
                        
                    }
                    
                    Spacer()
                    Spacer()
                 
                    
                }.alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
                .onReceive(timer) { _ in  withAnimation { beginAnimation.toggle() }; timer.upstream.connect().cancel()}
                .alert(isPresented: $showTodoMessage) {
                    Alert(title: Text("TODO: Allow more genders"), message: Text("This is not finished yet, but it will allow you to select additional genders"))
                }

                
              
                
                
            
        
       
        
        
        
        
        
        
    }
    
    
    
    
    
    
    // ======================================================================================


    func MakeManButton() -> some View  {
      
        
        return Button {
            
            SelectGenderAction(gender: "M")
            
        } label: {
            
            VStack{
                
            
                
                ZStack{
                    
                    Image("EnterGenderView/circle3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .opacity(0.2)
                    
                    Image("EnterGenderView/mars")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        
                    
                }
                
                Text("Man")
                    .foregroundColor(.white)
                    .shimmering()
            }
            
            
            
        }
            

    }

    func MakeWomanButton() -> some View {
        
        return Button {
            
            SelectGenderAction(gender: "F")
            
        } label: {
            
            VStack{
                
                ZStack{
                    
                    Image("EnterGenderView/circle-2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        //.opacity(0.2)
                    
                    Image("EnterGenderView/venus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        
                    
                }
                
                Text("Woman")
                    .foregroundColor(.white)
                    .shimmering()

            }
            
                        
        }
       
    }


    /// Once this button is tapped, the user should be able to enter their own custom gender
    func MakeOtherButton() -> some View  {
        
        
        return Button {
            
            //SelectGenderAction(gender: "O")
            
                showTodoMessage = true
            
        } label: {
            
            VStack{
                ZStack{
                    
                    Image("EnterGenderView/circle3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .opacity(0.2)
                    
                    Text("...")
                        .foregroundColor(.white)
                        .font(.system(size: 55))
                        .offset(y: -15)
                        
                    
                }
                
                Text("More")
                    .foregroundColor(.white)
                    .shimmering()
            }
            
            
        }
    }




    // ======================================================================================




    func SelectGenderAction(gender: String)  {
        
     
        
        self.account.data?.sex = gender
        
        do{
            
            try account.save(completion: { error in
                guard error == nil else{
                    return 
                }
                goToNextView()
            })
            
        } catch (let error){
            
            // Handle Error //
            
            
            
            handle(error)
            
            // Handle Error //
        }
        
            
        
        
    }




    /// Title of the view text .
    func title() -> some View {
        
        return Text("I am a ...")
            .foregroundColor(.white)
            .font(.largeTitle)
            .bold()
            .offset(x: -40)
    }
    
    /// Goes back to the login screen
    func goBack()   {
        
        navigationStack.pop()
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
        
        //navigation.hideViewWithReverseAnimation(EnterGenderView.id)
        
    }
    
    /// Goes to the next screen / view,. Verification Code Screen
    func goToNextView()  {
        navigationStack.push(EnterOrientationView().environmentObject(account))
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











@available(iOS 15.0, *)
struct EnterGenderView_Previews: PreviewProvider {
    static var previews: some View {
        

            EnterGenderView().environmentObject(Account())
                //.environmentObject(NavigationModel())
    
       
    }
}
