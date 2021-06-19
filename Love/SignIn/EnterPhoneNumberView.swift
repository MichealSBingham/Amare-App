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

struct EnterPhoneNumberView: View {
    
    @State  var phone_number_field_text = ""
    @State var isEditing = true
    
    //Goes to Verification Code Screen or back to Phone Number Screen
    @State private var shouldGoToVerifyCodeScreen = false
    
    //Prevents user from typing more digits
    @State private var shouldDisablePhoneTextField = false
    
 
    
    
    


    var body: some View {
        

            
        NavigationView {
               
              
            ZStack {
                    
                    // Background Image
                    Image("backgrounds/background1")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .navigationTitle("Phone Number")
                        .navigationBarColor(backgroundColor: .clear, titleColor: .white)
                
        
                // transistion to Verification Code View Screen
                NavigationLink(destination: VerificationCodeView(), isActive: $shouldGoToVerifyCodeScreen){ EmptyView() }
                
    
                
                    VStack {
                        
                
                /*
                        Text("Enter Your Phone Number")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding()
                        */
                            
                   
                    
                        
                        // Phone Number Field
                        // Used an external framework iPhoneNumberField
                        // Because it's easier to format numbers this way
                        iPhoneNumberField(text: $phone_number_field_text, isEditing: $isEditing)
                            .flagHidden(false)
                            .flagSelectable(true)
                            .font(UIFont(size: 30, weight: .bold, design: .rounded))
                            .prefixHidden(false)
                            .autofillPrefix(true)
                            .formatted(false)
                            .disabled(shouldDisablePhoneTextField==true)
                            .onEdit { numfield in
                            
                                

                                    // A valid phone number was entered
                                if let phoneNumber = numfield.phoneNumber{
                                    
                                    shouldDisablePhoneTextField = true
                                    shouldGoToVerifyCodeScreen = true
                            
                                   
                                    
                                    
                                    PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber.numberString, uiDelegate: nil) { verificationID, error in
                                        
                                        if let error = error{
                                            // An error happened after entering the phone number
                                            print("An error happened: \(error.localizedDescription)")
                                            
                                            // Enable the phone text field again
                                            shouldDisablePhoneTextField = false
                                            
                                            // Goes back to EnterPhoneNumberView if there's an error
                                            shouldGoToVerifyCodeScreen = false
                                            
                                           // Erase phone number field text
                                            phone_number_field_text  = ""
                                        
                                            
                                        }
                                        
                                        
                                       
                                    }
                                    
                                    
                               
                                    
                                }
                                
                            }
                            
                            
                      
                        
                        
                        
                        
                        
                        
                    }
                }
            
            
          
              
            // View Transitions
               /*
                .navigate(to: VerificationCodeView(maxDigits: 6, label: "Enter Verification Code", pin: "", showPin: true){
                    x, y in
                }, when: $shouldGoToVerifyCodeScreen)
            
                
            .navigate(to: EnterPhoneNumberView(), when: $goBackDueToError) */
        }
   
       
    }


    
}




struct EnterPhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EnterPhoneNumberView()
            
        }
    }
}
