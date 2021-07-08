//
//  EnterGenderView.swift
//  Love
//
//  Created by Micheal Bingham on 7/6/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct EnterGenderView: View {
    
    
    @EnvironmentObject private var account: Account
    @State private var goToNext: Bool = false
    
    
    
    var body: some View {
        
        ZStack{
            
            SetBackground()
            
            // ******* ======  Transitions -- Navigation Links =======
            //                                                      //
            //                Goes to the Profile                   //
            //                                                      //
         /* || */           NavigationLink(                       /* || */
        /* || */   destination: EnterOrientationView().environmentObject(account),
        /* || */           isActive: $goToNext,                  /* || */
        /* || */           label: {  EmptyView()  })             /* || */
        /* || */                                                 /* || */
        /* || */                                                 /* || */
            // ******* ================================ **********
            
            
            HStack{
                
                MakeManButton()
                Spacer()
                MakeWomanButton()
                Spacer()
                MakeOtherButton()
                
            }
            
            
        } .onAppear {
            // set view to restore state 
            doneWithSignUp(state: false)
        }
       
        
        
        
        
        
        
    }
    
    
    
    
    
    
    // ======================================================================================


    func MakeManButton() -> some View  {
        
        return   Button("Man") {
            
            // selected man
            SelectGenderAction(gender: "M")
        }.padding()

        
    }

    func MakeWomanButton() -> some View {
        
        return Button("Woman") {
            
            // selected woman
            SelectGenderAction(gender: "F")
        }.padding()
    }


    /// Once this button is tapped, the user should be able to enter their own custom gender
    func MakeOtherButton() -> some View  {
        
        return Button("Other") {
            
            // selected other
            SelectGenderAction(gender: "O")
            
        }.padding()
    }



    func SetBackground() -> some View {
        
        return Image("backgrounds/background1")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("Hey Micheal, you are a ...")
            .navigationBarColor(backgroundColor: .clear, titleColor: .white)
    }



    // ======================================================================================




    func SelectGenderAction(gender: String)  {
        
        goToNext = true
        
        self.account.data?.sex = gender
        account.save { error in
            
            guard error == nil else{
                // some error happened
                print("Some error happened")
                goToNext = false
                return
            }
        }
        
        
    }





    // =======================================================================================

    
    
}











@available(iOS 15.0, *)
struct EnterGenderView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView{
            EnterGenderView().environmentObject(Account())
        }
       
    }
}
