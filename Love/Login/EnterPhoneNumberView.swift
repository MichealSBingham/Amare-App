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
    
    @State var phone_number_field_text = ""
    @State var isEditing = true
    
    //Goes to Verification Code Screen or back to Phone Number Screen
    @State private var shouldGoToVerifyCodeScreen = false
    
    //Prevents user from typing more digits
    @State private var shouldDisablePhoneTextField = false
    
    @State private var shouldGoToProfile = false
    
    
 //   @StateObject private var account: Account = Account()

    @State private var someErrorOccured: Bool = false
 


    var body: some View {
        
        
            
        NavigationView {
               
           
        
              
            ZStack {
                
                // ******* ======  Transitions -- Navigation Links =======
                        // Goes to Enter Verification Code View
        
                NavigationLink(destination: VerificationCodeView(), isActive: $shouldGoToVerifyCodeScreen){ EmptyView() }
                
                
                
                // ******* ======++++++++++++++++ =======
                
                
                    // Background Image
                    Image("backgrounds/background1")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .navigationTitle("Phone Number")
                        .navigationBarColor(backgroundColor: .clear, titleColor: .white)
                 
                        
                        .alert(isPresented: $someErrorOccured, content: {
                            
                            Alert(title: Text("Some Error"))
                            
                        })
                        
              

                    
                    VStack {
                        
                
              
                   
                    
                        
                        // Phone Number Field
                        // Used an external framework iPhoneNumberField
                        // Because it's easier to format numbers this way
                        iPhoneNumberField("(000) 000-0000", text: $phone_number_field_text, isEditing: $isEditing)
                            .flagHidden(false)
                            .flagSelectable(true)
                            .font(UIFont(size: 30, weight: .bold, design: .rounded))
                            .prefixHidden(false)
                            .autofillPrefix(true)
                            .formatted(false)
                            .disabled(shouldDisablePhoneTextField)
                            .clearsOnInsert(true)
                            .onEditingEnded { numfield in
                            
                                

                                    // A valid phone number was entered
                                if let phoneNumber = numfield.phoneNumber{
                                    
                                  
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
                            
                            
                      
                        
                        
                        
                        
                        
                    }
            } .onDisappear(perform: {
                
                print("Should disappear")
              //  account.stopListening()
            })
            
           
            
          
        }
   
    // Switch to right screen depending on if user is logged in or now
        .onAppear(perform: {
            print("Enter Phone Number View did appear ")
            
          
            
            //account.listen()
            
            
            
        })
        
        
    }


    
}




struct EnterPhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EnterPhoneNumberView()
            
        }
    }
}
