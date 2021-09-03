//
//  EnterOrientationView.swift
//  Love
//
//  Created by Micheal Bingham on 7/6/21.
//

import SwiftUI
import NavigationStack
import Combine

struct EnterOrientationView: View {
    
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
    
    @State private var likesMen: Bool = false {
        didSet{
            
            userSelectedSomething = true
        }
    }
    @State private var likesWomen: Bool = false {
        didSet{
            
            userSelectedSomething = true
        }
    }
    @State private var tappedMore: Bool = false
    
    @State private var userSelectedSomething: Bool = false
    
    

    
    @State private var allattractedto: String = "What all are you attracted to?"
    
    var body: some View {
        
      
                
             

             
                   

            
                VStack{
                    
                    ZStack{
                        
                        backButton()
                        createLogo()
                    }
                    
                 
            
                    
                    Spacer()
                    
                    title().padding()
                    
                   // Spacer()
                    
                    Text(allattractedto)
                        // .bold()
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .onReceive(Just(userSelectedSomething)) { _ in
                            
                            var genders_selected = ""
                            
                            if likesMen {
                                genders_selected += "Men "
                            }
                            
                            if likesWomen {
                                genders_selected += "Women"
                            }
                            
                            guard !genders_selected.isEmpty else {return}
                            
                            // more than one was selected 
                            if (likesMen && likesWomen) {
                                
                                allattractedto  = genders_selected.replacingOccurrences(of: " ", with: " and ")
                                
                            } else {
                                allattractedto = genders_selected
                            }
                            
                            

                        }
                        
                    
                    Spacer()
                    
                    
                    HStack(alignment: .center){
                        
                        MakeManButton().padding(.leading)
                        Spacer()
                        MakeWomanButton().padding()
                        Spacer()
                        MakeOtherButton().padding(.trailing)
                        
                        
                    }
                    
                    
                    Spacer()
                    Spacer()
                 
                   nextButton()

                } .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
        
            .alert(isPresented: $tappedMore) {
                Alert(title: Text("TODO: Allow more genders"), message: Text("This is not finished yet, but it will allow you to select additional genders"))
            }
            .onAppear(perform: {settings.viewType = .EnterOrientationView})
                
               
              
                
                
            }
        
       
        
        
        
        
        
        
    
    
    
    
    
    
    
    // ======================================================================================


    func MakeManButton() -> some View  {
      
        return Button {
            
            likesMen.toggle()
            
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
                
                Text("Men")
                    .foregroundColor(.white)
                    .shimmering()
                    
            }
            
            
            
        }.opacity(likesMen ? 0.3 : 1)
            

    }

    func MakeWomanButton() -> some View {
        
        return Button {
            
            likesWomen.toggle()
            
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
                
                Text("Women")
                    .foregroundColor(.white)
                    .shimmering()

            }
            
                        
        }.opacity(likesWomen ? 0.2: 1)
       
    }


    /// Once this button is tapped, the user should be able to enter their own custom gender
    func MakeOtherButton() -> some View  {
        
        return Button {
            
            tappedMore.toggle()
            
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
            
            
        }.opacity(tappedMore ? 0.3: 1)
    }




    // ======================================================================================




   /* func SelectGenderAction(gender: String)  {
        
      goToNextView()
        
        self.account.data?.sex = gender
        
        do{
            
            try account.save()
            
        } catch (let error){
            
            // Handle Error //
            
            comeBackToView()
            
            handle(error)
            
            // Handle Error //
        }
        
            
        
        
    } */




    /// Title of the view text .
    func title() -> some View {
        
        let gender = account.data?.sex ?? .non_binary
        
        return Text("I am *\(gender.string())* and I like...")
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
                
            
              
        }; Spacer();  }

       
            
            
            
    }
    
    /// Comes back to this view since an error occured.
    func comeBackToView()  {
        
        //navigation.hideViewWithReverseAnimation(EnterOrientationView.id)
        
    }
    
    /// Goes to the next screen / view,. Verification Code Screen
    func goToNextView()  {
        
        navigationStack.push(FromWhereView().environmentObject(account), withId: FromWhereView.id)
        
    }
    
    func nextButton() -> some View {
        
        return  Button {
            // Goes to next screen
            
            guard likesMen == true || likesWomen == true else {
                //user needs to tap at least one before going to next screen
                return
            }
            
            
            
            
            var orientation: String  = ""
            if likesMen { orientation += "M" }
            if likesWomen { orientation += "W"}
                //orientation = orientation.sorted()
            
            account.data?.orientation = orientation
            
            do {
                try account.save(completion: { error in
                    
                    guard error == nil else {
                        return
                    }
                    goToNextView()
                })
                
            } catch (let error) {
                
                    handle(error)
            }
            
            
        } label: {
            
            Spacer()
            
            Text("Next")
                .foregroundColor(.white)
                .font(.system(size: 23))
                
            
            Image("RootView/right-arrow")
               .resizable()
               .scaledToFit()
               .frame(width: 33, height: 66)
               .offset(x: beginAnimation ? 10: 0, y: 0)
               .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: beginAnimation)
               .onAppear { withAnimation { beginAnimation = true } }
            
            Spacer()
            
               
        }.opacity( (likesMen == false  && likesWomen == false ) ? 0.5 : 1.0 )
    }


    func handle(_ error: Error)  {
        
       
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
    
}












struct EnterOrientationView_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack{
            Background()
            EnterOrientationView().environmentObject(Account())
        }
           

       
    }
}
