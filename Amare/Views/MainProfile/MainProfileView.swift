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
                
                Text(model.user?.numberOfFriends?.formattedWithAbbreviations() ?? "0")
                    .fontWeight(.black)
                   // .foregroundColor(.blue)
                
                    
                Text("Friends")
                    .fontWeight(.ultraLight)
                    .font(.subheadline)
                
                PlanetName.Sun.image()
                    .frame(width: 20)
                    .conditionalColorInvert()
                Text(model.natalChart?.planets.get(planet: .Sun)?.name.rawValue ?? "Cancer")
                    .fontWeight(.ultraLight)
                    .font(.subheadline)
                
                PlanetName.Moon.image()
                    .frame(width: 15)
                    .conditionalColorInvert()
                Text(model.natalChart?.planets.get(planet: .Moon)?.name.rawValue ?? "Scorpio")
                    .fontWeight(.ultraLight)
                    .font(.subheadline)
                
                //TODO: Replace this with Rising Sign
                Image(systemName: "arrow.up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 15)
                   // .conditionalColorInvert()
                Text(model.natalChart?.planets.get(planet: .Moon)?.name.rawValue ?? "Capricorn")
                    .fontWeight(.ultraLight)
                    .font(.subheadline)
                   
                    
                
                
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
