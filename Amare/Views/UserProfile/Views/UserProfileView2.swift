//
//  UserProfileView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/16/23.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

struct UserProfileView2: View {
    
    @Injected(\.chatClient) var chatClient
    
    @EnvironmentObject var currentUserDataModel: UserProfileModel
    @ObservedObject  var model: UserProfileModel
    
    @State var selection: Int = 0
    
    @State var showNearbyInteraction: Bool = false
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var hideCustomNavBar: Bool = false
    
    var menuOptions: [String]  = ["Insights", "Their Planets", "Their Story", "Media", "Birth Chart"]
    
    
   
    
  
    fileprivate func messageButton() -> some View {

        return NavigationLink(destination: DirectMessageView(with: model.user?.id ?? "").tabBar(hidden: true))
           
        
        {
            Image(systemName: "envelope.circle")
                .resizable()
                .frame(width: 30, height: 30)
        }
        .buttonStyle(.plain)
    }
    
    func winkAtTheUser() {
        guard let me = currentUserDataModel.user else {
            return
        }
        
        model.sendWink(from: me) { error in
            guard error == nil else {
                print("could not send wink : error \(error)")
                return
            }
            print("did send wink")
        }

    }

    
    fileprivate func winkButton() -> some View {
        return Button {
            guard let me = currentUserDataModel.user else {
                return
            }
            
            model.sendWink(from: me) { error in
                guard error == nil else {
                    print("could not send wink : error \(error)")
                    return
                }
                print("did send wink")
            }
        } label: {
            
            
            
           Text("😉")
                .font(
                Font.custom("SF Pro", size: 30)
                .weight(.black)
                )
                .frame(width: 30)
        }
        .buttonStyle(.plain)
      //  .opacity(model.winkStatus != nil ? 0.5 : 1 ) TODO: This is WRONG! we need to check instead if we send
    }
    
