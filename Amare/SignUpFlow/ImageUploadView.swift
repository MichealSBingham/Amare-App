//
//  ImageUploadView.swift
//  Love
//
//  Created by Micheal Bingham on 7/2/21.
//

import SwiftUI
import NavigationStack


@available(iOS 15.0, *)
struct ImageUploadView: View {
    
    /// To manage navigation
    @EnvironmentObject private var navigationStack: NavigationStack

    /// id of view
    static let id = String(describing: Self.self)
    
    @EnvironmentObject private var account: Account
    
    
   // @State private var goToNext: Bool = false
    
    
    @State var showImagePicker: Bool = false
    
    @State var image: UIImage?

    //@State var profileimage: UIImage?
    
    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String  = ""
    
    @State private var beginAnimation: Bool = false
    
    var body: some View {
        
        
      
        
                
                let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()

             
               
                    
                
                
                
                VStack {
                    
                   
                    Spacer()
                    
                    HStack(alignment: .top){
                        
                        backButton()
                        Spacer()
                        title()
                        Spacer()
                        
                    }.offset(y: -45)
                    
                    Spacer()
                    
                    pickProfileImageButton()
                    Spacer()
                    Spacer()
                    
                    nextButton()
                    
                   
                    
                        }.alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
                        .onReceive(timer) { _ in  withAnimation { beginAnimation.toggle() }; timer.upstream.connect().cancel()}
                        .sheet(isPresented: $showImagePicker) {
                            ImagePickerView(sourceType: .photoLibrary) { image in
                                self.image = image
                            }
                        
                
        
        
    }
    
    }

    
    
    

    
    ///
    func pickProfileImageButton() -> some View {
        
        return Button {
            
            showImagePicker = true
            
        } label: {
            
            ZStack{
                
                Group{
                    
                    Image("ImageUploadView/emptyprofilepic")
                    Image(systemName: "person")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 120, height: 120, alignment: .center)
                }.opacity(self.image == nil ? 1: 0)
               
                
                selectedUIImage()
                    

            }
        }

         
        
    }
    
    /// The user's selected profile pic UI Image View
    func selectedUIImage() -> some View {
        
        Image(uiImage: image ?? UIImage(systemName: "person")!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .opacity(image != nil ? 1: 0)
            .frame(width: 250, height: 250)
    }
    

    func title() -> some View {
        
    
        
        return Text("Upload Profile Image")
            .foregroundColor(.white)
            .font(.largeTitle)
            .bold()
            .offset(x: 12)
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
        
        //navigation.hideViewWithReverseAnimation(ImageUploadView.id)
        
    }
    
    /// Goes to the next screen /
    func goToNextView()  {
       
        guard image != nil else {
            return 
        }
        
        navigationStack.push(ProfileView().environmentObject(account))
       
    }
    
    func nextButton() -> some View {
        
        return  Button {
           
            
            account.upload(image: image!, isProfileImage: true) { error in
                
                if let error = error{
                

                    handle(error)
                }
                goToNextView()
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
    
}


@available(iOS 15.0, *)
struct ImageUploadView_Previews: PreviewProvider {
    static var previews: some View {
        ImageUploadView().preferredColorScheme(.dark).environmentObject(Account())
            //.environmentObject(NavigationModel())
    }
}
