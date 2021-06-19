//
//  EnterBirthdayView.swift
//  Love
//
//  Created by Micheal Bingham on 6/18/21.
//

import SwiftUI

struct EnterBirthdayView: View {
    
    
    
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
                
                
            }
            
        }
        
    }
}

struct EnterBirthdayView_Previews: PreviewProvider {
    static var previews: some View {
        EnterBirthdayView()
    }
}
