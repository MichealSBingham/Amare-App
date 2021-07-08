//
//  ContentView.swift
//  Love
//
//  Created by Micheal Bingham on 6/15/21.
//

import SwiftUI
import CoreData
import iPhoneNumberField
import Firebase
import FirebaseAuth
import PhoneNumberKit

@available(iOS 15.0, *)
struct EnterPhoneNumberView: View {
    
    @State var phone_number_field_text = ""
    @State var isEditing = true
    
    //Goes to Verification Code Screen or back to Phone Number Screen
    @State private var shouldGoToVerifyCodeScreen = false
    
    //Prevents user from typing more digits
    @State private var shouldDisablePhoneTextField = false
    
    @State private var shouldGoToProfile = false
    
    

    @State private var someErrorOccured: Bool = false
 


    var body: some View {
        
        
            
       // NavigationView {
            
            
            
            ZStack {
                
                // ******* ======  Transitions -- Navigation Links =======
                // Goes to Enter Verification Code View
                
                NavigationLink(destination: VerificationCodeView(), isActive: $shouldGoToVerifyCodeScreen){ EmptyView() }
                
                
            
                // Set the background
                SetBackground()
                    .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text("Some Error Occured")) })
                
                
                
                
                VStack {
                    
                    
                    makePhoneNumberField()
                    
                    
                    
                }
                
                
            }
            
            
        //}
   
       
        
    } // End of View 
    
    
    
    
    
    
    
    
    
    
    
    
    
    // ===********************************************************** // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\//\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\/
    
    
    // ===********************************************************** // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\//\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\/
    
    
    // ===********************************************************** // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\//\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\/
    
    
    // ===********************************************************** // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\//\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\/
    
    
    
    
    
    
// // /// // /// /// / /// /// =================  /// // SETTING UP  Up UI // //  /// =============================
    // PUT ALL FUNCTIONS RELATED TO BUILDING THE UI HERE.
    
    /// Sets the background of the view
    /// - Returns: Image()  =
    func SetBackground() -> some View {
        
        // Background Image
        return Image("backgrounds/background1")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .navigationTitle("Phone Number")
            .navigationBarColor(backgroundColor: .clear, titleColor: .white)
        
     
    }
    
    
    
    func makePhoneNumberField() -> some View {
        
        // Phone Number Field
        // Used an external framework iPhoneNumberField
        // Because it's easier to format numbers this way
       return iPhoneNumberField("(000) 000-0000", text: $phone_number_field_text, isEditing: $isEditing)
            .flagHidden(false)
            .flagSelectable(true)
            .font(UIFont(size: 30, weight: .bold, design: .rounded))
            .prefixHidden(false)
            .autofillPrefix(true)
            .formatted(false)
            .disabled(shouldDisablePhoneTextField)
            .clearsOnInsert(true)
            .onEdit { numfield in
                
                
                userEnteredPhoneNumberAction(number: numfield.phoneNumber)
                
                
                
            }

        
    }

    
    
    
  
    
    // // /// // /// /// / /// /// =================  /// // End of Setting Up UI // //  /// =============================
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // ===********************************************************** // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\//\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\/
    
    
    
    
    
    
    
    
    
    
    
    
    // // /// // /// /// / /// /// =================  /// // Functionality  // //  /// =============================
    
        // Put all code relevant to functionality of the app/UI here. Such as sending verification codes or responding to user taps and thigns  like that.
    
    func userEnteredPhoneNumberAction(number: PhoneNumber?)  {
        
        // A valid phone number was entered
        if let phoneNumber = number{
            
            
            shouldDisablePhoneTextField = true
            shouldGoToVerifyCodeScreen = true
            
            
            
            
            Account().sendVerificationCode(to: phoneNumber.numberString,
                                           butIfSomeError: {  error in
                
                // An error happened after entering the phone number
                someErrorOccured = true
                
                print("\n\nThe error is : \(error)")
                
                // Enable the phone text field again
                shouldDisablePhoneTextField = false
                
                
                isEditing = true
                
                
                
                
            })
            
            
            
            
            
        }
    }
    
    
    
    
    
    
    
    // // /// // /// /// / /// /// =================  /// // ENnd of  Functionality  // //  /// =============================
    
    
    
    
    
    
    

    
}




@available(iOS 15.0, *)
struct EnterPhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        NavigationView {
            Group {
                EnterPhoneNumberView().preferredColorScheme(.dark)
            }
        }
        
    }
}
