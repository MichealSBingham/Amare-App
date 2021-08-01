//
//  EnterBirthdayView.swift
//  Love
//
//  Created by Micheal Bingham on 6/18/21.
//

import SwiftUI
import Firebase
import NavigationStack


@available(iOS 15.0, *)
struct EnterBirthdayView: View {
    
    /// To manage navigation
    @EnvironmentObject var navigation: NavigationModel
    
    /// id of view
    static let id = String(describing: Self.self)
    
    @EnvironmentObject private var account: Account
    
    @State private var goToNext: Bool = false 
    
    @State private var date = Date()
    
    @Binding public var timezone: TimeZone?
    
    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String  = ""
    
    @State private var beginAnimation: Bool = false
    
    var body: some View {
        
     
            
        NavigationStackView(EnterBirthdayView.id) {
            
            ZStack{
                    
                  
                    
                    
                let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()

             
                Background(timer: timer)
                    .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
                    
                    VStack{
                        
                        Spacer()
                        
                        DatePicker(selection: $date, in :...Date() , displayedComponents: [.date, .hourAndMinute], label: { Text("Birthday") }).datePickerStyle(.graphical).environment(\.timeZone, timezone!)
                        
                        
                        
                        Spacer()
                        
                        Button("Done") {
                            
                            
                            // Corrects the time zone of the date
                            
                                  
                            
                            
                            let bday = Birthday(timestamp: Timestamp(date: date), month: date.month(), day: date.day(), year: date.year())
                            
                            
                            account.data?.birthday = bday
                            
                            do {
                                
                                try account.save()
                                
                            } catch (let error){
                                
                                handle(error)
                            }
                          
                            
                        }
                        
                        Spacer()
                        Spacer()
                        Spacer()

                    }
                    
                    
                    
                    
                } .onAppear {
                    doneWithSignUp(state: false)
            }
        }
            
           
       
            
     
        
    }
    
    
    
    
    /// Title of the view text .
    func title() -> some View {
        
    
        
        return Text("When is your birthday?")
            .foregroundColor(.white)
            .font(.largeTitle)
            .bold()
            .offset(x: 12)
    }
    
    /// Goes back to the login screen
    func goBack()   {
        
        navigation.hideViewWithReverseAnimation(FromWhereView.id)
        
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
        
        navigation.hideViewWithReverseAnimation(EnterBirthdayView.id)
        
    }
    
    /// Goes to the next screen / view,. Verification Code Screen
    func goToNextView()  {
        
        
        let animation = NavigationAnimation(
            animation: .easeInOut(duration: 0.8),
            defaultViewTransition: .static,
            alternativeViewTransition: .opacity
        )
        
        navigation.showView(EnterBirthdayView.id, animation: animation) { LiveWhereView().environmentObject(navigation)
                            .environmentObject(account)
                        
            
        }
        
    }
    
    func handle(_ error: Error)  {
        someErrorOccured = true
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

    
    /*
    func nextButton() -> some View {
        
        return  Button {
            // Goes to next screen
          
            guard  let city = citiesSearchResult.first else {
                return
            }
            
            // Set timezone
            self.timezone = city.timeZone
            
            // Go to next
            goToNextView()
            
            
            account.data?.hometown = Place(latitude: city.placemark.coordinate.latitude, longitude: city.placemark.coordinate.longitude, city: city.placemark.city, state: city.placemark.state, country: city.placemark.country, geohash: city.placemark.geohash)
            
            do {
                
                try account.save()
                
            } catch (let error) {
                print("Got an error from where ... \(error)")
               comeBackToView()
                handle(error)
            }
            
            
        } label: {
            
           
                
            
            Image("RootView/right-arrow")
               .resizable()
               .scaledToFit()
               .frame(width: 33, height: 66)
               .offset(x: beginAnimation ? -15: 0, y: 0)
               .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: beginAnimation)
               .onAppear { withAnimation { beginAnimation = true } }
            
          
            
               
        }//.opacity( (likesMen == false  && likesWomen == false ) ? 0.5 : 1.0 )
    }
    */
    
    
    
}

@available(iOS 15.0, *)
struct EnterBirthdayView_Previews: PreviewProvider {
    
    
    static var previews: some View {
      
            EnterBirthdayView(timezone: .constant(TimeZone.current)).environmentObject(Account())
                .environmentObject(NavigationModel())
                .preferredColorScheme(.dark)
        
        
    }
}
