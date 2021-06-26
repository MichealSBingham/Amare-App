//
//  EnterBirthdayView.swift
//  Love
//
//  Created by Micheal Bingham on 6/18/21.
//

import SwiftUI

struct EnterBirthdayView: View {
    
    @EnvironmentObject private var account: Account
    
    @State private var goToNext: Bool = false 
    
    
    var body: some View {
        
        NavigationView{
            
            ZStack{
                
                // Background Image
                Image("backgrounds/background1")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .navigationTitle("When Is Your Birthday?")
                    .navigationBarColor(backgroundColor: .clear, titleColor: .white)
                
                // ******* ======  Transitions -- Navigation Links =======
                
                // Goes to the Profile
                NavigationLink(
                    destination: FromWhereView(),
                    isActive: $goToNext,
                    label: {  EmptyView()  }
                )
                
                // ******* ================================ **********
                
                
                
                
                VStack{
                    
                    DatePicker(selection: .constant(Date()), label: { Text("Birthday") })

                }
                
                
                
                
            } .onAppear {
                doneWithSignUp(state: false)
            }
            
           
       
            
        }
        
    }
}

struct EnterBirthdayView_Previews: PreviewProvider {
    static var previews: some View {
        EnterBirthdayView()
    }
}
