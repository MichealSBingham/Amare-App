//
//  EnterBirthdayView.swift
//  Love
//
//  Created by Micheal Bingham on 6/18/21.
//

import SwiftUI
import Firebase
import NavigationStack



struct EnterBirthdayView: View {
    
    /// id of view
    static let id = String(describing: Self.self)
    
    /// To manage navigation
    @ObservedObject var settings = Settings.shared

    
    @EnvironmentObject private var account: Account
    
    @State private var goToNext: Bool = false 
    
    @State private var date = Date()
    
    public var timezone: TimeZone
    
    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String  = ""
    
    @State private var beginAnimation: Bool = false
    
    @State private var didTapNext: Bool = false
    
    @State private var knowsBirthTime = false

    
    var body: some View {
        
                    
                    VStack{
                        
                        
                        ZStack{
                            
                            backButton()
                            createLogo()
                        }
                        
                     
                
                        
                      //  Spacer()
                        
                        title().padding(.top, 55)
                        
                        Text("It is *very* important that you enter this correctly with your birth time.")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding()
                        
                        Toggle("I know my birth time", isOn: $knowsBirthTime).padding()
                        
                        
                        DatePicker(selection: $date, in :...Date().dateFor(years: -13) , displayedComponents: [.date, .hourAndMinute], label: { Text("Birthday") }).environment(\.timeZone, self.timezone)
                            .padding()
                    
                        
                    
                        Spacer()
                        
                        nextButton()
                        
                     
                      

                    }
                    .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
                    .alert(isPresented: $didTapNext) {
                       
                        
                        Alert(
                                        title: Text("Is this when you were born?"),
                                        message: Text("\(date.to(timezone: timezone))"),
                                        primaryButton: .default(Text("Yes")) {
                                            saveBirthdayAndGoToNextView()
                                        },
                                        secondaryButton: .destructive(Text("No"))
                                    )
                
                    }
                    .onAppear(perform: {settings.viewType = .EnterBirthdayView; doneWithSignUp(state: false)})
                    
                    
                    
                
        
            
           
       
            
     
        
    }
    
    
    
    func saveBirthdayAndGoToNextView()  {
        
        let bday = Birthday(timestamp: Timestamp(date: date), month: date.month(), day: date.day(), year: date.year())
		
		Account.shared.signUpData.birthday = bday
		Account.shared.signUpData.known_time = knowsBirthTime
		
		goToNextView()
        
       

    }
    
    /// Title of the view text .
    func title() -> some View {
        
    
        
        return Text("When is your birthday?")
            .foregroundColor(.white)
            .bold()
            .font(.system(size: 50))
            
    }
    
    /// Goes back to the login screen
    func goBack()   {
        //navigationStack.pop()

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
                .offset(x: beginAnimation ? 7: 0, y: -10)
                .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: beginAnimation)
                .onAppear { withAnimation { beginAnimation = true } }
                
            
              
        }; Spacer(); }

       
            
            
            
    }
    
    /// Comes back to this view since an error occured.
    func comeBackToView()  {
        
        //navigation.hideViewWithReverseAnimation(EnterBirthdayView.id)
        
    }
    
    /// Goes to the next screen / view,. Verification Code Screen
    func goToNextView()  {
        //navigationStack.push(SelectLocationForResidenceView().environmentObject(account))
        
       
    }
    
    func nextButton() -> some View {
        
        return  Button {
            // Goes to next screen
            
          didTapNext = true
            
            
            
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


struct EnterBirthdayView_Previews: PreviewProvider {
    
    
    static var previews: some View {
      
        ZStack{
            
           Background()
            EnterBirthdayView(timezone: TimeZone.current).environmentObject(Account())
                //.environmentObject(NavigationModel())
                .preferredColorScheme(.dark)
        }
           
        
        
    }
}


extension Date{
    func to(timezone: TimeZone) -> String {
         let formatter = DateFormatter()
         formatter.dateFormat = "cccc, MMMM d, YYYY h:m a vvvv"
         formatter.timeZone = timezone
         return formatter.string(from: self)
            
        }
}
