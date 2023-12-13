//
//  MainProfileView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/16/23.
//

import SwiftUI
import Photos 
struct MainProfileView: View {
    
    @EnvironmentObject var authService: AuthService

    @EnvironmentObject var model: UserProfileModel
    
  
    
    
    @State var selection: Int = 0
    
    @State var showSettings: Bool = false
    @State var showProfilePicChange: Bool = false
    
    @State private var navigateToFriends = false

    @State var wantMoreAlert: Bool = false
    
    var menuOptions: [String]  = ["Your Planets", "Your Story", "Media", "Chart"]
    
   // let link = URL(string: "https://www.findamare.com")!

    
    var body: some View {
        NavigationView{
            
          
            VStack{
                ZStack{
                    CustomNavigationBarView(name: "\(model.user?.name ?? "")", username: "\(model.user?.username ?? "")", action: {
                                    showSettings = true
                                })
                    .alert(isPresented: $wantMoreAlert) {
                                Alert(
                                    title: Text("Want more stars?"),
                                    message: Text("You have to add friends for more stars. Share with friends and tell them to add you!"),
                                    primaryButton: .cancel(),
                                    secondaryButton: .default(Text("I'll share")) {
                                        shareApp()
                                    }
                                )
                            }
                    
                    HStack{
                      
                        Button{
                            wantMoreAlert = true
                           print("did tap want more")

                        } label: {
                            Text("\(model.user?.stars ?? 0)⭐️")
                                .bold()
                                .padding()
                        }
                        .offset(y: 50)
                        .frame(width: 75, height: 75)
                        
                    
                        .buttonStyle(.plain)
                      
                        
                        
                        Spacer()
                    }
                }
               

                ScrollView{
                    
                    //MARK: - Profile Image
                    Button {
                        
                        changeProfilePicture()
                        
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
                        
                        NavigationLink(destination: FriendsListView(), isActive: $navigateToFriends) {
                            
                            Group {
                                Text(model.user?.totalFriendCount?.formattedWithAbbreviations() ?? "0")
                                    .fontWeight(.black)
                                
                                Text("Friends")
                                    .fontWeight(.ultraLight)
                                    .font(.subheadline)
                            }
                            
                                     .onTapGesture {
                                        self.navigateToFriends = true
                                                }
                                        }
                        .buttonStyle(.plain)
                        
                        
                                                
                        
                      
                        
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
                        MiniPlacementsScrollView(viewedUserModel: model, interpretations: model.natalChart?.interpretations ?? [:], planets: model.natalChart?.planets ?? [])
                            .environmentObject(model)
                            .tag(0)
                        
                        MiniAspectScrollView(viewedUserModel: model, interpretations: model.natalChart?.aspects_interpretations ?? [:], aspects: model.natalChart?.aspects ?? [])
                            .tag(1 )
                            .environmentObject(model)
                        
                        PicturesCollectionView(images: model.user?.images ?? [], isSignedInUser: true, viewedUserModel: model).tag(2)
                            .environmentObject(model)
                        
                        PlanetGridView(planets: model.natalChart?.planets ?? [],
                                       interpretations: model.natalChart?.interpretations ?? [:])
                        
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
    
    
    func changeProfilePicture() {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized {
                    self.showProfilePicChange = true
                }
            }
        } else if status == .authorized {
            self.showProfilePicChange = true
        } else {
            // Handle the case where permission is denied.
        }
    }
    
    func shareApp() {
        guard let urlShare = URL(string: "https://findamare.com") else { return }
        
        if let lastWindow = UIApplication.shared.windows.last {
            let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
            lastWindow.rootViewController?.present(activityVC, animated: true, completion: nil)
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

