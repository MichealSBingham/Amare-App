//
//  ImageUploadView.swift
//  Love
//
//  Created by Micheal Bingham on 7/2/21.
//

import SwiftUI
import NavigationStack
import FirebaseStorage

struct ImageUploadView: View {
    
    /// To manage navigation
    @EnvironmentObject private var navigationStack: NavigationStack

    /// id of view
    static let id = String(describing: Self.self)
    
    @ObservedObject var settings = Settings.shared

    
    @EnvironmentObject private var account: Account
    
    
   // @State private var goToNext: Bool = false
    
    
    @State var showImagePicker: Bool = false
    
    @State var image: UIImage?

    //@State var profileimage: UIImage?
    
    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String  = ""
    
    @State private var beginAnimation: Bool = false
    @State private var tappedButton: Bool = false
    
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
                        .onAppear(perform: {settings.viewType = .ImageUploadView})
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
            .opacity(image != nil ? 1: 0)
            .frame(width: 250, height: 250)
            .clipShape(Circle())
            .shadow(radius: 10)
            .aspectRatio(contentMode: .fit)
            //.overlay(Circle().stroke(Color.red, lineWidth: 5))
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
       
		guard Account.shared.signUpData.isComplete() else {
			
			someErrorOccured = true
			alertMessage = "Please go back and complete signing up."
			return
		}
		
		account.data = Account.shared.signUpData
		
		do{
			try account.create()
				
			
			navigationStack.push(MainView( isRoot: false).environmentObject(account))

		} catch (let error) {
			
			print("Could not save the data for reason: \(error)")
			someErrorOccured = true
			alertMessage = "Something bad happened... try again?"
		}
		
       
    }
    
    func nextButton() -> some View {
        
        return  Button {
           
            tappedButton = true
            guard image != nil else {tappedButton = false; return}
            
            /*
            let storageRef = Storage.storage().reference()
            
            // Local file you want to upload
            let localFile = URL(string: "path/to/image")!

            // Create the file metadata
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"

            // Upload file and metadata to the object 'images/mountains.jpg'
            let uploadTask = storageRef.child("users").child(account.data?.id ?? "").putData((image?.pngData())!)
            
            //putFile(from: localFile, metadata: metadata)
            
            

            // Listen for state changes, errors, and completion of the upload.
            uploadTask.observe(.resume) { snapshot in
              // Upload resumed, also fires when the upload starts
            }

            uploadTask.observe(.pause) { snapshot in
              // Upload paused
            }

            uploadTask.observe(.progress) { snapshot in
              // Upload reported progress
              let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
                
                print("*** Completion : \(percentComplete)")
            }

            uploadTask.observe(.success) { snapshot in
              // Upload completed successfully
                print("success")
            }

            uploadTask.observe(.failure) { snapshot in
              if let error = snapshot.error as? NSError {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                  // File doesn't exist
                    print("*** Obejct doesn't exist ")
                  break
                case .unauthorized:
                  // User doesn't have permission to access file
                    print("*** Unauthorized ")
                  break
                case .cancelled:
                  // User canceled the upload
                    print("*** Cancelled ")
                  break

                /* ... */

                case .unknown:
                    print("*** Unknown answer ")
                  // Unknown error occurred, inspect the server response
                  break
                default:
                  // A separate error occurred. This is a good place to retry the upload.
                    print("Some other error happened .. \(error)")
                  break
                }
              }
            }
                
            */
            
            
            account.upload(image: image!, isProfileImage: true) { error in
                
                if let error = error{
                
                    tappedButton = false
                    handle(error)
                    return
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
               .onAppear { withAnimation { beginAnimation = true }; doneWithSignUp(state: false) }
            
            Spacer()
               
        }.disabled(tappedButton)
            .opacity(tappedButton ? 0: 1)
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



struct ImageUploadView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
        Background()
        ImageUploadView().preferredColorScheme(.dark).environmentObject(Account())
            //.environmentObject(NavigationModel())
        }
    }
}
