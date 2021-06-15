//
//  ContentView.swift
//  Love
//
//  Created by Micheal Bingham on 6/15/21.
//

import SwiftUI
import CoreData


struct SignupView: View {
    
    
    


    var body: some View {
        

        ZStack {
            
            Image("backgrounds/background1")
                .resizable()
                .scaledToFill()
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
               
            
            VStack {
                
            
                Text("Enter Your Phone Number")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                
                
                
                
                
            }
        }
       
   
    }


    
}




struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignupView()
            
        }
    }
}
