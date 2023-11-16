//
//  MainProfileView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/16/23.
//

import SwiftUI

struct MainProfileView: View {
    
    @EnvironmentObject var authService: AuthService

    @EnvironmentObject var model: UserProfileModel
    
    var body: some View {
        
        VStack{
            
            CircularProfileImageView(profileImageUrl: model.user?.profileImageUrl, isNotable: model.user?.isNotable)
                    .frame(width: 100, height: 100)
                    //  .border(.white)
                   // .padding()
                

            NameLabelView(name: model.user?.name, username: model.user?.username)
                        .padding()
        
            HStack{
                
                Text("287")
                    .fontWeight(.black)
                    
                Text("Friends")
                    .fontWeight(.ultraLight)
                    .font(.subheadline)
                
                ZodiacSign.Cancer.image()
                   // .resizable()
                   // .preferredColorScheme(.dark)
                    .conditionalColorInvert()
                    .foregroundColor(.white)
                    .border(.white)
                
                
            }
                    
                
                
           
                
                
                
         
                
               
            
        }
    }
}

struct MainProfileView_Preview: View {
    @StateObject var model: UserProfileModel = UserProfileModel()
    
    var body: some View{
        
        MainProfileView()
            .environmentObject(AuthService.shared)
            .environmentObject(model)
            .onAppear {
                model.user = AppUser.generateMockData()
                
            }
            
    }
}
#Preview {
    MainProfileView_Preview()
        .preferredColorScheme(.dark)
}
