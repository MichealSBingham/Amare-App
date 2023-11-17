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
    
    @State var selection: Int = 0
    
    var menuOptions: [String]  = ["Your Planets", "Your Story", "Media"]
    
    var body: some View {
        
        VStack{
            
        //MARK: - Profile Image
            CircularProfileImageView(profileImageUrl: model.user?.profileImageUrl, isNotable: model.user?.isNotable)
                    .frame(width: 100, height: 100)
                    //  .border(.white)
                   // .padding()
                
        //MARK: - Name and Username
            NameLabelView(name: model.user?.name, username: model.user?.username)
                        .padding()
        //MARK: - Friend Count & "Big 3"
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
                Text(model.natalChart?.planets.get(planet: .Sun)?.sign.rawValue ?? "Cancer")
                    .fontWeight(.ultraLight)
                    .font(.subheadline)
                
                PlanetName.Moon.image()
                    .frame(width: 15)
                    .conditionalColorInvert()
                Text(model.natalChart?.planets.get(planet: .Moon)?.sign.rawValue ?? "Scorpio")
                    .fontWeight(.ultraLight)
                    .font(.subheadline)
                
                //TODO: Replace this with Rising Sign
                Image(systemName: "arrow.up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 15)
                   // .conditionalColorInvert()
                Text(model.natalChart?.planets.get(planet: .Moon)?.sign.rawValue ?? "Capricorn")
                    .fontWeight(.ultraLight)
                    .font(.subheadline)
                   
                    
                
                
            }
                    
        // MARK: - Tab Bar
             TabBarView(currentTab: $selection, tabBarOptions: menuOptions)
                .padding()
        // MARK: - Content for Tab Bar
            TabView(selection: self.$selection) {
            
                // MARK: - Planets
                MiniPlacementsScrollView(interpretations: model.natalChart?.interpretations ?? [:], planets: model.natalChart?.planets ?? [])
                .tag(0)
                
                Text("Planetary Aspects Go Here").tag(1)
                
                Text("Media and Images Go Here").tag(2)
                
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
           
                
                
                
         
                
               
            
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
                model.natalChart?.planets = Planet.randomArray(ofLength: 5)
                model.interpretations = generateRandomPlanetInfoDictionary()
               
                
            }
            
    }
}
#Preview {
    MainProfileView_Preview()
        .preferredColorScheme(.dark)
}
