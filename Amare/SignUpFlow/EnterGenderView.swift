//
//  EnterGenderView.swift
//  Love
//
//  Created by Micheal Bingham on 7/6/21.
//

import SwiftUI
import NavigationStack
import Shimmer



struct EnterGenderView: View {
    
    /// To manage navigation
    @EnvironmentObject private var navigationStack: NavigationStack
    
    /// id of view
    static let id = String(describing: Self.self)
    
    @ObservedObject var settings = Settings.shared

    
    @EnvironmentObject private var account: Account
    @State private var goToNext: Bool = false
    
    @State private var alertMessage: String = ""
    @State private var someErrorOccured: Bool = false
    @State private var beginAnimation: Bool = false
    
   // @State private var showTodoMessage: Bool = false
    
    @State private var showMoreGenders: Bool = false
    
    @State private var buttonIsDisabled: Bool = false
    
    
    var body: some View {
        
    
            

             
                    
            
                VStack{
                    
                    ZStack{
                        
                        backButton()
                        
                        createLogo()
                    }
                    
                    Spacer()
                    
                    title().padding()
                    
                    Text("What do you identify as?")
                        // .bold()
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    
                    Spacer()
                    ZStack{
                        
                        // Man and Woman Options
                        HStack(alignment: .center) {
                            
                            Spacer()
                            MakeManButton().padding()
                            Spacer()
                            MakeWomanButton().padding()
                            Spacer()
                            
                            
                        }.opacity(showMoreGenders == false ? 1: 0)
                        
                        
                        // Transgender Man, Transgender Woman, Non-Binary options
                        HStack(alignment: .center){
                            
                            MakeTManButton().padding(.leading)
                            Spacer()
                            MakeTWomanButton()//.padding()
                            Spacer()
                            MakeNonBinaryPersonButton().padding(.trailing)
                            
                            
                        }.opacity(showMoreGenders ? 1 : 0 )
                        
                    }
                   
            
                  
                    
                    HStack(alignment: .center){
                        
                   
                        MakeMoreButton().padding(.trailing)
                        
                        
                    }
                
                    Spacer()
                       
                    
                    Spacer()
                 
                    
                }.alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
             /*   .alert(isPresented: $showTodoMessage) {
                    Alert(title: Text("TODO: Allow more genders"), message: Text("This is not finished yet, but it will allow you to select additional genders"))
 
                } */
                .onAppear(perform: {settings.viewType = .EnterGenderView})

                
              
                
                
            
        
       
        
        
        
        
        
        
    }
    
    
    
    
    
    
    // ======================================================================================


    func MakeManButton() -> some View  {
      
        
        return Button {
            buttonIsDisabled = true
            SelectGenderAction(gender: .male)
            
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
            
            
            
        }.disabled(buttonIsDisabled)
            

    }
    
    func MakeTManButton() -> some View  {
      
        
        return Button {
            buttonIsDisabled = true
            SelectGenderAction(gender: .transmale)
            
        } label: {
            
            VStack{
                
            
                
                ZStack{
                    
                    Image("EnterGenderView/circle3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .opacity(0.2)
                     
                        
                    /// TODO: replace with transgender male
                    Image("EnterGenderView/mars")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        
                    
                }
                
                Text("Transmale")
                    .foregroundColor(.white)
                    .shimmering()
            }
            
            
            
        }.disabled(buttonIsDisabled)
            

    }

    func MakeWomanButton() -> some View {
        
        return Button {
            buttonIsDisabled = true
            SelectGenderAction(gender: .female)
            
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
            
                        
        }.disabled(buttonIsDisabled)
       
    }

    func MakeTWomanButton() -> some View {
        
        return Button {
            buttonIsDisabled = true
            SelectGenderAction(gender: .transfemale)
            
        } label: {
            
            VStack{
                
                ZStack{
                    
                    Image("EnterGenderView/circle-2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                      
                        //.opacity(0.2)
                    
                    /// TODO: replace sign
                    Image("EnterGenderView/venus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        
                    
                }
                
                Text("Transfemale")
                    .foregroundColor(.white)
                    .shimmering()

            }
            
                        
        }.disabled(buttonIsDisabled)
       
    }
    
    func MakeNonBinaryPersonButton() -> some View {
        
        return Button {
            buttonIsDisabled = true
            SelectGenderAction(gender: .transfemale)
            
        } label: {
            
            VStack{
                
                ZStack{
                    
                    Image("EnterGenderView/circle-2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                      
                        //.opacity(0.2)
                    
                    /// TODO: replace sign
                    Image("EnterGenderView/venus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        
                    
                }
                
                Text("Non Binary")
                    .foregroundColor(.white)
                    .shimmering()

            }
            
                        
        }.disabled(buttonIsDisabled)
       
    }

    /// Once this button is tapped, the user should be able to enter their own custom gender
    func MakeMoreButton() -> some View  {
        
        
        return Button {
            
            withAnimation(.easeInOut){
                showMoreGenders.toggle()
            }
            
            
            
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




    func SelectGenderAction(gender: Sex)  {
        
     
        
        self.account.data?.sex = gender
        
        do{
            
            try account.save(completion: { error in
                guard error == nil else{
                    buttonIsDisabled = false
                    return 
                }
                goToNextView()
            })
            
        } catch (let error){
            
            // Handle Error //
            
            
            buttonIsDisabled = false 
            handle(error)
            
            // Handle Error //
        }
        
            
        
        
    }




    /// Title of the view text .
    func title() -> some View {
        
        let name = account.data?.name?.components(separatedBy: " ").first ?? "No Name"
        
        return Text("Hey \(name).")
            .bold()
            .font(.system(size: 50))
            .foregroundColor(.white)
    }
    
    /// Goes back to the login screen
    func goBack()   {
        
        navigationStack.pop()
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
                .offset(x: beginAnimation ? 15: 0, y: -10)
                .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: beginAnimation)
                .onAppear { withAnimation { beginAnimation = true } }
                //.padding()
            
              
        }.disabled(buttonIsDisabled)
            Spacer()
            
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












struct EnterGenderView_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack{
            Background()
            EnterGenderView().environmentObject(Account())
        }
           
                //.environmentObject(NavigationModel())
    
       
    }
}
