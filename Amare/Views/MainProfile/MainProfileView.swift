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
    
    @State var showSettings: Bool = false
    @State var showProfilePicChange: Bool = false
    
    var menuOptions: [String]  = ["Your Planets", "Your Story", "Media", "Birth Chart"]
    
    var body: some View {
        NavigationView{
            
          
            VStack{
                CustomNavigationBarView(name: "\(model.user?.name ?? "")", username: "\(model.user?.username ?? "")", action: {
                                showSettings = true
                            })

                ScrollView{
                    
                    //MARK: - Profile Image
                    Button {
                        showProfilePicChange.toggle()
                    } label: {
                        CircularProfileImageView(profileImageUrl: model.user?.profileImageUrl, isNotable: model.user?.isNotable)
                            .frame(width: 100, height: 100)
                    }
                    .buttonStyle(.plain)

                    
        
                    
                    //MARK: - Name and Username
                    NameLabelView(name: model.user?.name, username: model.user?.username)
                           .padding()
                    //MARK: - Friend Count & "Big 3"
                    HStack{
                        
                        Text(model.user?.totalFriendCount?.formattedWithAbbreviations() ?? "0")
                            .fontWeight(.black)
                        // .foregroundColor(.blue)
                        
                        
                        Text("Friends")
                            .fontWeight(.ultraLight)
                            .font(.subheadline)
                        
                        PlanetName.Sun.image()
                            .frame(width: 20)
                            .conditionalColorInvert()
                        Text(model.natalChart?.planets.get(planet: .Sun)?.sign.rawValue ?? "-")
                            .fontWeight(.ultraLight)
                            .font(.subheadline)
                        
                        PlanetName.Moon.image()
                            .frame(width: 15)
                            .conditionalColorInvert()
                        Text(model.natalChart?.planets.get(planet: .Moon)?.sign.rawValue ?? "-")
                            .fontWeight(.ultraLight)
                            .font(.subheadline)
                        
                        
                        Image(systemName: "arrow.up")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15)
                        // .conditionalColorInvert()
                        Text(model.natalChart?.angles.get(planet: .asc)?.sign.rawValue ?? "-")
                            .fontWeight(.ultraLight)
                            .font(.subheadline)
                        
                        
                        
                        
                    }
                    
                    
                    
                    // MARK: - Tab Bar
                    TabBarView(currentTab: $selection, tabBarOptions: menuOptions)
                        .padding()
                    // MARK: - Content for Tab Bar
                    TabView(selection: self.$selection) {
                        
                        // MARK: - Planets
                        MiniPlacementsScrollView(interpretations: model.natalChart?.interpretations ?? generateRandomPlanetInfoDictionary(), planets: model.natalChart?.planets ?? Planet.randomArray(ofLength: 10))
                            .tag(0)
                        
                        Text("Planetary Aspects Go Here").tag(1)
                        
                        PicturesCollectionView(images: model.user?.images ?? []).tag(2)
                        
                        PlanetGridView(planets: model.natalChart?.planets ?? Planet.randomArray(ofLength: 5),
                                       interpretations: model.natalChart?.interpretations ?? generateRandomPlanetInfoDictionary())
                        .tag(3)
                        
                        
                    }
                    .frame(height: 500)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                }
                    
                    
                    
                    
                    
                    
                    
                }
          
            .toolbar(.hidden)
            .sheet(isPresented: $showSettings) {
                            SettingsView()
                    //.environmentObject(authService)
                    .environmentObject(model)
                    
                        }
            .sheet(isPresented: $showProfilePicChange){
                ChangeProfilePictureView()
                    .environmentObject(model)
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
                model.natalChart?.planets = Planet.randomArray(ofLength: 5)
                model.interpretations = generateRandomPlanetInfoDictionary()
               
                
            }
            
    }
}
#Preview {
    MainProfileView_Preview()
        .preferredColorScheme(.dark)
}

