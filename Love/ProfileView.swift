//
//  ProfileView.swift
//  Love
//
//  Created by Micheal Bingham on 6/18/21.
//

import SwiftUI

struct ProfileView: View {
    
    
    var body: some View {
        
        ZStack{
            
            Image("backgrounds/background1")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            
            VStack{
                
                Button("Sign Out") {
                    // Signs out of profile
                }
                
            }
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
