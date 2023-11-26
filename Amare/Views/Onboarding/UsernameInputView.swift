//
//  UsernameInputView.swift
//  Amare
//
//  Created by Micheal Bingham on 6/9/23.
//

import SwiftUI
import FirebaseFirestore

struct UsernameInputView: View {
    
    @EnvironmentObject var model: OnboardingViewModel
    
    @EnvironmentObject var authService: AuthService

    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var dataModel: UserProfileModel
    
    //@State var username: String = ""
	
	
    @State var someErrorOccured: Bool = false
	@State var errorMessage: String = ""
    
    enum FirstResponders: Int {
            case username
        }
    
    @State var firstResponder: FirstResponders? = .username
    
    
    
    
    
    var body: some View {
        
        VStack{
            
            
            
            
            
            Spacer()
           
        
                Text("Choose Your Stardust Alias")
                    .multilineTextAlignment(.center)
                    .bold()
                    .font(.system(size: 50))  // was 50
                //.lineLimit(1)
                //.minimumScaleFactor(0.01)
                    .padding()
                    .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(errorMessage)) })
           
       
            
           Text("Enter a username")
                .font(.system(size: 20))
                //.foregroundColor(.white)
                .padding()
            
       
            ZStack{
                
                enterUsernameField().padding()
                    .onChange(of: model.username) { newValue in
                        
                        model.isUsernameAvailable = nil
                        //TODO: complete the function for checking username availability
                        
                        guard !(model.username.isEmpty) else {
                            //TODO: Tell the user to enter a username
                            return
                        }
                        
                        model.checkUsername()
                    }
                
                HStack{
                    
                    Spacer()
                    
                    if !(model.username.isEmpty){
                        UsernameAvailabilityView(isUsernameAvailable: $model.isUsernameAvailable)
                    }
                    
                }
                
            }
            
			NextButtonView {
                
     
                guard let id = authService.user?.uid else {
                    
                    self.errorMessage = "You are not signed in. Quit the app."
                    self.someErrorOccured = true
                    return
                }
                model.createUser(forUser: id) { result in
                    
                    switch result{
                    case .success():
                        withAnimation{
                            authService.isOnboardingComplete = true
                            print("Onboarding is finished should go to home screen now.")
                            viewRouter.screenToShow = .home
                            
                        }
                        //model.error = err
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        self.someErrorOccured = true

                    }
                }
                
                
			}
			.opacity(model.isUsernameAvailable ?? false ? 1: 0.5)
			.disabled(!(model.isUsernameAvailable ?? false))
            
            Spacer()
         
                
            Spacer()
            
            KeyboardPlaceholder()
 
                
            }
        
    }
    
    
    func enterUsernameField() -> some View {
		
		let binding = Binding<String>(
			get: { self.model.username },
			set: {
				if let firstCharacter = $0.first, firstCharacter.isNumber {
					// Don't update the username if the first character is a number
					return
				}
				self.model.username = ($0.filter { $0.isLetter || $0.isNumber }).lowercased()
			}
		)

        
        //TODO: Make sure there is an '@' in front of it.
        return    TextField("@starsystem2", text: binding,
                            
              onCommit:  {
            
            //TODO: Ensure that this code can only be executed once when they press return
                            
            
                                guard (model.isUsernameAvailable ?? false) else {
                                    
                                    // Username is not available so show a message saying so
                                    return
                                }
            
            
            guard let id = authService.user?.uid else {
                
                self.errorMessage = "You are not signed in. Quit the app."
                self.someErrorOccured = true
                return
            }
            
            
            model.createUser(forUser: id) { result in
                
                print("creating the user model.createUser... ")
                switch result{
                case .success():
                    withAnimation{
                        authService.isOnboardingComplete = true
                        print("Onboarding is finished should go to home screen now.")
                        
                        viewRouter.screenToShow = .home
                        
                    }
                    //model.error = err
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("failed to create user \(error)")
                    self.someErrorOccured = true

                }
            }
                                
                                
                                
            
           
    
            
          
          
            
          
            
        } )
            .firstResponder(id: FirstResponders.username, firstResponder: $firstResponder, resignableUserOperations: .none)
        .font(.largeTitle)
		.alert("Error", isPresented: Binding<Bool>(
					get: { model.error != nil },
					set: { _ in model.error = nil }
				)) {
					Button("OK", role: .cancel) { model.error = nil; }
				} message: {
					Text(model.error?.localizedDescription ?? "")
				}
		
    
      

    }

	/*
	func handleError(_ error: Error) {
		if let firestoreError = error as NSError? {
			// Log the Firestore error
			print("Firestore Error: \(firestoreError.localizedDescription)")
			
			// Handle specific Firestore errors based on the error code or domain
			switch firestoreError.code {
			case FirestoreErrorCode.unknown.rawValue:
				
				// Handle the unknown error case
				// Display an appropriate error message or take necessary action
			case FirestoreErrorCode.permissionDenied.rawValue:
				// Handle the permission denied error case
				// Display an appropriate error message or take necessary action
			case FirestoreErrorCode.notFound.rawValue:
				// Handle the document not found error case
				// Display an appropriate error message or take necessary action
			case FirestoreErrorCode.unavailable.rawValue:
				// Handle the unavailable (loss of internet connection) error case
				// Display an appropriate error message or take necessary action
			// Add more cases as needed
				
			default:
				// Handle other Firestore error codes
				// Display a generic error message or take necessary action
			}
		} else {
			// Handle other types of errors as needed
		}
	}
*/
    
}

struct UsernameInputView_Previews: PreviewProvider {
    static var previews: some View {
        
        
            UsernameInputView()
			.environmentObject(OnboardingViewModel())
        
       
    }
}






