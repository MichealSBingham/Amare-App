//
//  BirthdayInputView.swift
//  Amare
//
//  Created by Micheal Bingham on 6/23/23.
//

import SwiftUI

struct BirthdayInputView: View {
    
    @State private var selectedDate = Date()
    
    var body: some View {
        
        VStack{
            
            
            
            
            
            Spacer()
           
            Text("When Did Your Cosmic Journey Begin?")
                .bold()
                .font(.system(size: 40))
                //.lineLimit(1)
               // .minimumScaleFactor(0.01)
                .padding()
            
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.wheel)
                            .padding()
       
            /*
           Text("Enter a username")
                .font(.system(size: 20))
                //.foregroundColor(.white)
                .padding()
            */
       
            
            
         
            
            Spacer()
         
                
            Spacer()
               
 
                
            }

    }
}

struct BirthdayInputView_Previews: PreviewProvider {
    static var previews: some View {
        BirthdayInputView()
    }
}