    @ViewBuilder
    fileprivate func nearbyConnectionButton() -> some View {
        Button {
            withAnimation{ showNearbyInteraction.toggle() }
        } label: {
           
            Image("location")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30)
               // .foregroundColor(.blue)
                
        }
        .buttonStyle(.plain)
    }
    
    func cancelFriendRequestAction() {
        guard let current = currentUserDataModel.user else { print("Can't add friend, no signed in user"); return }
        model.cancelFriendRequest()
    }
    
    func addFriendAction(){
        guard let current = currentUserDataModel.user else { print("Can't add friend, no signed in user"); return }
        model.addFriend(currentSignedInUser: current)
    }
    
    func acceptFriendAction(){
        guard let current = currentUserDataModel.user else { print("Can't add friend, no signed in user"); return }
        model.acceptFriendRequest()
    }
    
    fileprivate func friendshipStatusButton() -> some View {
        Button{
            
        print("did tap friendship status")
            if model.friendshipStatus == .requested{
                cancelFriendRequestAction()
            }
            
            if model.friendshipStatus == .notFriends {
                addFriendAction()
                
            }
            
            if model.friendshipStatus == .awaiting{
                acceptFriendAction()
         
            }
            
            
        }
    label: {
        
        
        FriendshipStatusView(friendshipStatus: model.friendshipStatus)
            .frame(width: 35)
            .transition(.scale)
    }
    .disabled( model.friendshipStatus == .friends)
    }
    

    
    
    fileprivate func menuOptionsButton(username: String?) -> some View {
        MenuOptionsView()
            .contextMenu {
                            if model.friendshipStatus == .friends {
                                Button(action: {
                                    // Your remove friend action here
                                }) {
                                    HStack {
                                        Text("Remove as Friend")
                                        Image(systemName: "person.fill.xmark")
                                    }
                                }
                                .foregroundColor(.red)
                            }
                            
                            Button(action: {
                                // Your block action here
                            }) {
                                HStack {
                                    Text("Block \(username ?? "")")
                                    Image(systemName: "hand.raised.fill")
                                }
                            }
                            .foregroundColor(.red)
                            
                            Button(action: {
                                // Your report action here
                            }) {
                                HStack {
                                    Text("Report")
                                    Image(systemName: "flag.fill")
                                }
                            }
                        }
            
        
    }
    
    
    var body: some View {
      
        VStack{
            
            if !hideCustomNavBar{
                CustomNavigationBarView2(name: model.user?.name ?? "", username: model.user?.username ?? "", cancelFriendRequestAction: cancelFriendRequestAction, acceptFriendAction: acceptFriendAction, model: model)
            }
           
            
            ScrollView{ 
            //MARK: - Profile Picture
            CircularProfileImageView(profileImageUrl: model.user?.profileImageUrl, isNotable: model.user?.isNotable, winked: model.winkStatus != nil)
                .frame(width: 100, height: 100)
                .padding(.top, 65)
            
            // .padding()
            
            // MARK: - Name and Username
            ZStack{
                
                NameLabelView(name: model.user?.name, username: model.user?.username)
                
                // MARK: - Friendship Button
                HStack{
                    Spacer()
                    friendshipStatusButton()
                        .frame(width: 35)
                        .padding()
                }
                
            }
            
            /*
             Text(oneLinerSummary ?? "" )
             .multilineTextAlignment(.center)
             // .frame(height: 38)
             .font(.caption)
             .padding(.horizontal)
             //  .border(.white)
             */
            
            
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
            
            /*
             // MARK: - Radial Chart
             RadialChart(progress: model.score)
             .padding()
             */
            //MARK: - Actions, winking messaging, ewtc
            
            HStack{
                
                
                messageButton()
                    .padding()
                
                Spacer()
                
                nearbyConnectionButton()
                    .padding()
                    .sheet(isPresented: $showNearbyInteraction,  content: {
                        FindNearbyUserView( user: model.user! , blindMode: false)
                    })
                
                
                Spacer()
                
                HeartButton(systemImage: "suit.heart.fill", status: model.winkedAtThem ?? false, activeTint: .pink, inActiveTint: .gray) {
                    
                    winkAtTheUser()
                }
                
                    .padding()
                
                
                
                
                
                
                
                
                
                
            }
            .padding()
            // .padding(.top, -10)
            
            
            // MARK: - Tab Bar
            TabBarView(currentTab: $selection, tabBarOptions: menuOptions)
                .padding()
                .padding(.top, -20)
            // MARK: - Content for Tab Bar
            TabView(selection: self.$selection) {
                
                RadialChartAdjustableSize(progress: model.score, size: 200)
                    .padding()
                    .tag(0)
                // MARK: - Planets
                MiniPlacementsScrollView(interpretations: model.natalChart?.interpretations ?? generateRandomPlanetInfoDictionary(), planets: model.natalChart?.planets ?? Planet.randomArray(ofLength: 10))
                    .tag(1)
                
                Text("Planetary Aspects Go Here").tag(2)
                
                PicturesCollectionView(images: model.user?.images ?? []).tag(2)
                    .environmentObject(currentUserDataModel)
                
                PlanetGridView(planets: model.natalChart?.planets ?? Planet.randomArray(ofLength: 5),
                               interpretations: model.natalChart?.interpretations ?? generateRandomPlanetInfoDictionary())
                .tag(4)
                
                
            }
            .frame(height: 500)
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            
        }
            }
            .navigationBarBackButtonHidden(true)
            
        
    }
    
    
    /// Custom Button View
    @ViewBuilder
    func HeartButton(systemImage: String, status: Bool, activeTint: Color, inActiveTint: Color, onTap: @escaping () -> ()) -> some View {
        Button(action: onTap) {
            Image(systemName: systemImage)
                .font(.title2)
                .particleEffect(
                    systemImage: systemImage,
                    font: .body,
                    status: status,
                    activeTint: activeTint,
                    inActiveTint: inActiveTint
                )
                .foregroundColor(status ? activeTint : inActiveTint)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background {
                    Capsule()
                        .fill(status ? activeTint.opacity(0.25) : Color("ButtonColor"))
                }
        }
    }

}

struct UserProfileView2_Previews: PreviewProvider {
    
    static var previews: some View {
        var helper = NearbyInteractionHelper()
        NavigationView{
            UserProfileView2(model: UserProfileModel.previewInstance())
                .environmentObject(UserProfileModel.previewInstance())
                .environmentObject(helper)
                .environmentObject(BackgroundViewModel())
        }
    }
}
